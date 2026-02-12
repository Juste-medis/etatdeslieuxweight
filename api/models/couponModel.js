const mongoose = require('mongoose');

const CouponSchema = mongoose.Schema({
    code: {
        type: String,
        required: true,
        trim: true
    },
    discount: {
        type: Number,
        required: true,
        trim: true
    },
    minimumAmount: {
        type: Number,
        trim: true
    },
    type: {
        type: String,
        default: 'percentage',
        enum: ['percentage', 'fixed', 'free'],
    },
    usageunique: {
        type: Boolean,
        default: false
    },
    isDeleted: {
        type: Boolean,
        default: false
    },
    expiryDate: {
        type: Date,
        required: true
    },
    isActive: {
        type: Boolean,
        default: true
    },
    comments: {
        type: String,
        trim: true
    },
    createdBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user',
        required: true
    },
    meta: {
        type: mongoose.Schema.Types.Mixed,
        default: {},
    },
},
    {
        timestamps: true
    }
);

const ticket = mongoose.model('coupons', CouponSchema);

module.exports = ticket;