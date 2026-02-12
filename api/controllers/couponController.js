// Importing models
const loginModel = require("../models/adminLoginModel");
const couponModel = require("../models/couponModel");

// Importing the service function to delete uploaded files
const { deleteImages } = require("../services/deleteImage");
const { couponShema } = require("../utils/shemas");
const { validateDatabyScheme, AllvaluesNullorEmpyObject } = require("../utils/utils");

// add coupon
const createCoupon = async (req, res) => {
    const dataValidation = validateDatabyScheme(couponShema, {
        ...req.body,
        createdBy: req.organizer._id.toString()
    }, res)

    if (!dataValidation) {
        console.log("Validation failed");

        return;
    }

    try {
        // Extract data from the request body
        const { code, minimumAmount, discount, type, expiryDate, comments, usageunique } = req.body;

        // Create a new coupon instance
        const newCoupon = new couponModel({
            code,
            discount,
            type,
            expiryDate,
            comments,
            minimumAmount,
            usageunique,
            createdBy: req.organizer._id
        });
        // Save the coupon to the database
        await newCoupon.save();

        return res.status(201).json({ message: "Coupon créé avec succès", coupon: newCoupon, status: true });

    } catch (error) {
        throw error;
    }


}
// edit coupon
const editCoupon = async (req, res) => {

    const dataValidation = validateDatabyScheme(couponShema, {
        ...req.body,
        createdBy: req.organizer._id.toString()
    }, res)
    if (!dataValidation) {
        console.log("Validation failed");
        return;
    }

    try {
        // Extract data from the request body
        const { code, minimumAmount, discount, type, expiryDate, comments, isActive, usageunique } = req.body;
        const id = req.params.id;
        // Find the existing coupon by ID
        const existingCoupon = await couponModel.findById(id);

        if (!existingCoupon) {
            return res.status(404).json({ message: "Coupon non trouvé", status: false });
        }
        // Update the coupon fields
        existingCoupon.code = code;
        existingCoupon.discount = discount;
        existingCoupon.type = type;
        existingCoupon.expiryDate = expiryDate;
        existingCoupon.minimumAmount = minimumAmount;
        existingCoupon.comments = comments;
        existingCoupon.isActive = isActive;
        existingCoupon.usageunique = usageunique;

        // Save the updated coupon to the database
        await existingCoupon.save();
        return res.status(200).json({ message: "Coupon mis à jour avec succès", coupon: existingCoupon, status: true });

    }
    catch (error) {
        throw error;
    }



}

// delete coupon
const deleteCoupon = async (req, res) => {

    try {
        const id = req.params.id;

        // fetch particular coupon
        const coupon = await couponModel.updateOne({ _id: id }, { isDeleted: true });
        if (!coupon) {
            throw "Coupon introuvable";
        }

        res.status(200).json({ message: "Coupon supprimé avec succès", status: true });

    } catch (error) {
        console.log(error.message);
        req.flash('error', 'Something went wrong. Please try again.');
        res.redirect('/coupon');
    }
}


const getCoupons = async (req, res) => {
    // await couponModel.updateMany({}, { comment: "Simple comments" });
    try {
        const page = parseInt(req.query.page ?? 0) + 1;
        const limit = parseInt(req.query.limit) || 10;
        let filter = req.query.filter ? JSON.parse(req.query.filter) : {};
        if (AllvaluesNullorEmpyObject(filter)) {
            filter = null
        }

        if (filter) {
            filter.isDeleted = false;
            if (filter.code) {
                filter.code = { $regex: filter.code, $options: 'i' }
            }
        } else {
            filter = { isDeleted: false }
        }

        const skip = (page - 1) * limit;
        const coupons = await couponModel.find(filter)
            .skip(skip)
            .sort({ createdAt: -1 })
            .limit(limit);


        return res.json({
            success: true,
            data: coupons,
            pagination: {
                currentPage: page,
                totalPages: Math.ceil(await couponModel.countDocuments(filter) / limit),
                totalItems: await couponModel.countDocuments(filter),
                itemsPerPage: limit
            }
        });

    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ error: 'Failed to fetch coupons' });
    }
}

module.exports = {
    createCoupon,
    editCoupon,
    deleteCoupon,
    getCoupons
}

