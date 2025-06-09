// Importing required modules 
const express = require("express");

// Create an instance of the express router
const routes = express();

// Configure EJS as the templating engine
routes.set('view engine', 'ejs');

// Configure the views directory for "static-files"
routes.set('views', './views/admin');

// Configure static files
routes.use(express.static('public'));

// Importing middleware functions for admin authentication
const { isLogin, isLogout } = require("../middleware/auth");

// Importing middleware function to uploadImageed single file
const { uploadImage } = require("../middleware/uploadSingleFile");
const multiplefile = require("../middleware/uploadMultipleFile");

//Import controllers
const loginController = require("../controllers/loginController");
// const splashController = require("../controllers/splashController");
// const categoryController = require("../controllers/procurationController");
// const organizerController = require("../controllers/organizerController");
// const sponserController = require("../controllers/sponsorController");
// const tagController = require("../controllers/tagController");
// const eventController = require("../controllers/eventController");
// const couponController = require("../controllers/couponController");
// const paymentController = require("../controllers/paymentController");
// const pageController = require("../controllers/pageController");
// const settingController = require("../controllers/settingController");
// const notificationController = require("../controllers/notificationController");
// const userController = require("../controllers/userController");
// const ticketController = require("../controllers/ticketController");
// const ticket = require("../models/ticketModel");
const reviewController = require("../controllers/reviewController");

// Routes For Login
routes.get("/", isLogout, loginController.loadLogin);
routes.get("/etat-des-lieux/:id", reviewController.frontreview);

routes.post("/", loginController.login);

// // Routes For Profile
// routes.get("/profile", isLogin, loginController.loadProfile); 


// routes.get("/edit-profile", isLogin, loginController.loadEditProfile);

// routes.post("/edit-profile", uploadImage, loginController.editProfile);

// // Routes For Change Password
// routes.get("/change-password", isLogin, loginController.loadChangePassword);

// routes.post("/change-password", loginController.changePassword);

// // Routes For Dashboard
// routes.get("/dashboard", isLogin, loginController.loadDashboard);

// // Routes For Splash
// routes.get("/add-splash", isLogin, splashController.loadAddSplash);

// routes.post("/add-splash", uploadImage, splashController.addSplash);

// routes.get("/splash", isLogin, splashController.loadSplash);

// routes.get("/edit-splash", isLogin, splashController.loadEditSplash);

// routes.post("/edit-splash", uploadImage, splashController.editSplash);

// routes.get("/delete-splash", isLogin, splashController.deleteSplash);

// routes.get("/update-splash-status", splashController.updateSplashStatus)

// // Routes For Category
// routes.post("/add-category", uploadImage, categoryController.addCategory);

// routes.get("/category", isLogin, categoryController.loadCategory);

// routes.post("/edit-category", uploadImage, categoryController.editCategory);

// routes.get("/update-category-status", isLogin, categoryController.updateCategoryStatus);

// routes.get("/delete-category", categoryController.deleteCategory);

// // Routes For Organizer
// routes.post("/add-organizer", uploadImage, organizerController.addOrganizer);

// routes.get("/organizer", isLogin, organizerController.loadOrganizer);

// routes.post("/edit-organizer", uploadImage, organizerController.editOrganizer);

// routes.get("/update-organizer-status", isLogin, organizerController.updateOrganizerStatus);

// routes.get("/delete-organizer", organizerController.deleteOrganizer);

// // Routes For Sponsor
// routes.post("/add-sponsor", uploadImage, sponserController.addSponsor);

// routes.get("/sponsor", isLogin, sponserController.loadSponsor);

// routes.post("/edit-sponsor", uploadImage, sponserController.editSponsor);

// routes.get("/update-sponsor-status", isLogin, sponserController.updateSponsorStatus);

// routes.get("/delete-sponsor", sponserController.deleteSponsor);

// // Routes For Tag
// routes.get("/tag", isLogin, tagController.loadTag);

// routes.post("/add-tag", tagController.addTag);

// routes.post("/edit-tag", tagController.editTag);

// routes.get("/delete-tag", tagController.deleteTag);

// // Routes For Event
// routes.get("/add-event", isLogin, eventController.loadAddEvent);

// routes.post("/add-event", multiplefile, eventController.addEvent);

// routes.get("/event", isLogin, eventController.loadEvents);

// routes.get("/edit-event", isLogin, eventController.loadEditEvent);

// routes.post("/edit-event", uploadImage, eventController.editEvent);

// routes.get("/delete-event", isLogin, eventController.deleteEvent);

// routes.get("/update-event-status", isLogin, eventController.updateEventStatus);

// routes.get("/event-details", isLogin, eventController.loadEventDetails);

// routes.get("/completed-event", isLogin, eventController.loadAllCompletedEvent);

// routes.get("/completd-event-details", isLogin, eventController.loadCompletedEventDetails);

// // Routes For Gallery
// routes.get("/gallery", isLogin, eventController.loadGallery);

// routes.post("/add-image", multiplefile, eventController.addImage);

// routes.post("/edit-image", uploadImage, eventController.editImage);

// routes.get("/delete-image", eventController.deleteGalleryImage);

// // Routes For Coupon
// routes.get("/add-coupon", isLogin, couponController.loadAddCoupon);

// routes.post("/add-coupon", uploadImage, couponController.addCoupon);

// routes.get("/coupon", isLogin, couponController.loadCoupon);

// routes.get("/edit-coupon", isLogin, couponController.loadEditCoupon);

// routes.post("/edit-coupon", uploadImage, couponController.editCoupon);

// routes.get("/delete-coupon", isLogin, couponController.deleteCoupon);

// routes.get("/update-coupon-status", isLogin, couponController.updateCouponStatus);

// // Routes For Ticket
// routes.get("/ticket", isLogin, ticketController.loadTicket);

// routes.get("/ticket-details", isLogin, ticketController.loadTicketDetails);

// routes.get("/past-ticket", isLogin, ticketController.loadPastTicket);

// routes.get("/past-ticket-details", isLogin, ticketController.loadCompletedTicketDetails);

// routes.post("/refund", ticketController.loadRefund);

// // Routes For User
// routes.get("/user", isLogin, userController.loadUser);

// routes.get("/active-user", userController.activeUser);

// // Routes For Notification
// routes.get("/notification", isLogin, notificationController.loadNotification);

// routes.get("/get-notification", notificationController.notification);

// // Routes For Payment Gateway
// routes.get("/payment-gateway", isLogin, paymentController.loadPaymentGateway);

// routes.post("/edit-stripe-payment-method", paymentController.editStripePaymentMethod);

// routes.post("/edit-paypal-payment-method", paymentController.editPaypalPaymentMethod);

// routes.post("/edit-razorpay-payment-method", paymentController.editRazorpayPaymentMethod);

// // Routes For Pages
// routes.get("/private-policy", isLogin, pageController.loadPrivatePolicy);

// routes.post("/add-private-policy", pageController.addPrivatePolicy);

// routes.get("/terms-and-condition", isLogin, pageController.loadTermsAndCondition);

// routes.post("/add-terms-and-condition", pageController.addTermsAndCondition);

// // Routes For Currency
// routes.get("/currency-timezone", isLogin, settingController.loadCurrencyTimeZone);

// routes.post("/currency-timezone", settingController.editCurrencyTimeZone);

// // Routes For Mail Config
// routes.get("/mail-config", isLogin, settingController.loadMailConfig);

// routes.post("/mail-config", settingController.mailConfig);

// // Routes For Log out
// routes.get("/logout", isLogin, loginController.logout);

// // Redirects unmatched routes to the root path
// routes.get("*", async (req, res) => {
//     res.redirect('/')
// })

module.exports = routes;