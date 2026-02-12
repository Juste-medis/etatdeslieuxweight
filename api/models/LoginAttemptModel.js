const mongoose = require('mongoose');

const UserSchema = mongoose.Schema({
    email: { type: String, required: true },
    ip: { type: String, required: true },
    attempts: { type: Number, default: 0 },
    lockedUntil: { type: Date, default: null },
},
    {
        timestamps: true
    }
);

module.exports = mongoose.model('loginAttempt', UserSchema);