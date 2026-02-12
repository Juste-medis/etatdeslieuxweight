// Importing required modules 
const passport = require('passport');

require("../config/passport")
const userModel = require("../models/userModel");
const loginhistorymodel = require("../models/loginHistory");
const { getUserDeviceInfo } = require('../utils/utils');

const createAuthMiddleware = (strategy, roleKey = 'user', failureMessage = 'Please, sign in...') => {
    return (req, res, next) => {

        passport.authenticate(strategy, { session: false }, async (err, userOrAdmin, info) => {
            try {
                req["casper"] = undefined;
                if (err) return next(err);
                if (!userOrAdmin) {
                    return res.status(401).json({ data: { success: 0, message: failureMessage, error: 1 } });
                }
                const user = await userModel.findOne({ _id: userOrAdmin });

                const accessAdmin = req.headers['x-access-admin'] || req.headers['X-Access-Admin'];
                if (accessAdmin && accessAdmin === 'casper') {
                    if (user.level !== 'superroot') {
                        throw "Acces non autorisé pour ce compte";
                    }
                    else {
                        req["casper"] = true;
                    }
                }

                await userModel.findOneAndUpdate({ _id: user._id }, { $set: { lastSeenAt: new Date().toISOString(), } }, { new: true });
                req[roleKey] = user;
                next();
            } catch (error) {
                console.error(`Error during ${strategy} auth:`, error);
                return next(error);
            }
        })(req, res, next);
    };
};

// Exported middlewares
const checkAuthentication = createAuthMiddleware('jwt', 'user', 'Please, Sign In....');
const checkAuthenticationForAdmin = createAuthMiddleware('admin-jwt', 'organizer', 'Please Organizer, Sign In....');

module.exports = { checkAuthentication, checkAuthenticationForAdmin };

