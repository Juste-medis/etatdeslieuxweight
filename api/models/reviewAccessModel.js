const mongoose = require('mongoose');
const Schema = mongoose.Schema;
var QRCode = require('qrcode')
var randomstring = require("randomstring");

const ReviewAccessSchema = mongoose.Schema({
    user: { type: String, required: true, },
    review: { type: Schema.Types.ObjectId, ref: 'reviews', required: true, },
    accessCode: {
        type: String,
        unique: true,
        sparse: true,     // important if you want to allow multiple `null` values
        default: null
    },
    qrcode: { type: String, unique: true, },
    expiryDate: { type: Date },
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
            console.log(code);

            await mongoose.model('reviewaccess').findByIdAndUpdate(doc._id, { accessCode: qrData, qrcode: qrcode }, { new: true });
        } catch (err) {
            console.error('Erreur génération QR Code:', err);
        }
    }
}
ReviewAccessSchema.post('save', generateqrCode);
ReviewAccessSchema.post('findOneAndUpdate', generateqrCode);
ReviewAccessSchema.post('findByIdAndUpdate', generateqrCode);

const procurationmodel = mongoose.model('reviewaccess', ReviewAccessSchema);

module.exports = procurationmodel;