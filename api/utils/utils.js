const xss = require('xss');
const jwt = require('jsonwebtoken');
const config = require('../config/config');
const { ObjectId } = require('mongodb');
const otpModel = require("../models/otpModel");
var randomstring = require("randomstring");

const moment = require("moment");
const { sendOtpMail } = require('../services/sendmail');

function numerizeObject(obj) {
    if (typeof obj !== 'object' || obj === null) {
        return obj;
    }
    for (let key in obj) {
        if (obj.hasOwnProperty(key)) {
            const value = obj[key];
            if (typeof value === 'string' && !isNaN(value) && value.trim() !== '') {
                obj[key] = parseFloat(value);
            }
            else if (typeof value === 'object' && value !== null) {
                numerizeObject(value);
            }
        }
    }

    return obj;
}
module.exports = {
    /**
     *
     * @param {shema} o1 fi
     * @param {raw} o2 fo
     * @returns object without not wanted keys
     */
    SimilKeys(o1, o2, axss = true) {
        const isObject = (obj) => obj && typeof obj === 'object' && !Array.isArray(obj);

        const deepSimilKeys = (obj1, obj2) => {
            let result = {};
            const keys = Object.keys(obj1);
            for (const key in obj2) {
                if (keys.includes(key)) {
                    if (typeof obj2[key] == "boolean") {
                        result[key] = obj2[key];
                    } else
                        if (isObject(obj2[key])) {
                            result[key] = deepSimilKeys(obj1[key], obj2[key]);
                        } else {
                            result[key] = axss ? (Array.isArray(obj2[key])
                                ? obj2[key].map(item => xss(item))  // sanitize each element of the array
                                : xss(obj2[key])) : obj2[key];
                        }
                }
            }
            return result;
        };

        return deepSimilKeys(o1, o2);
    },

  /**
   *convetir en nombre les propriétés à valeurs numériques
   */ Numberrise: (res) => {
        for (var key in res) {

            if (typeof res[key] == "boolean") {
                res[key] = res[key];

            } else
                if (!isNaN(res[key])) {
                    res[key] = Number(res[key]);
                }
        }
        return res;
    },
    verifyToken(token) {
        return new Promise((resolve, reject) => {
            jwt.verify(token, config.secret, (err, decoded) => {
                if (err) {
                    reject('Token verification failed: ' + err.message);
                } else {
                    resolve(decoded); // This contains the payload if verification is successful
                }
            });
        });
    }
    ,
  /**
   *ordon list based on @param {compar} a property
   */ ordoner(res, compar, order = 1) {
        return res.sort(function compare(a, b) {
            let fi = compar ? a[compar] : a;
            let se = compar ? b[compar] : b;
            if (fi < se) {
                return -order || -1;
            }
            if (fi > se) {
                return order || 1;
            }
            return 0;
        });
    },
    /**
     *compare two array a and b
     */
    compareArray(a, b) {
        for (const v of new Set([...a, ...b]))
            if (a.filter((e) => e === v).length !== b.filter((e) => e === v).length)
                return false;
        return true;
    },

    /**
     *to convert data to strin date format "yyyy/mm/dd"
     * @param {conv} time the ms time
     */
    date_to_string(last_modified, whithHour) {
        if (last_modified) {
            last_modified = new Date(last_modified);
            let year = last_modified.getFullYear();
            let month = last_modified.getMonth() + 1;
            let dt = last_modified.getDate();

            if (dt < 10) {
                dt = "0" + dt;
            }
            if (month < 10) {
                month = "0" + month;
            }
            let strdate = year + "-" + month + "-" + dt;
            strdate += whithHour
                ? " , " + last_modified.getHours() + ":" + last_modified.getMinutes()
                : "";

            return strdate;
        }
    },
    /**
     *join les noms par des tirets @param {compar} a property
     */
    hypheny(res) {
        return res.replace(/\s+/g, "-");
    },
    getRandomElement(arr) { return arr[Math.floor(Math.random() * arr.length)] },

  /**
   *distibct element in array
   */ uniquize(res, po) {
        const result = [];
        const map = new Map();
        for (const item of res) {
            if (!map.has(item[po])) {
                map.set(item[po], true);
                result.push(item);
            }
        }
        return result;
    },
    async generatemediaId(obj, prex = "") {
        let id = obj._id.toString();

        let result = `${obj.ID}`;

        return (`${prex}${result}${(id.substring(0, id.length - (prex.length + result.length)))}`);
    },
    isValidObjectId(id) {
        // Check if the id is a valid ObjectId
        if (typeof id !== 'string') {
            return false;
        }
        return ObjectId.isValid(id) && new ObjectId(id).toString() === id;
    }, isVideoID(id) {
        var isVideo = `${id}`.startsWith("fed");
        return isVideo;
    }, generateRandomArray(minSize, maxSize, generator) {
        const size = Math.floor(Math.random() * (maxSize - minSize + 1)) + minSize;
        return Array.from({ length: size }, generator);
    },
    numerizeObject,
    isStringInArray(array, value) {
        // Ensure the array is actually an array and is not null or undefined
        if (!Array.isArray(array) || !array) {
            return false;
        }

        // Ensure value is a string (convert to string if it's not)
        const stringValue = (value != null) ? value.toString() : '';

        // Ensure the value exists in the array and check for string matching
        return array.some(item => {
            // Ensure each item in the array is a string before checking
            return item && item.toString && item.toString().toLowerCase() === stringValue.toLowerCase();
        });
    },
    async sendOtpcodeTO(user, type = "signup", meethod = "email") {
        const otp = randomstring.generate({
            length: 6,
            charset: 'numeric',
        });

        await otpModel.create({
            email: user.email,
            otp,
            expires: moment().add(10, 'minutes').toDate(),
        });

        console.log("Generated OTP:", otp); // Log the generated OTP

        // Send OTP to user's email (not implemented here)
        // Example: await sendEmail(email, "Verify your account", `Your OTP is ${otp}`);

        switch (meethod) {
            case "email":
                if (type == "signup")
                    await sendOtpMail(otp, `${user.email}`, `${user.firstName}`, `../views/mail-templates/`);
                else
                    await sendEmail(email, "Reset your password", `Your OTP is ${otp}`);
                break;
            case "sms":
                await sendSMS(email, `Your OTP is ${otp}`);
                break;
            case "push":
                await sendPushNotification(email, `Your OTP is ${otp}`);
                break;
            default:
                console.log("Invalid method");
                break;

        }
    },
    checkUniqueKey: (arr, key, label) => {
        let values = []

        if (!Array.isArray(key)) {
            values = arr.map(obj => obj[key]);

        } else {
            arr.forEach(obj => {
                key.forEach(k => {
                    if (obj[k] !== undefined) {
                        values.push(obj[k]);
                    }
                });
            });
        }
        const uniqueValues = new Set(values);
        if (uniqueValues.size !== values.length) {
            throw new Error(`${label}`);
        }
        return uniqueValues
    },
    getTestingStates(state) {
        const states = config.defaultTestingStates;
        return states[state] || states[Object.keys(states)[0]];
    },
    getState(state) {
        const states = config.defaultStates;
        return states[state] || states[Object.keys(states)[0]];
    },
    getHeatingType(type) {
        const types = config.heatingTypes;
        return types[type] || types[Object.keys(types)[0]];
    },
    getHeatingMode(mode) {
        const modes = config.heatingmODes;
        return modes[mode] || modes[Object.keys(modes)[0]];
    },
    gettempfilePath(extenxion = "pdf") {
        const uniq = randomstring.generate({
            length: 15,
            charset: 'alphanumeric',
        });
        let path = `${config.tempFilePath}${uniq}.${extenxion}`;

        return path;
    },
    getcompteurName(type) {
        const types = config.compteurs;
        return types[type] || types[Object.keys(types)[0]];
    },
    getFullDate(thedate, withHour = true) {

        const hourOfEntryReview = new Date(thedate).toLocaleTimeString('fr-FR', {
            hour: '2-digit',
            minute: '2-digit',
        });
        const dateOfEntryReview = new Date(thedate).toLocaleDateString('fr-FR', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
        });
        return withHour ? `${dateOfEntryReview} à ${hourOfEntryReview}` : dateOfEntryReview;
    },
    getRoleName(role) {
        const roles = config.roles;
        return roles[role] || roles[Object.keys(roles)[0]];
    },
    getReviewExplicitName(type, reverse = false) {
        if (reverse) {
            return type != "exit" ? "sortant" : "entran";
        }
        return type == "exit" ? "sortant" : "entran";
    }
};
