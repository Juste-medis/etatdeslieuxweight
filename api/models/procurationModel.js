require('./userModel');
const mongoose = require('mongoose');
const Schema = mongoose.Schema;
var QRCode = require('qrcode')
var randomstring = require("randomstring");
const { generateAccessCode } = require('../utils/utils');


const ProcurationSchema = mongoose.Schema({
    author: {
        type: Schema.Types.ObjectId,
        ref: 'user',
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
    },
    qrcode: {
        type: String,
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
    credited: { type: Boolean, default: false },
    entranDocumentId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'files',
    },
    sortantDocumentId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'files',
    },
    status: {
        type: String,
        default: "draft",
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
    if (doc && !doc.qrcode && doc.qrcode != '') {
        const qrData = generateAccessCode();
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
// before returning procuration, populate reviews linked to this procuration
ProcurationSchema.pre("save", generateqrCode);
ProcurationSchema.pre("create", generateqrCode);






ProcurationSchema.post(['find', 'findOne'], async function (docs) {

    if (!docs) return;

    const docsArray = Array.isArray(docs) ? docs : [docs];

    for (let doc of docsArray) {
        if (doc && doc._id) {
            const reviews = await mongoose.model('reviews').find(
                { procuration: doc._id }
            ).select('_id status');

            doc.reviews = reviews;

            doc.completedreview = reviews.some(review => review.status === 'completed');
        }
    }
});






const procurationmodel = mongoose.model('procurations', ProcurationSchema);

module.exports = procurationmodel;