const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const TrashSchema = mongoose.Schema({
    collectionName: String,
    originalId: Schema.Types.ObjectId,
    deletedAt: { type: Date, default: Date.now },
    deletedBy: { type: Schema.Types.ObjectId, ref: 'user' },
    data: { type: Schema.Types.Mixed, default: {}, },
},
    {
        timestamps: true
    }
);

module.exports = mongoose.model('systemtrash', TrashSchema);