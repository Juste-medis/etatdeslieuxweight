const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const TransactionSchema = mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user',
        required: true,
    },
    total_amount: { type: Number, required: true, trim: true },
    price: { type: Number, required: true, trim: true },
    coupon_code: { type: String, trim: true },
    coupon_amount: { type: Number, trim: true },
    tax: { type: Number, trim: true },
    tax_amount: { type: Number, trim: true },
    payment_method: { type: String, enum: ['Cash On Delivery', 'Paypal', 'stripe', 'stripe-link', 'Razorpay', 'Jatai-mobile'], trim: true, required: true },
    payment_status: { type: String, enum: ['completed', 'Failed', 'pending'], trim: true },
    transaction_id: { type: String, trim: true },
    completedAt: { type: Date, default: null },
    dispersion: {
        type: Schema.Types.Mixed,
        default: {}
    },
    meta: {
        type: Schema.Types.Mixed,
        default: {}
    },
    cancellation_info: [{
        cancel_date: {
            type: String,
            trim: true
        },
        total_cancel: {
            type: Number,
            trim: true
        },
        cancel_reason: {
            type: String,
            trim: true
        },
        refund_amount: {
            type: Number,
            trim: true
        },
        refund_notes: {
            type: String,
            trim: true
        }
    }],
}, { timestamps: true }
);

const ticket = mongoose.model('transactions', TransactionSchema);

module.exports = ticket;