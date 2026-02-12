const mongoose = require("mongoose");

const otpSchema = new mongoose.Schema({

    email: {
        type: String,
        required: true,
        trim: true
    },
    otp: {
        type: Number,
        required: true,
        trim: true
    },
    expires: {
        type: Date,
        default: Date.now(),
    },
    isVerified: {
        type: Boolean,
        default: false,
    },
    isRevoked: {
        type: Boolean,
        default: false,
    },
    verifiedAt: {
        type: Date,
    },
},
    { timestamps: true }
);
module.exports = mongoose.model("otp", otpSchema);