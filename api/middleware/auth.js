// Importing models
const loginModel = require("../models/adminLoginModel");

const isLogin = async (req, res, next) => {

    try {

        if (req.session.adminId) {

            const admin = await loginModel.findById({ _id: req.session.adminId });

            if (!admin) {

                throw new Error('Admin not found');
            }

            res.locals.admin = admin;
            next();
        }
        else {
            return res.redirect('/');
        }


    } catch (error) {
        console.log(error.message);
    }
}

const isLogout = async (req, res, next) => {

    try {

        if (req.session.adminId) {

            return res.redirect('/dashboard');

        }

        next();

    } catch (error) {
        console.log(error.message);
    }

}

module.exports = {

    isLogin,
    isLogout
    
}