const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const MessageSchema = mongoose.Schema({
    fullName: String,
    email: String,
    subject: String,
    message: String,
    user: { type: Schema.Types.ObjectId, ref: 'users', required: false }
},
    {
        timestamps: true
    }
);

module.exports = mongoose.model('messages', MessageSchema);