// Importing required modules 

// Importing models
const config = require("../config/config");
const loginModel = require("../models/adminLoginModel");
const currencyTimezoneModel = require("../models/currencyTimezoneModel");
const mailModel = require("../models/mailModel");
const SettingModel = require("../models/settingModel");

// Load and render the currency view
const loadCurrencyTimeZone = async (req, res) => {

    try {

        const currencyTimezone = await currencyTimezoneModel.findOne();

        return res.render("currencyTimeZone", { currencyTimezone });

    } catch (error) {
        console.log(error.message);
    }
}

// edit currency
const editCurrencyTimeZone = async (req, res) => {

    try {

        const loginData = await loginModel.findById(req.session.adminId);

        if (loginData && loginData.is_admin === 0) {
            req.flash('error', 'You don\'t have permission to set currency & timezone. As a demo admin, you can only view the content.');
            return res.redirect('/currency-timezone');
        }

        // Extract data from the request
        const id = req.body.id;
        const currency = req.body.currency;
        const timezone = req.body.timezone;

        if (id) {
            // Update existing document
            result = await currencyTimezoneModel.findByIdAndUpdate(id, { $set: { currency, timezone } }, { new: true });
        } else {
            // Create a new document
            result = await currencyTimezoneModel.create({ currency, timezone });
        }

        // Handle success or failure
        if (result) {
            req.flash("success", id ? "Currency and timezone updated successfully." : "Currency and timezone added successfully.");
        } else {
            req.flash("error", "Failed to add or update currency and timezone.");
        }

        return res.redirect('/currency-timezone');

    } catch (error) {
        console.log(error.message);
    }
}

// Load and render the mail view
const loadMailConfig = async (req, res) => {

    try {

        const mailData = await mailModel.findOne();

        return res.render("mailConfig", { mailData });

    } catch (error) {
        console.log(error.message);
    }
}

//edit mail config
const mailConfig = async (req, res) => {

    try {

        const loginData = await loginModel.findById(req.session.adminId);

        if (loginData && loginData.is_admin === 1) {

            // Extract data from the request
            const id = req.body.id;
            const host = req.body.host;
            const port = req.body.port;
            const mail_username = req.body.mail_username;
            const mail_password = req.body.mail_password;
            const encryption = req.body.encryption;
            const senderEmail = req.body.senderEmail;

            let result;

            if (id) {
                result = await mailModel.findByIdAndUpdate(id, { host, port, mail_username, mail_password, encryption, senderEmail }, { new: true });
            } else {
                result = await mailModel.create({ host, port, mail_username, mail_password, encryption, senderEmail });
            }

            if (result) {

                req.flash("success", id ? "Mail configuration updated successfully." : "Mail configuration added successfully.");
                return res.redirect('/mail-config');

            } else {

                req.flash("error", "Operation failed. Try again later.");
                return res.redirect('/mail-config');
            }

        }
        else {

            req.flash('error', 'You have no access to edit mail config, Only admin have access to this functionality...!!');
            return res.redirect('/mail-config');
        }

    } catch (error) {
        console.log(error.message);
    }
}

module.exports = {

    loadCurrencyTimeZone,
    editCurrencyTimeZone,
    loadMailConfig,
    mailConfig,
    getSettings: async (req, res) => {
        try {
            const code = req.query.code;
            let appUrl, appName;

            appUrl = await SettingModel.findOne({ key: 'appUrl' });
            appName = await SettingModel.findOne({ key: 'appName' });

            return res.status(200).json({
                status: true,
                success: 1,
                data: {
                    status: true,
                    data: {
                        appUrl: appUrl ? appUrl.value : config.appUrl,
                        appName: appName ? appName.value : config.appName,
                    }
                }
            });

        } catch (error) {
            console.error('Error fetching settings:', error);
            return res.status(500).json({ success: 0, message: 'Internal server error' });
        }
    }


}