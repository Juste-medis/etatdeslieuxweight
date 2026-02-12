// Importing required modules 
const nodemailer = require("nodemailer");
const path = require("path");

// Importing models
const mailModel = require("../models/mailModel");
const config = require("../config/config");
const hbs = require('handlebars');
const { authorname } = require("../utils/utils");
hbs.registerHelper('ifEquals', function (arg1, arg2, options) {
    return arg1 === arg2 ? options.fn(this) : options.inverse(this);
});
hbs.registerHelper('formatDate', function (date, locale) {
    if (!date) return '';
    const dateObj = new Date(date);
    return dateObj.toLocaleDateString(locale || 'fr-FR');
});
hbs.registerHelper('authorname', function (user) {
    function authorname(author) {
        const capitalizeFirstLetter = (str) => {
            if (!str) return '';
            return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
        };

        let result = author.type === "morale"
            ? capitalizeFirstLetter(author.denomination || '')
            : `${capitalizeFirstLetter(author.firstname || '')} ${capitalizeFirstLetter(author.lastname || '')}`.trim();

        return result || "Auteur inconnu";
    }
    if (!user) return '';
    return authorname(user);
});
// Function to send OTP verification email
const configtransporter = async (template = "../views/mail-templates/") => {
    // Fetch Mail details
    const SMTP = config.nodemailerTransport;
    if (!SMTP) { throw new Error("Mail details not found"); }
    // Mail transporter configuration
    const transporter = nodemailer.createTransport(config.nodemailerTransport);
    const { default: hbs } = await import("nodemailer-express-handlebars");
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
    return transporter;
}
const sendOtpMail = async (otp, email, name) => {
    try {
        const transporter = await configtransporter();

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
                logoUrl: `${config.appUrl}/assets/media/logos/rocketdeliveries.png`,

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
//sendOtpMail("Juste un petit test", `clemencelerouxgodillot@gmail.com`, `je test`);



const sendRessetpasswordOtpMail = async (otp, email, name) => {
    try {
        const transporter = await configtransporter();

        // Validate input parameters
        if (!otp || !email || !name) {
            throw new Error("Invalid input parameters");
        }

        const mailOptions = {
            from: config.nodemailer.from,
            template: "passwordresset",
            to: email,
            subject: 'Réinitialisation du mot de passe',
            context: {
                logoUrl: `${config.appUrl}/assets/media/logos/rocketdeliveries.png`,
                OTP: otp,
                email: email,
                name: name,
                resetLink: `${config.appUrl}/resetpassword?email=${encodeURIComponent(`${email}_102030_82${otp}`)}&otp=${encodeURIComponent(otp)}`
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



// Function to send OTP verification email
const sendWelcomeMessage = async (user) => {
    try {
        const transporter = await configtransporter();

        // Validate input parameters
        if (!user) {
            throw new Error("Invalid input parameters");
        }

        const mailOptions = {
            from: config.nodemailer.from,
            template: user.type == "owner" ? "welcomebailleur" : "welcomelocataire",
            to: user.email,
            subject: 'Bienvenue sur Jatai',
            context: {
                logoUrl: `${config.appUrl}/assets/media/logos/rocketdeliveries.png`,
                email: user.email,
                name: user.firstName,
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
const sendInviteMail = async (role, email, review) => {
    try {
        const transporter = await configtransporter();

        if (!role || !email) {
            throw new Error("Invalid input parameters");
        }
        const mailOptions = {
            from: config.nodemailer.from,
            template: "reviewinvite",
            to: email,
            subject: 'Etat des lieux réalisé',
            context: {
                logoUrl: `${config.appUrl}/assets/media/logos/rocketdeliveries.png`,
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
const sendReviewCompletedMail = async (role, email, review) => {
    try {
        const transporter = await configtransporter();

        if (!role || !email) {
            throw new Error("Invalid input parameters");
        }
        const mailOptions = {
            from: config.nodemailer.from,
            template: "reviewcomplete",
            to: email,
            subject: "État des lieux - Jatai",
            context: {
                logoUrl: `${config.appUrl}/assets/media/logos/rocketdeliveries.png`,
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

const sendMessageToSupportMail = async (destinataire, messagemodel) => {
    try {
        const transporter = await configtransporter();

        if (!destinataire) {
            throw new Error("Invalid input parameters");
        }
        const mailOptions = {
            from: config.nodemailer.from,
            template: destinataire === "tosupport" ? "sendmessagetosupport" : "sendmessagetouser",
            to: destinataire === "tosupport" ? config.supportEmail : messagemodel.email,
            subject: "Nouveau message de support - Jatai",
            context: {
                logoUrl: `${config.appUrl}/assets/media/logos/rocketdeliveries.png`,
                subject: messagemodel.subject,
                message: messagemodel.message,
                email: messagemodel.email,
                fullName: messagemodel.fullName,
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
const sendTenantsMailProcuration = async (email, procuration, query = {}) => {
    try {
        const transporter = await configtransporter();
        if (!procuration || !email) {
            throw new Error("Invalid input parameters");
        }

        const mailOptions = {
            from: config.nodemailer.from,
            template: "tenantprocuration",
            to: email,
            subject: 'Signature de procuration & procédure de l’état des lieux avec Jatai',
            context: {
                logoUrl: `${config.appUrl}/assets/media/logos/rocketdeliveries.png`,
                email: email,
                ...query,
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

const sendGriefeNotification = async (email, procuration, query = {}) => {
    try {
        const transporter = await configtransporter();
        if (!procuration || !email) {
            throw new Error("Invalid input parameters");
        }

        const mailOptions = {
            from: config.nodemailer.from,
            template: "procgrieffenotification",
            to: email,
            subject: 'Signature de procuration',
            context: {
                logoUrl: `${config.appUrl}/assets/media/logos/rocketdeliveries.png`,
                email: email,
                ...query,
                propertyDetails: procuration.propertyDetails,
                accessGivenTo: procuration.accesgivenTo[0],
                owners: procuration.owners,
                exitenants: procuration.exitenants,
                entrantenants: procuration.entrantenants,
                dashboardLink: `${config.appUrl}/`
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

const sendPaymentEmail = async (email, procuration, query = {}) => {
    try {
        const transporter = await configtransporter();
        if (!procuration || !email) {
            throw new Error("Invalid input parameters");
        }

        const mailOptions = {
            from: config.nodemailer.from,
            template: "sendpaymentDetails",
            to: email,
            subject: 'Détails de votre paiement - Jatai',
            context: {
                logoUrl: `${config.appUrl}/assets/media/logos/rocketdeliveries.png`,
                email: email,
                ...query,
                dashboardLink: `${config.appUrl}/`
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
const sendOkToMantaire = async (email, procuration, query = {}) => {

    try {
        const transporter = await configtransporter();
        if (!procuration || !email) {
            throw new Error("Invalid input parameters");
        }

        const mailOptions = {
            from: config.nodemailer.from,
            template: "mandatairenotification",
            dashboardLink: `${config.appUrl}`,
            to: email,
            subject: 'Etat des lieux - Mandataire',
            context: {
                logoUrl: `${config.appUrl}/assets/media/logos/rocketdeliveries.png`,
                email: email,
                ...query,
                propertyDetails: procuration.propertyDetails,
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

// const sendTenantsMailProcuration = async (email, procuration, query = {}) => {
//     try {
//         const transporter = await configtransporter();
//         if (!procuration || !email) {
//             throw new Error("Invalid input parameters");
//         }

//         const mailOptions = {
//             from: config.nodemailer.from,
//             template: query.accesgivenTo ? "mandataireprocuration" : "procuration",
//             to: email,
//             subject: 'Signature de procuration & procédure de l’état des lieux avec Jatai',
//             context: query.accesgivenTo ? {
//                 logoUrl: `${config.appUrl}/assets/media/logos/logowhite.png`,
//                 email: email,
//                 propertyDetails: { ...procuration.propertyDetails, accessCode: procuration.accessCode },
//                 accessGivenTo: procuration.accesgivenTo[0],
//                 accessCode: `${procuration.accessCode}`,
//             } : {
//                 logoUrl: `${config.appUrl}/assets/media/logos/logowhite.png`,
//                 email: email,
//                 propertyDetails: procuration.propertyDetails,
//                 accessGivenTo: procuration.accesgivenTo[0],
//                 owners: procuration.owners,
//                 exitenants: procuration.exitenants,
//                 entrantenants: procuration.entrantenants,
//             }
//         };

//         // Sending the email
//         transporter.sendMail(mailOptions, function (error, info) {
//             if (error) {
//                 console.error("Failed to send mail:", error);
//             } else {

//                 console.log("Email sent:", info.response);
//             }
//         });

//     } catch (error) {
//         console.error("Error sending OTP mail:", error.message);
//         throw error;
//     }
// };

module.exports = {
    sendOtpMail,
    sendInviteMail,
    sendTenantsMailProcuration,
    sendWelcomeMessage,
    sendGriefeNotification,
    sendReviewCompletedMail,
    sendOkToMantaire,
    sendRessetpasswordOtpMail,
    sendMessageToSupportMail,
    sendPaymentEmail
};
