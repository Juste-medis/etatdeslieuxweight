const mongoose = require('mongoose');
require('./priceModel')
const Schema = mongoose.Schema;

const PlanSchema = mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },
    icon: {
        type: String,
        trim: true
    },
    description: {
        type: String,
        trim: true
    },
    features: {
        type: [String],
        required: true
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
        timestamps: true,
        toJSON: { virtuals: true },
        toObject: { virtuals: true }
    }
);
PlanSchema.virtual('prices', {
    ref: 'prices',
    localField: '_id',
    foreignField: 'plan',
    match: { isDeleted: false, },
    options: { sort: { sup: 1 } }
});

const ticket = mongoose.model('plans', PlanSchema);

module.exports = ticket;