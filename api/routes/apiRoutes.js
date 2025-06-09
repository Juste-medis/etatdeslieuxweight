// Importing required modules 
const express = require("express");
const errorHandler = require('../utils/error-handler');

// Create an instance of the express router
const routes = express.Router();

// Importing middleware functions for upload image
const { uploadImage } = require("../middleware/uploadSingleFile");

// Importing middleware functions for check user authentication
const { checkAuthentication } = require("../middleware/checkAuthentication");

// Import controllers
const apiController = require("../controllers/apiController");
const fileController = require("../controllers/fileController");
const procurationController = require("../controllers/procurationController");
const reviewController = require("../controllers/reviewController");
const testController = require("../controllers/testController");

// Category Routes
routes.get("/reviewfile/:id", fileController.reviewfile);
routes.get("/file/:id", checkAuthentication, fileController.getFile);
routes.get("/etat-des-lieux/:id", reviewController.frontreview);

routes.get("/fatest", testController.addphotos);
routes.get("/getreviews", checkAuthentication, reviewController.getReviews);
routes.get("/getReviewBycode/:code", checkAuthentication, reviewController.getReviewBycode);


// Authentication Routes
routes.post("/checkregisteruser", (req, res, next) => {
    apiController.checkregisteruser(req, res)
        .catch(next);
});


// Sign In Routes

routes.post("/signup", (req, res, next) => {
    apiController.signup(req, res)
        .catch((err) => {
            next(err)
        });
});

routes.post("/map/search", (req, res, next) => {
    apiController.mapsearch(req, res)
        .catch((err) => {
            next(err)
        });
});

routes.post("/signin", (req, res, next) => {
    apiController.signin(req, res)
        .catch(next);
});

routes.post("/verifyotp", (req, res, next) => {
    apiController.verifyotp(req, res)
        .catch(next);
});

routes.post("/interestedCategory", (req, res, next) => {
    apiController.interestedCategory(req, res)
        .catch(next);
});
routes.post("/isverifyaccount", (req, res, next) => {
    apiController.isverifyaccount(req, res)
        .catch(next);
});

routes.post("/resendotp", (req, res, next) => {
    apiController.resendotp(req, res)
        .catch(next);
});

// Forgot Password Routes
routes.post("/forgotpassword", (req, res, next) => {
    apiController.forgotpassword(req, res)
        .catch(next);
});

routes.post("/forgotpasswordotpverification", (req, res, next) => {
    apiController.forgotpasswordotpverification(req, res)
        .catch(next);
});

routes.post("/resetpassword", (req, res, next) => {
    apiController.resetpassword(req, res)
        .catch(next);
});

// User Routes
routes.post("/getuser", checkAuthentication, (req, res, next) => {
    apiController.getuser(req, res)
        .catch(next);
});
routes.post("/user/edit", checkAuthentication, (req, res, next) => {
    apiController.useredit(req, res)
        .catch(next);
});

routes.post("/upload/image/:thing/:id", checkAuthentication, uploadImage, (req, res, next) => {
    fileController.upFile(req, res)
        .catch(next);
});

routes.post("/useredit", checkAuthentication, (req, res, next) => {
    apiController.useredit(req, res)
        .catch(next);
});

routes.post("/changepassword", checkAuthentication, (req, res, next) => {
    apiController.changepassword(req, res)
        .catch(next);
});
routes.post("/owner/procurarion", checkAuthentication, (req, res, next) => {
    procurationController.createprocuration(req, res)
        .catch(next);
});

routes.post("/updateImages/:thing/:id", checkAuthentication, (req, res, next) => {
    fileController.delFile(req, res)
        .catch(next);
});

routes.post("/owner/griffeprocurarion", checkAuthentication, (req, res, next) => {
    procurationController.griffeprocurarion(req, res)
        .catch(next);
});

routes.post("/griffereview", checkAuthentication, (req, res, next) => {
    reviewController.griffeReview(req, res)
        .catch(next);
});
routes.post("/createreview", checkAuthentication, (req, res, next) => {
    reviewController.createreview(req, res)
        .catch(next);
});
routes.post("/deleteReview/:reviewid", checkAuthentication, (req, res, next) => {
    reviewController.deleteReview(req, res)
        .catch(next);
});
routes.post("/updatereview/:reviewid", checkAuthentication, (req, res, next) => {
    reviewController.updatereview(req, res)
        .catch(next);
});
routes.post("/preview-review/:reviewid", checkAuthentication, (req, res, next) => {
    reviewController.previewage(req, res)
        .catch(next);
});
routes.post("/deleteaccountuser", checkAuthentication, (req, res, next) => {
    apiController.deleteaccountuser(req, res)
        .catch(next);
});

// Splash Screen
routes.post("/splash", (req, res, next) => {
    apiController.splash(req, res)
        .catch(next);
});


// Organizer Routes
routes.post("/organizer", (req, res, next) => {
    apiController.organizer(req, res)
        .catch(next);
});

// Sponsor Routes
routes.post("/sponsor", (req, res, next) => {
    apiController.sponsor(req, res)
        .catch(next);
});

// Event Routes
routes.post("/eventdetails", (req, res, next) => {
    apiController.eventdetails(req, res)
        .catch(next);
});

routes.post("/search", (req, res, next) => {
    apiController.search(req, res)
        .catch(next);
});

routes.post("/getAllTag", (req, res, next) => {
    apiController.getAllTag(req, res)
        .catch(next);
});

routes.post("/getEventsByTagId", (req, res, next) => {
    apiController.getEventsByTagId(req, res)
        .catch(next);
});

routes.post("/getAllCoupon", (req, res, next) => {
    apiController.getAllCoupon(req, res)
        .catch(next);
});

routes.post("/checkCoupon", checkAuthentication, (req, res, next) => {
    apiController.checkCoupon(req, res)
        .catch(next);
});

// Ticket Routes
routes.post("/bookticket", checkAuthentication, (req, res, next) => {
    apiController.bookticket(req, res)
        .catch(next);
});

routes.post("/allbookedticket", checkAuthentication, (req, res, next) => {
    apiController.allbookedticket(req, res)
        .catch(next);
});

routes.post("/upcomingticket", checkAuthentication, (req, res, next) => {
    apiController.upcomingticket(req, res)
        .catch(next);
});

routes.post("/pastbookedticket", checkAuthentication, (req, res, next) => {
    apiController.pastbookedticket(req, res)
        .catch(next);
});

routes.post("/cancelTicket", checkAuthentication, (req, res, next) => {
    apiController.cancelTicket(req, res)
        .catch(next);
});

// Favourite Event Routes
routes.post("/addFavouriteEvent", checkAuthentication, (req, res, next) => {
    apiController.addFavouriteEvent(req, res)
        .catch(next);
});

routes.post("/getAllFavouriteEvent", checkAuthentication, (req, res, next) => {
    apiController.getAllFavouriteEvent(req, res)
        .catch(next);
});

routes.post("/deleteFavouriteEvent", checkAuthentication, (req, res, next) => {
    apiController.deleteFavouriteEvent(req, res)
        .catch(next);
});

// Notification Routes
routes.post("/getAllNotification", checkAuthentication, (req, res, next) => {
    apiController.getAllNotification(req, res)
        .catch(next);
});

// Payment Gateway
routes.post("/paymentgateway", (req, res, next) => {
    apiController.paymentgateway(req, res)
        .catch(next);
});

// Page Routes
routes.post("/getpage", (req, res, next) => {
    apiController.getpage(req, res)
        .catch(next);
});

// Currency Routes
routes.post("/getcurrencytimezone", (req, res, next) => {
    apiController.getcurrencytimezone(req, res)
        .catch(next);
});

// Temporary Routes
routes.post("/getotp", (req, res, next) => {
    apiController.getotp(req, res)
        .catch(next);
});

routes.post("/getforgotpasswordotp", (req, res, next) => {
    apiController.getforgotpasswordotp(req, res)
        .catch(next);
});


routes.use((req, res, next) => {
    res.status(404).send("<h1>Not-Found :-)</h1>");
});
routes.use(errorHandler);

module.exports = routes;