const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const UserSchema = mongoose.Schema({
    firstName: String,
    lastName: String,
    level: {
        type: String,
        default: 'standard',
    },
    type: {
        type: String,
        default: 'tenant',
    },
    placeOfBirth: {
        type: String,
        default: '',
    },
    reason: {
        type: String,
        default: 'legal_person',
    },
    imageUrl: {
        type: String,
        trim: true
    },
    email: {
        type: String,
        required: true,
        trim: true
    },
    country_code: {
        type: String,
        trim: true,
        default: '33',
    },
    phone: {
        type: String,
        required: true,
        trim: true
    },
    password: {
        type: String,
        required: true
    },
    country: {
        type: String,
        default: 'France',
    },
    gender: {
        type: String,
        enum: ["Female", "Male"],
        default: "Female",
        trim: true
    },
    dob: {
        type: String
    },
    about: {
        type: String
    },
    interestCategoryId: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'category',
        trim: true
    }],

    is_active: {
        type: Boolean,
        default: true
    },
    verifiedAt: {
        type: Date,
        default: null
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

module.exports = mongoose.model('user', UserSchema);