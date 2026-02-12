const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const PropertySchema = mongoose.Schema({
    address: {
        type: String,
        required: true
    },
    complement: {
        type: String,
    },
    floor: {
        type: String,
    },
    surface: {
        type: String,
        required: true
    },
    roomCount: {
        type: Number,
        required: true
    },
    furnitured: {
        type: Boolean,
        default: false
    },
    box: {
        type: String,
    },
    cellar: {
        type: String,
    },
    garage: {
        type: String,
        default: ''
    },
    parking: {
        type: String,
    },
    heatingType: {
        type: String,
    },
    heatingMode: {
        type: String,
    },
    hotWaterType: {
        type: String,
    },
    hotWaterMode: {
        type: String,
    },
    is_active: {
        type: Boolean,
        default: true
    },
    meta: {
        type: Schema.Types.Mixed,
        default: {},
    },

},
    {
        timestamps: true
    }
);

const property = mongoose.model('properties', PropertySchema);

module.exports = property;  