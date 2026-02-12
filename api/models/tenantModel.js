const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const TenantSchema = mongoose.Schema({
    lastname: String,
    firstname: String,
    denomination: String,
    type: { type: String, enum: ['physique', 'morale'], default: 'physique' },
    representant: { type: Schema.Types.ObjectId, ref: 'tenants' },
    order: {
        type: Number,
        default: 1,
        trim: true
    }, email: {
        type: String,
        required: true,
        trim: true
    },
    avatar: {
        type: String,
        trim: true
    },
    dob: {
        type: Date,
    },
    placeofbirth: String,
    address: String,
    phone: {
        type: String,
        trim: true
    },
    gender: {
        type: String,
        enum: ["Female", "Male"],
        default: "Male",
        trim: true
    },
    comment: {
        type: String
    },
    is_active: {
        type: Boolean,
        default: true
    },
    photos: {
        type: [{
            type: String,
        }],
        default: []
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
module.exports = mongoose.model('tenants', TenantSchema);