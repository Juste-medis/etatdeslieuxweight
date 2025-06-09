// Importing required modules 
const passport = require('passport');

require("../config/passport")
const userModel = require("../models/userModel");

const createAuthMiddleware = (strategy, roleKey = 'user', failureMessage = 'Please, sign in...') => {
    return (req, res, next) => {

        passport.authenticate(strategy, { session: false }, async (err, userOrAdmin, info) => {
            try {

                if (err) return next(err);
                if (!userOrAdmin) {

                    return res.status(401).json({ data: { success: 0, message: failureMessage, error: 1 } });
                }
                const user = await userModel.findOne({ _id: userOrAdmin });

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

