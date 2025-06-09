// Importing required modules 
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const superagent = require("superagent");
// Importing models
const userModel = require("../models/userModel");
const otpModel = require("../models/otpModel");
const forgotPassowrdOtpModel = require("../models/forgotPasswordOtpModel");
const { signupShema, signinShema, edituserShema } = require("../utils/shemas");
const { z } = require('zod');
let config = require('../config/config');
const { sendOtpcodeTO } = require("../utils/utils");
const randomstring = require('randomstring');

module.exports = {
    checkregisteruser: async (req, res) => {
        // Logic for checking registered user
        const { email } = req.body;
        try {
            const user = await userModel.findOne({ email });
            if (user) {
                return res.status(200).json({ status: true, message: "User already exists" });
            } else {
                return res.status(200).json({ status: false, message: "User does not exist" });
            }
        } catch (error) {
            return res.status(500).json({ status: false, message: "Server error", error });
        }
    },
    signup: async (req, res) => {

        // Logic for user signup
        const { email, password, firstName, lastName, country_code, phone, country, type } = req.body;

        let userData = req.body

        try { signupShema.parse(userData); } catch (e) { throw e; }

        try {
            // Check if the email is already registered
            const existingUser = await userModel.findOne({ email });
            if (existingUser) {
                return res.status(409).json({ status: false, message: "Email is already registered" });
            }

            // Check if the phone number is already registered
            const existingPhone = await userModel.findOne({ phone });
            if (existingPhone) {
                return res.status(409).json({ status: false, message: "Phone number is already registered" });
            }

            // Hash the password
            const hashedPassword = await bcrypt.hash(password, 10);

            // Create a new user
            const newUser = new userModel({
                firstName,
                lastName,
                email,
                password: hashedPassword,
                country_code,
                phone,
                country,
                type,
            });

            // Save the user to the database
            const newcreated = await newUser.save();

            const plainUser = newcreated.toObject();

            let formfields = await new Promise(function (resolve, reject) {
                jwt.sign(plainUser, config.secret, { expiresIn: 60 * 60 * 24 * 60 }, (err, token) => {
                    if (err) reject('Error signing token.' + err);
                    resolve({ ...plainUser, token });
                });
            })


            if (typeof formfields === "object") {
                // Generate an OTP for email verification
                sendOtpcodeTO(plainUser, "signup");

                res.status(201).json({
                    status: true,
                    data: formfields
                });
            } else {
                throw formfields;
            }


        } catch (error) {
            return res.status(500).json({ status: false, message: "Server error", error });
        }
    },
    signin: async (req, res) => {
        // Logic for user sign-in
        const { email, password } = req.body;
        console.log({ email, password });
        try { signinShema.parse({ email, password }); } catch (e) { throw e; }

        let query = { email };

        let user = await userModel.findOne(query)

        if (!user) {
            throw 'Vous n\'êtes pas inscrit !';
        }

        // if (!user.itemaccess) {
        //     user.itemaccess = await ItemAccess.findOne({ ID: 1 })
        // }


        const correct = await bcrypt.compare(password, user.password)



        if (correct) {
            const plainUser = {
                id: user.ID,
                _id: user._id,
                email: user.email,
                level: user.level,
                firstName: user.firstName,
                lastName: user.lastName,
                username: user.username,
                fullName: `${user.firstName} ${user.lastName}`.trim(),
                phone: user.phone || null,
                country_code: user.country_code || null,
                isBlocked: user.is_active || false,
                lastOnline: user.lastOnline || null,
                user_DOB: user.birthdate || null,
                favorites: user.favorites || [],
                imageUrl: user.imageUrl,
                placeOfBirth: user.placeOfBirth || '',
                address: user.address || '',
                gender: user.gender || '',
                meta: user.meta || {},
                about: user.about || null,
                level: user.level || null,
                type: user.type || null,
                itemaccess: user.itemaccess || null,
                verifiedAt: user.verifiedAt || null,
            };

            let formfields = await new Promise(function (resolve, reject) {
                jwt.sign(plainUser, config.secret, { expiresIn: 60 * 60 * 24 * 60 }, (err, token) => {
                    if (err) reject('Error signing token.' + err);
                    resolve({ ...plainUser, token });
                });
            })
            if (typeof formfields === "object") {
                return res.status(200).json({ data: formfields, token: formfields.token, status: true, okmessage: "Sign-in successful" });
            } else {
                throw formfields;
            }

        } else {
            return res.status(200).json({ status: false, message: "Email ou mot de passe incorrect !" });
        }

    },

    useredit:
        async (req, res) => {
            const userId = req.user._id;
            const updateData = req.body;
            console.log(updateData);


            const user = await userModel.findById(userId);

            try { edituserShema.parse(updateData); } catch (e) { throw e; }
            if (updateData.password && updateData.user_newPassword && updateData.user_confirmPassword) {


                console.log(updateData.password, user.password);

                const correct = await bcrypt.compare(updateData.password, user.password)



                if (!correct) {
                    return res.status(400).json({ status: false, message: "Mot de passe incorrect" });
                }



                if (updateData.user_newPassword !== updateData.user_confirmPassword) {
                    return res.status(400).json({ status: false, message: "les mots de passe ne correspondent pas" });
                }
                // Hash the new password
                updateData.password = await bcrypt.hash(updateData.user_newPassword, 10);
            } else {
                delete updateData.password; // Remove password field if not provided
            }
            // Remove fields that are not allowed to be updated
            delete updateData.user_newPassword;
            delete updateData.user_confirmPassword;
            try {
                const user = await userModel.findByIdAndUpdate(
                    userId,
                    { $set: updateData },
                    { new: true, runValidators: true }
                ).select('-password');

                if (!user) {
                    return res.status(404).json({ status: false, message: "User not found" });
                }

                return res.status(200).json({ status: true, data: user });
            } catch (error) {
                return res.status(500).json({ status: false, message: "Server error", error });
            }
        },
    verifyotp: async (req, res) => {
        // Logic for verifying OTP
        const { email, otp } = req.body;
        try {
            const otpRecord = await otpModel.findOne({ email, otp });
            if (otpRecord) {
                await userModel.updateOne({ email }, { verifiedAt: new Date() });
                return res.status(200).json({ status: true, data: { message: "OTP verified successfully" } });
            } else {
                return res.status(400).json({ status: false, message: "Invalid OTP" });
            }
        } catch (error) {
            return res.status(500).json({ status: false, message: "Server error", error });
        }
    },
    interestedCategory: async (req, res) => {
        // Logic for interested category
        const { userId, categories } = req.body;
        try {
            const user = await userModel.findById(userId);
            if (user) {
                user.interestedCategories = categories;
                await user.save();
                return res.status(200).json({ status: true, message: "Categories updated successfully" });
            } else {
                return res.status(404).json({ status: false, message: "User not found" });
            }
        } catch (error) {
            return res.status(500).json({ status: false, message: "Server error", error });
        }
    },

    isverifyaccount: async (req, res) => {
        // Logic for verifying account
        const { email } = req.body;
        try {
            const user = await userModel.findOne({ email });
            if (user) {
                if (user.verifiedAt) {
                    return res.status(200).json({ status: true, message: "Account is verified" });
                } else {
                    return res.status(400).json({ status: false, message: "Account is not verified" });
                }
            } else {
                return res.status(404).json({ status: false, message: "User not found" });
            }
        } catch (error) {
            return res.status(500).json({ status: false, message: "Server error", error });
        }
    },
    resendotp: async (req, res) => {
        // Logic for resending OTP
        const { email } = req.body;
        try {
            const user = await userModel.findOne({ email });
            if (user) {
                const otp = randomstring.generate({
                    length: 6,
                    charset: 'numeric',
                });
                await otpModel.create({ email, otp });
                // Send OTP to user's email (not implemented here)
                return res.status(200).json({ status: true, message: "OTP resent successfully" });
            } else {
                return res.status(404).json({ status: false, message: "User not found" });
            }
        } catch (error) {
            return res.status(500).json({ status: false, message: "Server error", error });
        }
    },
    forgotpassword: async (req, res) => {
        // Logic for forgot password
        const { email } = req.body;
        try {
            const user = await userModel.findOne({ email });
            if (user) {
                const otp = randomstring.generate({
                    length: 6,
                    charset: 'numeric',
                });
                await forgotPassowrdOtpModel.create({ email, otp });
                // Send OTP to user's email (not implemented here)
                return res.status(200).json({ status: true, message: "OTP sent for password reset" });
            } else {
                return res.status(404).json({ status: false, message: "User not found" });
            }
        } catch (error) {
            return res.status(500).json({ status: false, message: "Server error", error });
        }
    },
    forgotpasswordotpverification: async (req, res) => {
        // Logic for forgot password OTP verification
        const { email, otp } = req.body;
        try {
            const otpRecord = await forgotPassowrdOtpModel.findOne({ email, otp });
            if (otpRecord) {
                await forgotPassowrdOtpModel.deleteOne({ email, otp });
                return res.status(200).json({ status: true, message: "OTP verified successfully" });
            } else {
                return res.status(400).json({ status: false, message: "Invalid OTP" });
            }
        } catch (error) {
            return res.status(500).json({ status: false, message: "Server error", error });
        }
    },
    resetpassword: async (req, res) => {
        // Logic for resetting password
        const { email, newPassword } = req.body;
        const hashedPassword = await bcrypt.hash(newPassword, 10);
        try {
            const user = await userModel.findOne({ email });
            if (user) {
                user.password = hashedPassword;
                await user.save();
                return res.status(200).json({ status: true, message: "Password reset successfully" });
            } else {
                return res.status(404).json({ status: false, message: "User not found" });
            }
        } catch (error) {
            return res.status(500).json({ status: false, message: "Server error", error });
        }
    },
    getuser: async (req, res) => {
        // Logic for getting user details
        const userId = req.user._id; // Assuming user ID is available in req.user
        try {
            const user = await userModel.findById(userId).select('-password');
            if (user) {

                return res.status(200).json({ status: true, data: user });
            } else {
                return res.status(404).json({ status: false, message: "User not found" });
            }
        } catch (error) {
            return res.status(500).json({ status: false, message: "Server error", error });
        }
    },
    uploadimage: async (req, res) => {
        // Logic for uploading image
        const userId = req.user._id; // Assuming user ID is available in req.user

    },
    mapsearch: async (req, res) => {
        let fields = req.body

        // Add query params for the search
        fields.city = fields.city;
        fields.format = 'json';  // Ensure the response format is JSON
        fields.addressdetails = 1;  // Optional: To get more detailed address information


        // Call the Nominatim search API to get the autocomplete results
        let infos;
        try {
            infos = await superagent
                .get(`https://${config.nominatim.api_url}/search`)
                .query(fields)
                .set("accept", "application/json")
                .set("User-Agent", "yambro");
        } catch (error) {
            console.log(error);
            throw "search_failed";
        }

        const { text, status } = infos;
        let response = { places: JSON.parse(text), status };

        if (response.places.length === 0) {
            return res.status(200).json({
                status: true,
                text: "No results found",
            });
        }

        // You can modify the response to only include relevant fields for autocomplete
        const autocompleteResults = response.places.map((place) => {
            let house_number = place.address.house_number;
            let road = place.address.road || place.address.footway || place.address.path || place.address.track || place.address.street || place.address.suburb || place.address.village || place.address.town || place.address.city;
            let city = place.address.city || place.address.town || place.address.village || place.address.suburb || place.address.hamlet || place.address.locality;
            let state = place.address.state || place.address.region || place.address.county || place.address.district || place.address.province || place.address.area;
            let country = place.address.country || place.address.country_code || place.address.continent || place.address.state_district || place.address.state_code || place.address.postcode || place.address.postalcode || place.address.postal_town || place.address.city_district || place.address.city_block || place.address.city_section || place.address.city_area || place.address.city_part || place.address.city_subdivision || place.address.city_neighborhood || place.address.city_region || place.address.city_zone || place.address.city_sector || place.address.city_quarter;

            return {
                name: place.display_name,
                display_name: `${house_number ? `${house_number}, ` : ''}${road ? `${road}, ` : ''}${city ? `${city}, ` : ''}${state ? `${state}, ` : ''}${country ? `${country}` : ''}`,
                lat: place.lat,
                lon: place.lon,
                id: place.osm_id, // Use this as a unique identifier for the place
                country: place.address.country
            }

        });
        return res.status(200).json({
            status: true,
            data: {
                places: autocompleteResults,
                status: status
            }
        });
    },

    deleteaccountuser: async () => {
        // Logic for deleting user account
    },
    splash: async () => {
        // Logic for splash screen
    },
    organizer: async () => {
        // Logic for fetching organizer details
    },
    sponsor: async () => {
        // Logic for fetching sponsor details
    },
    eventdetails: async () => {
        // Logic for fetching event details
    },
    search: async () => {
        // Logic for searching events
    },
    getAllTag: async () => {
        // Logic for fetching all tags
    },
    getEventsByTagId: async () => {
        // Logic for fetching events by tag ID
    },
    getAllCoupon: async () => {
        // Logic for fetching all coupons
    },
    checkCoupon: async () => {
        // Logic for checking coupon validity
    },
    bookticket: async () => {
        // Logic for booking tickets
    },
    allbookedticket: async () => {
        // Logic for fetching all booked tickets
    },
    upcomingticket: async () => {
        // Logic for fetching upcoming tickets
    },
    pastbookedticket: async () => {
        // Logic for fetching past booked tickets
    },
    cancelTicket: async () => {
        // Logic for canceling tickets
    },
    addFavouriteEvent: async () => {
        // Logic for adding favorite event
    },
    getAllFavouriteEvent: async () => {
        // Logic for fetching all favorite events
    },
    deleteFavouriteEvent: async () => {
        // Logic for deleting favorite event
    },
    getAllNotification: async () => {
        // Logic for fetching all notifications
    },
    paymentgateway: async () => {
        // Logic for payment gateway
    },
    getpage: async () => {
        // Logic for fetching page details
    },
    getcurrencytimezone: async () => {
        // Logic for fetching currency and timezone
    },
    getotp: async () => {
        // Logic for generating OTP
    },
    getforgotpasswordotp: async () => {
        // Logic for generating forgot password OTP
    },
};