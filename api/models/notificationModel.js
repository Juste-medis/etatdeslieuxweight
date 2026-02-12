const mongoose = require("mongoose");

const notificationSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true,
        trim: true
    },
    message: {
        type: String,
        required: true,
        trim: true
    },
    recipient_user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user'
    },
    recipient: {
        type: String,
        trim: true
    },
    is_read: {
        type: Boolean,
        default: false,
        trim: true
    },
    push_response: {
        type: String,
        default: null
    },
    data: {
        type: Object,
        default: {}
    }


},
    {
        timestamps: true
    }
);

module.exports = mongoose.model("notifications", notificationSchema);