const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const OwnerSchema = mongoose.Schema({
    order: {
        type: Number,
        default: 1,
        trim: true
    },

    lastname: String,
    firstname: String,
    denomination: String,
    type: { type: String, enum: ['physique', 'morale'] },
    representant: { type: Schema.Types.ObjectId, ref: 'owner' },
    email: {
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
        enum: ["female", "male"],
        default: "male",
        trim: true
    },
    photos: {
        type: [{
            type: String,
        }],
        default: []
    },
    comment: {
        type: String
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

const owner = mongoose.model('owners', OwnerSchema);

module.exports = owner;