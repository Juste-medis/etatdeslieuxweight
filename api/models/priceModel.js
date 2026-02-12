const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const PriceSchema = mongoose.Schema({
    plan: {
        type: Schema.Types.ObjectId,
        ref: 'plans',
        required: true
    },
    name: {
        type: String,
        default: '',
        trim: true
    },
    description: {
        type: String,
        trim: true
    },
    inf: {
        type: Number,
        trim: true
    },
    sup: {
        type: Number,
        trim: true
    },
    qty: {
        type: Number,
        trim: true
    },
    price: {
        type: Number,
        required: true,
        trim: true
    },
    currency: {
        type: String,
        default: 'EUR',
        trim: true
    },
    isInterval: {
        type: Boolean,
        default: false
    },
    isDeleted: {
        type: Boolean,
        default: false
    },
    status: {
        type: String,
        enum: ['active', 'inactive'],
        default: 'active',
        trim: true
    },
    meta: {
        type: Schema.Types.Mixed,
        default: {}
    }
},
    {
        timestamps: true
    }
);

const price = mongoose.model('prices', PriceSchema);

module.exports = price;