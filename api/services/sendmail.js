// Importing required modules 
const nodemailer = require("nodemailer");
const path = require("path");

// Importing models
const mailModel = require("../models/mailModel");
const config = require("../config/config");
const hbs = require('handlebars');
hbs.registerHelper('ifEquals', function (arg1, arg2, options) {
    return arg1 === arg2 ? options.fn(this) : options.inverse(this);
});
// Function to send OTP verification email
const sendOtpMail = async (otp, email, name, template = "../views/mail-templates/") => {
    try {
        // Fetch Mail details
        const SMTP = config.nodemailerTransport;

        if (!SMTP) {
            throw new Error("Mail details not found");
        }

        // Mail transporter configuration
        const transporter = nodemailer.createTransport(config.nodemailerTransport);

        // Dynamically import nodemailer-express-handlebars
        const { default: hbs } = await import("nodemailer-express-handlebars");

        // Path for mail templates
        const templatesPath = path.resolve(__dirname, template);

        // Handlebars setup for nodemailer
        const handlebarOptions = {
            viewEngine: {
                partialsDir: templatesPath,
                defaultLayout: false,
            },
            viewPath: templatesPath,
        };

        transporter.use('compile', hbs(handlebarOptions));

        // Validate input parameters
        if (!otp || !email || !name) {
            throw new Error("Invalid input parameters");
        }

        const mailOptions = {
            from: config.nodemailer.from,
            template: "otp",
            to: email,
            subject: 'OTP Verification',
            context: {
                OTP: otp,
                email: email,
                name: name
            }
        };

        // Sending the email
        transporter.sendMail(mailOptions, function (error, info) {
            if (error) {
                console.error("Failed to send mail:", error);
            } else {

                console.log("Email sent:", info.response);
            }
        });

    } catch (error) {
        console.error("Error sending OTP mail:", error.message);
        throw error;
    }
};
const sendInviteMail = async (role, email, review, template = "../views/mail-templates/") => {
    try {
        const SMTP = config.nodemailerTransport;
        if (!SMTP) { throw new Error("Mail details not found"); }
        const transporter = nodemailer.createTransport(config.nodemailerTransport);
        const { default: hbs } = await import("nodemailer-express-handlebars");
        const templatesPath = path.resolve(__dirname, template);
        const handlebarOptions = {
            viewEngine: {
                partialsDir: templatesPath,
                defaultLayout: false,
            },
            viewPath: templatesPath,
        };
        transporter.use('compile', hbs(handlebarOptions));
        if (!role || !email) {
            throw new Error("Invalid input parameters");
        }
        const mailOptions = {
            from: config.nodemailer.from,
            template: "reviewinvite",
            to: email,
            subject: 'Etat des lieux - Invitation',
            context: {
                OTP: role,
                email: email,
                propertyDetails: review.propertyDetails,
                actionUrl: `${config.appUrl}/etat-des-lieux/${review._id}`
            }
        };

        // Sending the email
        transporter.sendMail(mailOptions, function (error, info) {
            if (error) {
                console.error("Failed to send mail:", error);
            } else {

                console.log("Email sent:", info.response);
            }
        });

    } catch (error) {
        console.error("Error sending OTP mail:", error.message);
        throw error;
    }
};
const sendInviteMailProcuration = async (email, procuration, query = {}, template = "../views/mail-templates/") => {
    try {
        const SMTP = config.nodemailerTransport;
        if (!SMTP) { throw new Error("Mail details not found"); }
        const transporter = nodemailer.createTransport(config.nodemailerTransport);
        const { default: hbs } = await import("nodemailer-express-handlebars");
        const templatesPath = path.resolve(__dirname, template);
        const handlebarOptions = {
            viewEngine: {
                partialsDir: templatesPath,
                defaultLayout: false,
            },
            viewPath: templatesPath,
        };
        transporter.use('compile', hbs(handlebarOptions));
        if (!procuration || !email) {
            throw new Error("Invalid input parameters");
        }

        const mailOptions = {
            from: config.nodemailer.from,
            template: query.accesgivenTo ? "mandataireprocuration" : "procuration",
            to: email,
            subject: 'Signature de procuration & procédure de l’état des lieux avec Jatai',
            context: query.accesgivenTo ? {
                logoUrl: `${config.appUrl}/assets/media/logos/logowhite.png`,
                email: email,
                propertyDetails: { ...procuration.propertyDetails, accessCode: procuration.accessCode },
                accessGivenTo: procuration.accesgivenTo[0],
                accessCode: `${procuration.accessCode}`,
            } : {
                logoUrl: `${config.appUrl}/assets/media/logos/logowhite.png`,
                email: email,
                propertyDetails: procuration.propertyDetails,
                accessGivenTo: procuration.accesgivenTo[0],
                owners: procuration.owners,
                exitenants: procuration.exitenants,
                entrantenants: procuration.entrantenants,
            }
        };

        // Sending the email
        transporter.sendMail(mailOptions, function (error, info) {
            if (error) {
                console.error("Failed to send mail:", error);
            } else {

                console.log("Email sent:", info.response);
            }
        });

    } catch (error) {
        console.error("Error sending OTP mail:", error.message);
        throw error;
    }
};

module.exports = { sendOtpMail, sendInviteMail, sendInviteMailProcuration };
