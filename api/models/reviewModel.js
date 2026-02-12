const mongoose = require('mongoose');
const Schema = mongoose.Schema;
var QRCode = require('qrcode')
const config = require("../config/config");


require('./pieceModel')
require('./compteurModel')
require('./cledeporteModel')
require('./thingModel')
require('./userModel')

const ReviewSchema = mongoose.Schema({
    author: {
        type: Schema.Types.ObjectId,
        ref: 'user',
        required: true,
    },
    mandataire: {
        type: Schema.Types.ObjectId,
        ref: 'tenants',
        required: false,
    },
    qrcode: {
        type: String,
        unique: true,
    },
    owners: [{
        type: Schema.Types.ObjectId,
        ref: 'owners',
    }],
    exitenants: [{
        type: Schema.Types.ObjectId,
        ref: 'tenants',
    }],
    entrantenants: [{
        type: Schema.Types.ObjectId,
        ref: 'tenants',
    }],

    pieces: [{
        type: Schema.Types.ObjectId,
        ref: 'pieces',
    }],
    cledeportes: [{
        type: Schema.Types.ObjectId,
        ref: 'cledeportes',
    }],
    compteurs: [{
        type: Schema.Types.ObjectId,
        ref: 'compteurs',
    }],
    photos: {
        type: [{
            type: String,
        }],
        default: []
    },
    credited: { type: Boolean, default: false },
    propertyDetails: {
        type: Schema.Types.ObjectId,
        ref: 'properties',
    },

    document_address: String,
    review_type: String,
    entranDocumentId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'files',
    },
    sortantDocumentId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'files',
    },
    procuration: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'procurations',
        default: null,
    },
    status: {
        type: String,
        default: "draft",
    },
    dateOfRealisation: {
        type: Date,
    },
    meta: {
        type: Schema.Types.Mixed,
        default: {},
    },
    copyOptions: {
        type: Schema.Types.Mixed,
        default: null
    },
},
    {
        timestamps: true
    }
);

// Middleware post-save pour génération du QR Code

const generateqrCode = async function (doc) {
    if (doc && !doc?.qrcode && doc?.qrcode != '') {
        const qrData = `${config.appUrl}/etat-des-lieux/${doc._id}`;

        try {
            const qrcode = await QRCode.toDataURL(qrData, {
                errorCorrectionLevel: 'H',
                margin: 2,
                scale: 10
            });

            await mongoose.model('reviews').findByIdAndUpdate(doc._id, { qrcode });
        } catch (err) {
            console.error('Erreur génération QR Code:', err);
        }
    }
}
ReviewSchema.post('save', generateqrCode);
ReviewSchema.post('findOneAndUpdate', generateqrCode);
ReviewSchema.post('findByIdAndUpdate', generateqrCode);

module.exports = mongoose.model('reviews', ReviewSchema);