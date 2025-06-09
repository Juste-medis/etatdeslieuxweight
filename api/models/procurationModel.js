const mongoose = require('mongoose');
const Schema = mongoose.Schema;
var QRCode = require('qrcode')
var randomstring = require("randomstring");

const ProcurationSchema = mongoose.Schema({
    author: {
        type: Schema.Types.ObjectId,
        ref: 'users',
        required: true,
    },
    owners: [{
        type: Schema.Types.ObjectId,
        ref: 'owners',
    }],
    accesgivenTo: [{
        type: Schema.Types.ObjectId,
        ref: 'tenants',
    }],
    accessCode: {
        type: String,
        unique: true,
    },
    qrcode: {
        type: String,
        unique: true,
    },
    exitenants: [{
        type: Schema.Types.ObjectId,
        ref: 'tenants',
    }],
    entrantenants: [{
        type: Schema.Types.ObjectId,
        ref: 'tenants',
    }],
    propertyDetails: {
        type: Schema.Types.ObjectId,
        ref: 'properties',
    },
    dateOfProcuration: {
        type: Date,
        required: true,
    },
    estimatedDateOfReview: {
        type: Date,
        required: true,
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
    meta: {
        type: Schema.Types.Mixed,
        default: {},
    },
},
    {
        timestamps: true
    }
);
const generateqrCode = async function (doc) {
    if (!doc.qrcode && doc.qrcode != '') {
        const code = randomstring.generate({ length: 8, charset: 'alphanumeric', capitalization: 'uppercase' });
        const qrData = `JET-${code}`;
        try {
            const qrcode = await QRCode.toDataURL(qrData, { errorCorrectionLevel: 'H', margin: 2, scale: 10 });

            await mongoose.model('procurations').findByIdAndUpdate(doc._id, { accessCode: qrData, qrcode: qrcode }, { new: true });
        } catch (err) {
            console.error('Erreur génération QR Code:', err);
        }
    }
}
ProcurationSchema.post('save', generateqrCode);
ProcurationSchema.post('findOneAndUpdate', generateqrCode);
ProcurationSchema.post('findByIdAndUpdate', generateqrCode);

const procurationmodel = mongoose.model('procurations', ProcurationSchema);

module.exports = procurationmodel;