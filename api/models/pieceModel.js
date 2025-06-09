const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const InventoryPieceSchema = mongoose.Schema({
    order: {
        type: Number,
        default: 1,
        trim: true
    },
    name: {
        type: String,
        required: false
    },
    type: {
        type: String,
        required: false
    },
    area: {
        type: Number,
        required: false
    },
    count: {
        type: Number,
        required: false,
        default: 0
    },
    order: {
        type: Number,
        required: false,
        default: 0
    },
    meta: {
        type: Schema.Types.Mixed,
        default: {}
    },
    things: {
        type: [{
            type: mongoose.Schema.Types.ObjectId,
            ref: 'things',
        }],
        default: []
    },
    photos: {
        type: [{
            type: String,
        }],
        default: []
    },
    comment: {
        type: String,
        required: false
    },
},
    {
        timestamps: true
    }
);

const piecemodel = mongoose.model('pieces', InventoryPieceSchema);

module.exports = piecemodel;