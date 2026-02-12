const mongoose = require('mongoose');

const LoginHistorySchema = mongoose.Schema({
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user',
        required: true,
    },
    loginAt: {
        type: Date,
        default: Date.now,
    },
    logoutAt: {
        type: Date,
    },
    ipAddress: {
        type: String,
        default: '',
    },
    userAgent: {
        type: String,
        default: '',
    },
    device: {
        type: String,
        default: '',
    },
},
    {
        timestamps: true
    });

const loginhistorymodel = mongoose.model('loginhistory', LoginHistorySchema);
module.exports = loginhistorymodel;