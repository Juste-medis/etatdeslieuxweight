const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const SettingSchema = new Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },
    value: {
        type: Schema.Types.Mixed,
        required: true,
        trim: true
    },
    options: {
        type: [String],
        required: false,
        default: []
    },
    isActive: {
        type: Boolean,
        default: true
    },
    description: {
        type: String,
        required: false,
        trim: true
    },
    meta: {
        type: Schema.Types.Mixed,
        default: {}
    },
}, {
    timestamps: true
});

const SettingModel = mongoose.model('settings', SettingSchema);

module.exports = SettingModel;