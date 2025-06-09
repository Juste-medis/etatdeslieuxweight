// Importing required modules 

// Importing models
const loginModel = require("../models/adminLoginModel");
const userModel = require("../models/userModel");

const loadUser = async (req, res) => {

    try {

        // fetch all user
        const user = await userModel.find();

        // fetch admin
        const loginData = await loginModel.find();

        return res.render("user", { user, loginData, IMAGE_URL: process.env.IMAGE_URL });

    } catch (error) {
        console.log(error.message);
    }
}

// for active user
const activeUser = async (req, res) => {

    try {

        // Extract data from the request
        const id = req.query.id;

        // Find current user
        const currentUser = await userModel.findById({ _id: id });

        const user = await userModel.findByIdAndUpdate({ _id: id }, { $set: { is_active: currentUser.is_active === false ? true : false } }, { new: true });

        return res.redirect('/user');

    } catch (error) {
        console.log(error.message);
    }
}

module.exports = {
    loadUser,
    activeUser
}
