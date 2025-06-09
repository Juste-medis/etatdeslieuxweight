const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const CleDePorteSchema = new Schema({
    name: {
        type: String,
        required: true
    },
    type: {
        type: String,
        required: false
    },
    comment: {
        type: String,
        required: false
    },
    location: {
        type: String,
        required: false
    },
    serialNumber: {
        type: String,
        required: false
    },
    count: {
        type: Number,
        required: false,
        default: 1
    }, order: {
        type: Number,
        default: 1,
        trim: true
    },
    order: {
        type: Number,
        required: false,
        default: 0
    },
    dateCreated: {
        type: Date,
        required: false
    },
    dateUpdated: {
        type: Date,
        required: false
    },
    meta: {
        type: Schema.Types.Mixed,
        default: {}
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

const CleDePorteModel = mongoose.model('cledeportes', CleDePorteSchema);

module.exports = CleDePorteModel;