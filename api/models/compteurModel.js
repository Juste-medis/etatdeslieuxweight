const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const CompteurSchema = new Schema({
    name: {
        type: String,
        required: true
    },
    type: {
        type: String,
        required: false
    },
    serialNumber: {
        type: String,
        required: false
    },
    location: {
        type: String,
        required: false
    },
    initialReading: {
        type: Number,
        required: false
    },
    heurespleines: {
        type: Number,
        required: false
    },
    initialReadingHp: {
        type: Number,
        required: false
    },
    initialReadingHc: {
        type: Number,
        required: false
    },
    currentReadingHp: {
        type: Number,
        required: false
    },
    currentReadingHc: {
        type: Number,
        required: false
    },

    heurescreuses: {
        type: Number,
        required: false
    },
    currentReading: {
        type: Number,
        required: false
    },


    unit: {
        type: String,
        required: false
    },
    count: {
        type: Number,
        required: false,
        default: 1
    },
    order: {
        type: Number,
        required: false,
        default: 0
    },
    lastChecked: {
        type: Date,
        required: false
    }, order: {
        type: Number,
        default: 1,
        trim: true
    },
    meta: {
        type: Schema.Types.Mixed,
        default: {}
    },
    comment: {
        type: String,
        required: false
    },
    photos: {
        type: [{
            type: String,
        }],
        default: []
    }
}, {
    timestamps: true
});

const CompteurModel = mongoose.model('compteurs', CompteurSchema);

module.exports = CompteurModel;