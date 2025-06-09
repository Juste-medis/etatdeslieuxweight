// Importing required modules 
const bcrypt = require("bcryptjs");

// Importing models
const loginModel = require("../models/adminLoginModel");
// const splashModel = require("../models/splashModel");
// const categoryModel = require("../models/categoryModel");
// const organizerModel = require("../models/organizerModel");
// const sponsorModel = require("../models/sponsorModel");
// const tagModel = require("../models/tagModel");
// const eventModel = require("../models/eventModel");
// const ticketModel = require("../models/ticketModel");
// const couponModel = require("../models/couponModel");
// const userModel = require("../models/userModel");

// Importing the service function to delete uploaded files
const { deleteImages } = require("../services/deleteImage");
const { populate } = require("../models/otpModel");

// Load and render the view for login
const loadLogin = async (req, res) => {

    try {

        return res.render("login");

    } catch (error) {
        console.log(error.message);
        req.flash('error', 'Something went wrong. Please try again.');
        res.redirect('/login');
    }
}

// login
const login = async (req, res) => {

    try {

        // Extract email and password from the request body
        const email = req.body.email;
        const password = req.body.password;

        // check if an account with the given email exists in the database
        const isExistEmail = await loginModel.findOne({ email: email })

        if (!isExistEmail) {
            req.flash('error', "We're sorry, something went wrong when attempting to sign in.");
            return res.redirect('back');
        }

        // compare password
        const passwordMatch = await bcrypt.compare(password, isExistEmail.password);

        if (!passwordMatch) {
            req.flash('error', "We're sorry, something went wrong when attempting to sign in.");
            return res.redirect('back');
        }

        req.session.adminId = isExistEmail._id;
        return res.redirect("/dashboard");

    } catch (error) {
        console.log(error.message);
        req.flash('error', 'Something went wrong. Please try again.');
        res.redirect('/login');
    }
}

// // Load and render the view for dashboard
// const loadDashboard = async (req, res) => {

//     try {

//         // Getting the current date
//         const currentDate = new Date().toISOString().split('T')[0];

//         // count
//         const totalSplash = await splashModel.countDocuments({ status: "Publish" });
//         const totalCategory = await categoryModel.countDocuments({ status: "Publish" });
//         const totalOrganizer = await organizerModel.countDocuments({ status: "Publish" });
//         const totalSponsor = await sponsorModel.countDocuments({ status: "Publish" });
//         const totalTag = await tagModel.countDocuments({});
//         const totalEvent = await eventModel.countDocuments({ status: "Publish" });
//         const totalTicket = await ticketModel.countDocuments();
//         const totalUpcomingTicket = await ticketModel.countDocuments({ status: "Upcoming" });
//         const totalPastTicket = await ticketModel.countDocuments({ status: "Past" });
//         const totalCoupon = await couponModel.countDocuments({ status: "Publish" });
//         const totalUser = await userModel.countDocuments();

//         // latest ticket
//         const tickets = await ticketModel.find()
//             .populate("userId eventId").sort({ createdAt: -1 }).limit(7).exec();

//         // upcoming event
//         const events = await eventModel.find({ date: { $gte: currentDate } }).sort({ date: 1 }).limit(7)

//         return res.render("dashboard",
//             {
//                 totalCategory, totalOrganizer, totalSponsor, totalEvent, totalTicket, totalUpcomingTicket,
//                 totalPastTicket, totalCoupon, totalUser, tickets, events, totalSplash, totalTag

//             });

//     } catch (error) {
//         console.log(error.message);
//         req.flash('error', 'Something went wrong. Please try again.');
//         res.redirect('/dashboard');
//     }
// }

// // Load and render the view for profile
// const loadProfile = async (req, res) => {

//     try {

//         // fetch particular user details
//         const profile = await loginModel.findById(req.session.adminId);

//         return res.render("profile", { profile, IMAGE_URL: process.env.IMAGE_URL });

//     } catch (error) {
//         console.log(error.message);
//         req.flash('error', 'Something went wrong. Please try again.');
//         res.redirect('/profile');
//     }
// }

// // Load and render the view for edit profile
// const loadEditProfile = async (req, res) => {

//     try {

//         // Extract data from the request query
//         const id = req.query.id;

//         const profile = await loginModel.findById(id);

//         return res.render("editProfile", { profile, IMAGE_URL: process.env.IMAGE_URL });

//     } catch (error) {
//         console.log(error.message);
//         req.flash('error', 'Something went wrong. Please try again.');
//         res.redirect('/profile');
//     }
// }

// // edit profile
// const editProfile = async (req, res) => {

//     try {

//         // Extract data from the request
//         const id = req.body.id;
//         const name = req.body.name;
//         const contact = req.body.contact;

//         // Retrieve the existing profile details from the database
//         const profileDetalis = await loginModel.findOne({ _id: id });

//         let avatar = profileDetalis.avatar;

//         if (req.file) {
//             // Delete the old profile image file
//             deleteImages(profileDetalis.avatar);
//             avatar = req.file.filename;
//         }

//         // Update the profile in the database
//         await loginModel.findByIdAndUpdate({ _id: id }, { $set: { name, contact, avatar } }, { new: true });

//         return res.redirect("/profile");

//     } catch (error) {
//         console.log(error.message);
//         req.flash('error', 'Something went wrong. Please try again.');
//         res.redirect('/profile');
//     }
// }

// // Load and render the view for change password
// const loadChangePassword = async (req, res) => {

//     try {

//         return res.render("changePassword")

//     } catch (error) {
//         console.log(error.message);
//         req.flash('error', 'Something went wrong. Please try again.');
//         res.redirect('/change-password');
//     }
// }

// // Change Password
// const changePassword = async (req, res) => {

//     try {

//         // Extract data from the request
//         const oldPassword = req.body.oldpassword;
//         const newPassword = req.body.newpassword;
//         const confirmPassword = req.body.comfirmpassword;

//         if (newPassword !== confirmPassword) {
//             req.flash('error', 'Confirm password does not match');
//             return res.redirect('/change-password');
//         }

//         // Fetch user document
//         const user = await loginModel.findById(req.session.adminId);

//         if (!user) {
//             req.flash('error', 'Something went wrong. Please try again.');
//             return res.redirect('/change-password');
//         }

//         // Compare old password
//         const passwordMatch = await bcrypt.compare(oldPassword, user.password);

//         if (!passwordMatch) {
//             req.flash('error', 'Old password is wrong, please try again');
//             return res.redirect('/change-password');
//         }

//         // Hash new password
//         const hashedPassword = await bcrypt.hash(newPassword, 10);

//         // Update user password
//         user.password = hashedPassword;
//         await user.save();

//         req.flash('success', 'Password changed successfully');
//         return res.redirect('/change-password');

//     } catch (error) {
//         console.log(error.message);
//         req.flash('error', 'Something went wrong. Please try again.');
//         res.redirect('/change-password');
//     }
// }

// // For log out
// const logout = (req, res) => {

//     try {
//         // Destroy the session
//         req.session.destroy(function (err) {

//             if (err) {
//                 console.error('Error destroying session:', err);
//                 return res.status(500).send('Internal Server Error');
//             }

//             // Clear the cookie
//             res.clearCookie('connect.sid');

//             return res.redirect("/");
//         });

//     } catch (error) {
//         console.error('Error during logout:', error);
//         res.status(500).send('Internal Server Error');
//     }
// };

module.exports = {

    loadLogin,
    login,
    // loadDashboard,
    // loadProfile,
    // loadEditProfile,
    // editProfile,
    // loadChangePassword,
    // changePassword,
    // logout

}