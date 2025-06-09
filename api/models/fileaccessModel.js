const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const FileAccessSchema = mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    fileId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'files',
        required: true
    },
    accessType: {
        type: [String],
        enum: ['read', 'write', 'delete', 'update'],
        required: true
    }
},
    {
        timestamps: true
    }
);

module.exports = mongoose.model('fileaccess', FileAccessSchema);;