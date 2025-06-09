const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const PropertySchema = mongoose.Schema({
    address: {
        type: String,
        required: true
    },
    complement: {
        type: String,
        default: ''
    },
    floor: {
        type: String,
        default: ''
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
        default: ''
    },
    cellar: {
        type: String,
        default: ''
    },
    garage: {
        type: String,
        default: ''
    },
    parking: {
        type: String,
        default: ''
    },
    heatingType: {
        type: String,
        default: 'gas'
    },
    heatingMode: {
        type: String,
        default: 'individual'
    },
    hotWaterType: {
        type: String,
        default: 'electric'
    },
    hotWaterMode: {
        type: String,
        default: 'individual'
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