const mongoose = require("mongoose");

const userDeviceSchema = new mongoose.Schema({

    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'users',
        required: true
    },
    userEmail: {
        type: String,
        trim: true
    },
    registrationToken: {
        type: String,
        required: true
    },
    deviceId: {
        type: String,
        required: true
    }

},
    {
        timestamps: true
    }
);

module.exports = mongoose.model('notificationFcm', userDeviceSchema);

