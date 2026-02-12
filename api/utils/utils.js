const xss = require('xss');
const jwt = require('jsonwebtoken');
const config = require('../config/config');
const { ObjectId } = require('mongodb');
const otpModel = require("../models/otpModel");
var randomstring = require("randomstring");
const OwnerSchema = require("../models/ownerModel")
const TenantSchema = require("../models/tenantModel")

const moment = require("moment");
const { sendOtpMail, sendRessetpasswordOtpMail } = require('../services/sendmail');
const settingModel = require("../models/settingModel");

const LoginAttempt = require("../models/LoginAttemptModel");

const MAX_ATTEMPTS = 5;
const WINDOW_SECONDS = 15 * 60; // 15 minutes
const ATTEMPT_TTL_SECONDS = WINDOW_SECONDS; // TTL pour compteur, on peut ajuster

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
    isLockedLogin: async function (email, ip) {
        const record = await LoginAttempt.findOne({ email, ip });
        if (!record) return { locked: false, retryIn: 0 };

        if (record.lockedUntil && record.lockedUntil > new Date()) {
            const retryIn = Math.ceil((record.lockedUntil - Date.now()) / 1000);
            return { locked: true, retryIn };
        }

        return { locked: false, retryIn: 0 };
    },
    recordFailedAttempt: async function (email, ip) {
        const record = await LoginAttempt.findOne({ email, ip });

        // console.log(email, ip, record);


        if (!record) {
            return await LoginAttempt.create({ email, ip, attempts: 1 });
        }

        record.attempts += 1;

        if (record.attempts >= MAX_ATTEMPTS) {
            record.lockedUntil = new Date(Date.now() + ATTEMPT_TTL_SECONDS * 1000);
        }

        await record.save();
        return record;
    },
    resetAttempts: async function (email, ip) {
        await LoginAttempt.deleteOne({ email, ip });
    },
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
        // revoke previous otps
        await otpModel.updateMany(
            {
                email: user.email,
                isVerified: false,
                isRevoked: false,
            },
            { $set: { isRevoked: true } }
        );
        await otpModel.create({
            email: user.email,
            otp,
            expires: moment().add(10, 'minutes').toDate(),
        });

        console.log("Generated OTP:", otp); // Log the generated OTP

        switch (meethod) {
            case "email":
                if (type == "signup")
                    await sendOtpMail(otp, `${user.email}`, `${user.firstName}`);
                else if (type == "passwordReset")
                    await sendRessetpasswordOtpMail(otp, `${user.email}`, `${user.firstName}`);
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
            arr.forEach(obj => {
                if (obj[key] !== undefined) {
                    values.push(obj[key]);
                }
            });
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
    },
    generateShield() {
        const shield = randomstring.generate({ length: 120, charset: 'alphanumeric', capitalization: 'lowercase', });
        return shield;
    },
    async personFillers(tenant, theScheme) {
        if (tenant.type === 'physique') {
            delete tenant.representant;
            return await theScheme.create({ type: tenant.type, lastname: tenant.lastname, firstname: tenant.firstname, dob: tenant.dob, placeofbirth: tenant.placeofbirth, address: tenant.address, phone: tenant.phone, email: tenant.representant?.email ?? tenant.email });
        } else if (tenant.type === 'morale') {

            const representant = await theScheme.create({ type: "physique", lastname: tenant.representant.lastname, firstname: tenant.representant.firstname, dob: tenant.dob, placeofbirth: tenant.placeofbirth, phone: tenant.representant.phone, address: tenant.address, email: tenant.representant.email ?? tenant.email });
            return await theScheme.create({ type: tenant.type, denomination: tenant.denomination, representant: representant._id, dob: tenant.dob, address: tenant.address, phone: tenant.phone, email: tenant.representant?.email ?? tenant.email });
        }
    },

    getEstablishedDate(meta) {
        return Object.values(meta?.signatures || {}).reduce((latest, sig) => {
            const sigDate = new Date(sig.timestamp);
            return !latest || sigDate > latest ? sigDate : latest;
        }, null) ? module.exports.getFullDate(Object.values(meta?.signatures || {}).reduce((latest, sig) => {
            const sigDate = new Date(sig.timestamp);
            return !latest || sigDate > latest ? sigDate : latest;
        }, null)) : '';
    },

    authorname(author) {
        const capitalizeFirstLetter = (str) => {
            if (!str) return '';
            return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
        };

        let result = author.type === "morale"
            ? capitalizeFirstLetter(author.denomination || '')
            : `${capitalizeFirstLetter(author.firstname || author.firstName || '')} ${capitalizeFirstLetter(author.lastname || author.lastName || '')}`.trim();

        return result || "<>";
    },

    generateResponse: intent => {
        // Generate a response based on the intent's status
        switch (intent.status) {
            case "requires_action":
                // Card requires authentication
                return {
                    clientSecret: intent.client_secret,
                    requiresAction: true,
                    status: intent.status
                }
            case "requires_payment_method":
                // Card was not properly authenticated, suggest a new payment method
                return {
                    error: "Your card was denied, please provide a new payment method"
                }
            case "succeeded":
                // Payment is complete, authentication not required
                // To cancel the payment after capture you will need to issue a Refund (https://stripe.com/docs/api/refunds).
                console.log("💰 Payment received!")
                return { clientSecret: intent.client_secret, status: intent.status }
        }

        return {
            error: "Failed"
        }
    }, async getAuthorById(id) {

        if (!id || !module.exports.isValidObjectId(id)) {
            return null;
        }

        var tenant = await OwnerSchema.findById(id) ?? await TenantSchema.findById(id)
        return {
            id: tenant._id,
            type: tenant.type,
            name: module.exports.authorname(tenant),
            email: tenant.email,
            phone: tenant.phone,
            address: tenant.address
        };
    }, async getDefaultPieceCopy() {

    },
    validateDatabyScheme: (theSheme, data, res) => {
        const validationResult = theSheme.safeParse(data);

        if (!validationResult.success) {
            let messages = "Une erreur s'est produite lors de la validation des données du plan.";
            if (validationResult.error?.message) {
                messages = JSON.parse(validationResult.error.message);
                messages = messages.reduce((acc, error) => {
                    const fieldPath = error.path.join('.');
                    acc[fieldPath] = error.message;
                    return acc;
                }, {});
                res.status(400).json(messages);
                return false;
            }
            throw messages;
        }
        return true;
    },
    AllvaluesNullorEmpyObject: (obj) => {
        return Object.values(obj).every(x => x === null || x === "" || (typeof x === 'object' && Object.keys(x).length === 0));
    },
    ApplyCodeToPrice: (ammount, coupon) => {

        let newAmmount = ammount;

        if (Array.isArray(coupon)) {

            coupon.forEach(c => {
                if (c.type === 'percentage') {
                    newAmmount = newAmmount - (newAmmount * c.discount / 100);
                } else if (c.type === 'fixed') {
                    newAmmount = newAmmount - (c.discount * 100);
                } else if (c.type === 'free') {
                    newAmmount = 0.0;
                }
            });
        } else {

            if (coupon.type === 'percentage') {
                newAmmount = ammount - (ammount * coupon.discount / 100);
            } else if (coupon.type === 'fixed') {
                newAmmount = ammount - coupon.discount;
            } else if (coupon.type === 'free') {
                newAmmount = 0.0;
            }
        }
        return newAmmount >= 0.0 ? newAmmount : 0.0;
    },
    getClientIp: (req) => {
        // Priorité aux IP passées par le proxy
        const forwarded =
            req.headers['x-forwarded-for'] ||
            req.headers['cf-connecting-ip'] ||
            req.headers['x-real-ip'];

        let ip = '';
        if (forwarded) {
            ip = (Array.isArray(forwarded) ? forwarded[0] : forwarded)
                .split(',')[0]
                .trim();
        }

        // Fallback si pas d’en-têtes
        if (!ip) {
            ip = req.ip || req.socket?.remoteAddress || req.connection?.remoteAddress || '';
        }

        // Normalisation
        if (ip === '::1') return '127.0.0.1';
        if (ip.startsWith('::ffff:')) return ip.slice(7);
        return ip;
    },

    generateAccessCode: () => {
        const code = randomstring.generate({ length: 8, charset: 'alphanumeric', capitalization: 'uppercase' });
        const qrData = `JET-${code}`;
        return qrData;
    },
    buildGsCommand: (input, output, quality = process.env.GS_QUALITY || 'prepress') => {
        const base = [
            '-sDEVICE=pdfwrite',
            '-dCompatibilityLevel=1.7',
            ...(quality === 'prepress' ? ['-dPDFSETTINGS=/prepress']
                : quality === 'printer' ? ['-dPDFSETTINGS=/printer']
                    : quality === 'ebook' ? ['-dPDFSETTINGS=/ebook']
                        : ['-dPDFSETTINGS=/default']),
            '-dEmbedAllFonts=true',
            '-dSubsetFonts=true',
            '-dCompressFonts=true',
            '-dDetectDuplicateImages=true',
            ...(quality === 'prepress' ? [
                '-dDownsampleColorImages=false',
                '-dDownsampleGrayImages=false',
                '-dDownsampleMonoImages=false',
            ] : [
                '-dDownsampleColorImages=true', '-dColorImageDownsampleType=/Bicubic', '-dColorImageResolution=300',
                '-dDownsampleGrayImages=true', '-dGrayImageDownsampleType=/Bicubic', '-dGrayImageResolution=300',
                '-dDownsampleMonoImages=true', '-dMonoImageResolution=1200',
            ]),
            '-sColorConversionStrategy=LeaveColorUnchanged',
            '-dAutoRotatePages=/None',
            '-dNOPAUSE', '-dQUIET', '-dBATCH',
            `-sOutputFile=${output}`,
            input
        ];
        return `gs ${base.join(' ')}`;
    },
    writeToFile: async (data, path = "public/documents/temp/myconsole") => {
        const fs = require('fs').promises;
        try {
            await fs.writeFile(path, data);
        } catch (error) {
            console.error(`Error writing to file at ${path}:`, error);
        }
    },
    logfile: async (data, path = "logs/server.log") => {
        const fs = require('fs').promises;
        try {
            await fs.mkdir(require('path').dirname(path), { recursive: true });
            //[date] message
            const message = `[${new Date().toISOString()}] ` + (typeof data === 'string' ? data : JSON.stringify(data));
            await fs.appendFile(path, message.endsWith('\n') ? message : message + '\n');
        } catch (error) {
            console.error(`Error writing to file at ${path}:`, error);
        }
    },
    getPaymentMethodDisplayName: (method) => {
        const methods = config.paymentMethods;
        return methods[method] || methods[Object.keys(methods)[0]];
    },
    getPlanName: (planKey) => {
        switch (planKey) {
            case "68abb489ac5240298a887669":
                return 'Procurations + Etats des lieux';
            case "68abb80942d054383a78498e":
                return 'Etat des lieux simple';
            default:
                return 'Etat des lieux';
        }
    },
    getUserDeviceInfo: (req) => {
        const device = req.headers['x-access-device'] || req.headers['X-Access-Device'];
        const userAgent = req.headers['user-agent'] || '';
        const ip = module.exports.getClientIp(req);
        return { userAgent, ipAddress: ip, device: device || '' };
    }

};
global.writeToFile = module.exports.writeToFile;
global.logfile = module.exports.logfile;