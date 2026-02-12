// Importing required modules
const multer = require("multer");
const path = require("path");
const fs = require("fs");
const randomstring = require('randomstring');
const sharp = require('sharp'); // new
const heicConvert = require('heic-convert'); // add

const uploadDir = path.join(__dirname, '../uploads/');
fs.mkdirSync(uploadDir, { recursive: true });

// Use memory storage so we can transform the buffer with Sharp
const memoryStorage = multer.memoryStorage();

// File filter function for images
const imageFileFilter = (req, file, cb) => {
    const res = req.res;
    const isImage = file.mimetype?.startsWith('image/');
    if (isImage) return cb(null, true);

    if (req.flash && res) {
        req.flash('error', `Invalid file type: ${file.originalname}. Only images are allowed.`);
        return res.redirect('back');
    }
    return cb(null, false);
};

// File filter function for API images
const apiImageFileFilter = (req, file, cb) => {
    const res = req.res;
    const isImage = file.mimetype?.startsWith('image/');
    if (isImage) return cb(null, true);
    return res.json({ data: { success: 0, message: `Invalid file type: ${file.originalname}. Only images are allowed.`, error: 1 } });
};

// Multer handlers (in-memory)
const uploadImageMemory = multer({
    storage: memoryStorage,
    fileFilter: imageFileFilter
}).single('image');

const uploadAvatarMemory = multer({
    storage: memoryStorage,
    fileFilter: apiImageFileFilter
}).single('avatar');

// Convert any uploaded image buffer to .jpg and write to disk
async function convertToJpg(req, res, next) {
    try {
        if (!req.file) return next();

        // Prepare filename parts
        const shield = randomstring.generate({ length: 10, charset: 'alphanumeric', capitalization: 'lowercase' });
        const now = new Date();
        const dd = String(now.getDate()).padStart(2, '0');
        const mm = String(now.getMonth() + 1).padStart(2, '0');
        const yy = String(now.getFullYear()).slice(-2);
        const numti = `${Date.now()}-${shield}`;
        const timestamp = `${dd}-${mm}-${yy}-${numti}`;

        const baseName = req.file.originalname.replace(/\s+/g, '-').replace(/\.[^.]+$/, '');
        const outputFilename = `${timestamp}_${baseName}.jpg`;
        const outputPath = path.join(uploadDir, outputFilename);

        // Detect HEIC/HEIF and convert buffer first
        const isHeic = /image\/heic|image\/heif/i.test(req.file.mimetype) || /\.heic$/i.test(req.file.originalname);
        let inputBuffer = req.file.buffer;

        if (isHeic) {
            try {
                inputBuffer = await heicConvert({
                    buffer: req.file.buffer,
                    format: 'JPEG',
                    quality: 0.85
                });
            } catch (e) {
                return next(new Error('HEIC non supporté ici. Installez libheif ou utilisez heic-convert (déjà ajouté).'));
            }
        }

        // Finalize with sharp to ensure orientation/flatten/settings
        await sharp(inputBuffer)
            .rotate()
            .flatten({ background: '#ffffff' })
            .jpeg({ quality: 85, chromaSubsampling: '4:4:4' })
            .toFile(outputPath);

        const { size } = fs.statSync(outputPath);

        req.file.filename = outputFilename;
        req.file.path = outputPath;
        req.file.mimetype = 'image/jpeg';
        req.file.size = size;

        return next();
    } catch (err) {
        return next(err);
    }
}

// Keep the generic "file" uploader unchanged (no conversion)
const uploadFile = multer({
    storage: multer.diskStorage({
        destination: (req, file, cb) => cb(null, uploadDir),
        filename: (req, file, cb) => {
            const sanitizedOriginalName = file.originalname.replace(/\s+/g, '-');
            cb(null, `${Date.now()}-${randomstring.generate(6)}-${sanitizedOriginalName}`);
        }
    }),
    fileFilter: imageFileFilter
}).single('file');

module.exports = {
    // Use as middleware chain in routes
    uploadImage: [uploadImageMemory, convertToJpg],
    uploadAvatar: [uploadAvatarMemory, convertToJpg],
    uploadFile
};