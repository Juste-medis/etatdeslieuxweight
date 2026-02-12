// Importing required modules 
const mongoose = require('mongoose');

// Importing models
const loginModel = require("../models/adminLoginModel");
const paymentGatewayModel = require("../models/paymentGatewayModel");
const planModel = require("../models/planModel");
const priceModel = require("../models/priceModel");
const { planSchema } = require('../utils/shemas');
const User = require('../models/userModel'); // Adjust import path if needed
const ReviewSchema = require("../models/reviewModel")
const ProcurationSchema = require("../models/procurationModel");
const { validateDatabyScheme, ApplyCodeToPrice } = require('../utils/utils');
const couponModel = require("../models/couponModel");
const { senProcurationEmails } = require('./procurationController');
const TransactionSchema = require("../models/transactionModel");

// Helper functions

function processPlanData(rawData) {
    const processedData = {
        ...rawData,
        status: rawData.status || 'active',
        createdAt: new Date(),
        updatedAt: new Date()
    };

    // Process prices
    if (rawData.prices) {
        processedData.prices = rawData.prices.map(price => ({
            ...price,
            currency: (price.currency || 'EUR').toUpperCase(),
            status: price.status || 'active',
            isInterval: price.isInterval || false
        }));
    }

    return processedData;
}

const addPlan = async (req, res) => {
    const session = await mongoose.startSession();
    session.startTransaction();

    try {
        if (!validateDatabyScheme(planSchema, req.body, res)) {
            return;
        }

        // 2. Data Processing
        const planData = processPlanData(req.body);
        delete planData._id;


        // 3. Check for duplicate plan names
        const existingPlan = await planModel.findOne({ name: planData.name })

        if (existingPlan) { return res.json({ error: "Plan with this name already exists" }); }



        const newPlan = await planModel.create(planData);

        if (newPlan) {
            const PricePromises = planData.prices.map(price => {
                delete price._id;
                return priceModel.create({
                    ...price,
                    plan: newPlan._id
                });
            });
            await Promise.all(PricePromises);
        }

        return res.json({ status: true, data: newPlan[0] });

    } catch (error) {
        await session.abortTransaction();
        throw error;
    } finally {
        session.endSession();
    }
}

const editPlan = async (req, res) => {

    try {
        const planId = req.params.id || req.body.id;

        if (!planId) {
            return res.status(400).json({ error: "Plan ID is required" });
        }
        if (!validateDatabyScheme(planSchema, req.body, res)) {
            return;
        }
        // Process plan data
        const planData = processPlanData(req.body);
        delete planData._id;

        // Check if plan exists
        const existingPlan = await planModel.findById(planId);
        if (!existingPlan) {
            return res.status(404).json({ error: "Aucun plan trouvé avec cet ID" });
        }

        // Check for duplicate plan names (excluding current plan)
        const duplicatePlan = await planModel.findOne({
            name: planData.name,
            _id: { $ne: planId }
        });

        if (duplicatePlan) {
            return res.status(400).json({ error: "Un plan avec ce nom existe déjà" });
        }

        // Update the plan
        const updatedPlan = await planModel.findByIdAndUpdate(
            planId,
            planData,
            { new: true }
        );

        if (updatedPlan && planData.prices) {
            // Delete existing prices
            await priceModel.updateMany({ plan: updatedPlan._id }, { isDeleted: true });
            // Create new prices
            const pricePromises = planData.prices.map(price => {
                delete price._id;
                return priceModel.create([{
                    ...price,
                    plan: updatedPlan._id
                }]);
            });
            await Promise.all(pricePromises);
        }
        req.flash("success", "Plan updated successfully.");
        return res.json({ status: true, data: updatedPlan });

    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ error: 'Failed to update plan' });
    }
};




const getPlans = async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 10;
        const filter = req.query.filter ? JSON.parse(req.query.filter) : {};

        const skip = (page - 1) * limit;

        filter.isDeleted = false;

        const plans = await planModel.find(filter)
            .populate('prices')
            .skip(skip)
            .limit(limit);
        const totalItems = await planModel.countDocuments(filter);

        return res.json({
            success: true,
            data: plans,
            pagination: {
                currentPage: page,
                totalPages: Math.ceil(totalItems / limit),
                totalItems,
                itemsPerPage: limit
            }
        });

    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ error: 'Failed to fetch plans' });
    }
}

const loadPaymentGateway = async (req, res) => {

    try {

        // fetch all payment gateway
        const paymentMethodDetails = await paymentGatewayModel.findOne();

        return res.render("paymentGateway", { paymentMethodDetails });

    } catch (error) {
        console.log(error.message);
    }
}

//edit stripe payment method 
const editStripePaymentMethod = async (req, res) => {

    try {

        const loginData = await loginModel.findById(req.session.adminId);

        if (loginData && loginData.is_admin === 1) {

            // Extract data from the request body
            const id = req.body.id;
            const stripe_is_enable = req.body.stripe_is_enable ? req.body.stripe_is_enable : 0;
            const stripe_mode = req.body.stripe_mode;
            const stripe_test_mode_publishable_key = req.body.stripe_test_mode_publishable_key;
            const stripe_test_mode_secret_key = req.body.stripe_test_mode_secret_key;
            const stripe_live_mode_publishable_key = req.body.stripe_live_mode_publishable_key;
            const stripe_live_mode_secret_key = req.body.stripe_live_mode_secret_key;

            let result;

            if (id) {
                // update stripe
                result = await paymentGatewayModel.findByIdAndUpdate(id, { stripe_is_enable, stripe_mode, stripe_test_mode_publishable_key, stripe_test_mode_secret_key, stripe_live_mode_publishable_key, stripe_live_mode_secret_key }, { new: true });

            } else {
                // save stripe
                result = await paymentGatewayModel.create({ stripe_is_enable, stripe_mode, stripe_test_mode_publishable_key, stripe_test_mode_secret_key, stripe_live_mode_publishable_key, stripe_live_mode_secret_key });
            }

            if (result) {

                req.flash("success", id ? "Stripe configuration updated successfully." : "Stripe configuration added successfully.");
                return res.redirect('/payment-gateway');

            } else {

                req.flash("error", "Failed to update stripe configuration. Try again later...");
                return res.redirect('/payment-gateway');
            }

        }
        else {

            req.flash('error', 'You do not have permission to edit stripe. As a demo admin, you can only view the content.');
            return res.redirect('/payment-gateway');
        }

    } catch (error) {
        console.log('Failed to edit stripe settings:', error.message);
    }
}

//edit paypal payment method 
const editPaypalPaymentMethod = async (req, res) => {
    try {
        const loginData = await loginModel.findById(req.session.adminId);
        if (loginData && loginData.is_admin === 1) {
            // Extract data from the request body
            const id = req.body.id;
            const paypal_is_enable = req.body.paypal_is_enable ? req.body.paypal_is_enable : 0;
            const paypal_mode = req.body.paypal_mode;
            const paypal_test_mode_merchant_id = req.body.paypal_test_mode_merchant_id;
            const paypal_test_mode_tokenization_key = req.body.paypal_test_mode_tokenization_key;
            const paypal_test_mode_public_key = req.body.paypal_test_mode_public_key;
            const paypal_test_mode_private_key = req.body.paypal_test_mode_private_key;
            const paypal_live_mode_merchant_id = req.body.paypal_live_mode_merchant_id;
            const paypal_live_mode_tokenization_key = req.body.paypal_live_mode_tokenization_key;
            const paypal_live_mode_public_key = req.body.paypal_live_mode_public_key;
            const paypal_live_mode_private_key = req.body.paypal_live_mode_private_key;

            let result;

            if (id) {
                // update paypal
                result = await paymentGatewayModel.findByIdAndUpdate(id, { paypal_is_enable: paypal_is_enable, paypal_mode: paypal_mode, paypal_test_mode_merchant_id: paypal_test_mode_merchant_id, paypal_test_mode_tokenization_key: paypal_test_mode_tokenization_key, paypal_test_mode_public_key: paypal_test_mode_public_key, paypal_test_mode_private_key: paypal_test_mode_private_key, paypal_live_mode_merchant_id: paypal_live_mode_merchant_id, paypal_live_mode_tokenization_key: paypal_live_mode_tokenization_key, paypal_live_mode_public_key: paypal_live_mode_public_key, paypal_live_mode_private_key: paypal_live_mode_private_key }, { new: true });

            } else {
                // save paypal
                result = await paymentGatewayModel.create({ paypal_is_enable: paypal_is_enable, paypal_mode: paypal_mode, paypal_test_mode_merchant_id: paypal_test_mode_merchant_id, paypal_test_mode_tokenization_key: paypal_test_mode_tokenization_key, paypal_test_mode_public_key: paypal_test_mode_public_key, paypal_test_mode_private_key: paypal_test_mode_private_key, paypal_live_mode_merchant_id: paypal_live_mode_merchant_id, paypal_live_mode_tokenization_key: paypal_live_mode_tokenization_key, paypal_live_mode_public_key: paypal_live_mode_public_key, paypal_live_mode_private_key: paypal_live_mode_private_key });
            }

            if (result) {

                req.flash("success", id ? "Paypal configuration updated successfully." : "Paypal configuration added successfully.");
                return res.redirect('/payment-gateway');

            } else {

                req.flash("error", "Failed to update paypal configuration. Try again later...");
                return res.redirect('/payment-gateway');

            }

        }
        else {

            req.flash('error', 'You do not have permission to edit paypal. As a demo admin, you can only view the content.');
            return res.redirect('/payment-gateway');
        }

    } catch (error) {
        console.log('Failed to edit paypal settings:', error.message);
    }
}

//edit razorpay payment method 
const editRazorpayPaymentMethod = async (req, res) => {

    try {

        const loginData = await loginModel.findById(req.session.adminId);

        if (loginData && loginData.is_admin === 1) {

            // Extract data from the request body
            const id = req.body.id;
            const razorpay_is_enable = req.body.razorpay_is_enable ? req.body.razorpay_is_enable : 0;
            const razorpay_mode = req.body.razorpay_mode;
            const razorpay_test_mode_key_id = req.body.razorpay_test_mode_key_id;
            const razorpay_test_mode_key_secret = req.body.razorpay_test_mode_key_secret;
            const razorpay_live_mode_key_id = req.body.razorpay_live_mode_key_id;
            const razorpay_live_mode_key_secret = req.body.razorpay_live_mode_key_secret;

            let result;

            if (id) {
                // update razorpay
                result = await paymentGatewayModel.findByIdAndUpdate(id, { razorpay_is_enable: razorpay_is_enable, razorpay_mode: razorpay_mode, razorpay_test_mode_key_id: razorpay_test_mode_key_id, razorpay_test_mode_key_secret: razorpay_test_mode_key_secret, razorpay_live_mode_key_id: razorpay_live_mode_key_id, razorpay_live_mode_key_secret: razorpay_live_mode_key_secret, }, { new: true });
            } else {
                //save razorpay
                result = await paymentGatewayModel.create({ razorpay_is_enable: razorpay_is_enable, razorpay_mode: razorpay_mode, razorpay_test_mode_key_id: razorpay_test_mode_key_id, razorpay_test_mode_key_secret: razorpay_test_mode_key_secret, razorpay_live_mode_key_id: razorpay_live_mode_key_id, razorpay_live_mode_key_secret: razorpay_live_mode_key_secret });
            }

            if (result) {

                req.flash("success", id ? "Razorpay configuration updated successfully." : "Razorpay configuration added successfully.");
                return res.redirect('/payment-gateway');

            } else {

                req.flash("error", "Failed to update razorpay configuration. Try again later...");
                return res.redirect('/payment-gateway');
            }

        }
        else {

            req.flash('error', 'You do not have permission to edit razorpay. As a demo admin, you can only view the content.');
            return res.redirect('/payment-gateway');
        }

    } catch (error) {
        console.log('Failed to edit razorpay settings:', error.message);
    }
}


const useOneCredit = async (req, res) => {
    const session = await mongoose.startSession();
    session.startTransaction();

    let {
        procuration_id, review_id
    } = req.body;
    let dispersion = []
    let { procurement, simple, other } = (await User.findById(req.user._id))?.balances;

    const procurationPlan = await planModel.findById("68abb489ac5240298a887669").populate('prices');
    const reviewPlan = await planModel.findById("68abb80942d054383a78498e").populate('prices');

    try {

        if (procurement > 0 && procuration_id) {
            procurement -= 1;
            dispersion.push({
                type: "procuration",
                thingid: procuration_id,
                dis_quantity: -1,
                dis_price: 1
            })
        }
        else if (simple > 0 && review_id) {
            simple -= 1;
            dispersion.push({
                type: "review",
                thingid: review_id,
                "dis_quantity": -1,
                "dis_price": 1
            })
        }

        else if (other > 0 && !procuration_id && !review_id) {
            other -= 1;
            dispersion.push({
                type: "other",
                dis_quantity: -1,
                dis_price: 1
            })
        }
        else {
            return res.status(400).json({ message: "Credit insufficient" });
        }

        const userBalence = await User.findByIdAndUpdate(req.user._id, { balances: { procurement, simple, other } }, { new: true });

        let UpdateData
        if (procuration_id) {
            UpdateData = procuration_id ? await ProcurationSchema.findByIdAndUpdate(procuration_id, { credited: true }, { new: true }) : null;


            // Credit all reviews linked to this procuration
            await ReviewSchema.updateMany(
                { procuration: procuration_id },
                { $set: { credited: true } }
            );

            UpdateData.meta = UpdateData.meta || {};
            UpdateData.meta.sent = true;
            senProcurationEmails(procuration_id);

        }
        if (review_id) {
            UpdateData = review_id ? await ReviewSchema.findByIdAndUpdate(review_id, { credited: true }, { new: true }) : null;
        }
        //create Transaction record
        const transaction = await TransactionSchema.create({
            userId: req.user._id,
            dispersion,
            total_amount: 1,
            price: 1,
            payment_method: "Jatai-mobile",
            payment_status: "completed",
            transaction_id: `DEBIT-${new Date().getTime()}`,
            meta: {
                reviewPlan,
                procurationPlan
            }
        });
        return res.json({ status: true, data: userBalence.balances });

    } catch (error) {
        await session.abortTransaction();
        throw error;
    } finally {
        session.endSession();
    }
}
const applyCoupon = async (req, res) => {
    try {
        const { code, ammount } = req.body;
        if (!code) {
            return res.status(400).json({ message: "Le code du coupon est requis" });
        }
        const coupon = await couponModel.findOne({ code: code, isDeleted: false, isActive: true });
        if (!coupon) {
            return res.status(404).json({ message: "Ce coupon n'existe pas ou n'est pas actif" });
        }
        const currentDate = new Date();
        if (coupon.expiryDate < currentDate) {
            return res.status(400).json({ message: "Ce coupon a expiré" });
        }

        //usage unique
        if (coupon.usageunique) {
            const existingTransaction = await TransactionSchema.findOne({ coupon_code: code });
            if (existingTransaction) {
                return res.status(400).json({ message: "Ce coupon a déjà été utilisé" });
            }
        }

        if (coupon.minimumAmount && ammount < coupon.minimumAmount) {
            return res.status(400).json({ message: `Le montant minimum pour appliquer ce coupon est de ${coupon.minimumAmount}` });
        }
        let newAmmount = ApplyCodeToPrice(ammount, coupon);
        return res.status(200).json({ message: "Coupon applied successfully", coupon, status: true, data: { originalAmmount: ammount, newAmmount } });

    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ error: 'Failed to apply coupon' });
    }
}
const geTransactions = async (req, res) => {
    const userId = req.user._id.toString();
    const isAdmin = req.casper === true;

    const userEmail = req.user.email;
    const { filter } = req.query;

    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;
    let filtering = { status: "all" };

    try {

        if (filter) {
            filtering = JSON.parse(filter);
        };
        const couponCode = filtering.couponCode;

        if (!filtering.status) { filtering.payment_status = "mine" }
        const baseMatch = isAdmin ? {} : { $or: [{ userId }], };

        let postMatch = {};

        //wait 5 seconds before responding

        if (filtering.status) {
            postMatch.payment_status = filtering.status == "all" || !filtering.status ? { $in: ["pending", "completed"] } : filtering.status;
            if (postMatch.payment_status === undefined) delete postMatch.payment_status;
        }

        if (couponCode && couponCode.trim() !== "") {
            postMatch.coupon_code = couponCode;
        }

        if (filtering.dateRange && filtering.dateRange.includes('-')) {
            const [startStr, endStr] = filtering.dateRange.split('-').map(s => s.trim());
            const [startDay, startMonth, startYear] = startStr.split('/').map(Number);
            const [endDay, endMonth, endYear] = endStr.split('/').map(Number);
            const startDate = new Date(startYear, startMonth - 1, startDay);
            const endDate = new Date(endYear, endMonth - 1, endDay, 23, 59, 59, 999);
            postMatch.createdAt = { $gte: startDate, $lte: endDate };
        }

        const [reviews, total, chiffreAffaire] = await Promise.all([
            TransactionSchema.find(
                { ...baseMatch, ...postMatch }
            ).populate({
                path: 'userId',
                select: 'firstName lastName email',
                model: 'user'
            })
                .skip(skip)
                .limit(limit)
                .sort({ createdAt: -1 })
                .lean(),
            TransactionSchema.countDocuments({ ...baseMatch, ...postMatch }),
            //le CA total
            TransactionSchema.aggregate([
                { $match: { ...baseMatch, ...postMatch, payment_status: "completed" } },
                { $group: { _id: null, totalRevenue: { $sum: "$price" } } }
            ]).then(result => result[0] ? result[0].totalRevenue : 0)

        ]);


        res.json({
            success: true,
            data: reviews,
            pagination: {
                currentPage: page,
                totalPages: Math.ceil(total / limit),
                totalItems: total,
                itemsPerPage: limit,
                meta: { chiffreAffaire }
            }
        });
    } catch (err) {
        res.status(500).json({
            success: false,
            error: 'Server Error',
            details: err.message
        });
    }
}


module.exports = {
    loadPaymentGateway,
    editStripePaymentMethod,
    editRazorpayPaymentMethod,
    editPaypalPaymentMethod,
    getPlans,
    addPlan,
    editPlan,
    useOneCredit,
    applyCoupon, geTransactions
}


