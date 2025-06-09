const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const Thingchema = mongoose.Schema({
    order: {
        type: Number,
        default: 1,
        trim: true
    },
    name: {
        type: String,
        required: true
    },
    type: {
        type: String,
        required: false
    },
    brand: {
        type: String,
        required: false
    },
    model: {
        type: String,
        required: false
    },
    serialNumber: {
        type: String,
        required: false
    },
    condition: {
        type: String,
        required: false
    },
    location: {
        type: String,
        required: false
    },
    testingStage: {
        type: String,
        required: false
    },
    description: {
        type: String,
        required: false
    },
    photos: {
        type: [{
            type: String,
         }],
        default: []
    },
    warranty: {
        type: String,
        required: false
    },
    comment: {
        type: String,
        required: false
    },
    order: {
        type: Number,
        required: false,
        default: 0
    },
    count: {
        type: Number,
        required: false,
        default: 1
    },
    dateAcquired: {
        type: Date,
        required: false
    },
    dateDisposed: {
        type: Date,
        required: false
    },
    dateInspected: {
        type: Date,
        required: false
    },
    dateRepaired: {
        type: Date,
        required: false
    },
    dateServiced: {
        type: Date,
        required: false
    },
    dateMaintained: {
        type: Date,
        required: false
    },
    dateReplaced: {
        type: Date,
        required: false
    },
    dateUpgraded: {
        type: Date,
        required: false
    },
    dateDowngraded: {
        type: Date,
        required: false
    },
    dateRecalled: {
        type: Date,
        required: false
    }

},
    {
        timestamps: true
    }
);

const thingmodel = mongoose.model('things', Thingchema);

module.exports = thingmodel;