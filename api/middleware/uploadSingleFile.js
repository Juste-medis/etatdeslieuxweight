// Importing required modules
const multer = require("multer");
const path = require("path");
const fs = require("fs");
const randomstring = require('randomstring');

// Configuration for Multer and file storage
const storage = multer.diskStorage({

    destination: function (req, file, cb) {
        cb(null, path.join(__dirname, '../uploads/'));
    },
    filename: function (req, file, cb) {

        // Get the current timestamp
        const shield = randomstring.generate({
            length: 10,
            charset: 'alphanumeric',
            capitalization: 'lowercase',
        });
        const timestamp = `${Date.now()}-${shield}`;
        // Get the current file originalname
        const originalname = file.originalname;
        // Get the file extension
        const extension = originalname.split('.').pop();

        const sanitizedOriginalName = file.originalname.replace(/\s+/g, '-');
        //Get create new name for file
        const newFilename = `${timestamp}_${sanitizedOriginalName}`;
        cb(null, newFilename);
    }
});

// File filter function for images
const imageFileFilter = (req, file, cb) => {

    const disallowedTypes = ['application/pdf', 'video/mp4', 'video/mpeg', 'video/quicktime'];
    const res = req.res;

    if (!disallowedTypes.includes(file.mimetype)) {
        cb(null, true);
    } else {
        req.flash('error', `Invalid file type: ${file.originalname}. Only images are allowed.`);
        return res.redirect('back');
    }

    if (file.size > 5 * 1024 * 1024) { // 5 MB limit
        req.flash('error', `File size exceeds the limit of 5 MB.`);
        return res.redirect('back');
    }

};

// File filter function for images
const apiImageFileFilter = (req, file, cb) => {

    // Disallowed file types
    const disallowedTypes = ['application/pdf', 'video/mp4', 'video/mpeg', 'video/quicktime'];
    const res = req.res;

    if (!disallowedTypes.includes(file.mimetype)) {
        cb(null, true);
    } else {
        return res.json({ data: { success: 0, message: `Invalid file type: ${file.originalname}. Only images are allowed.`, error: 1 } })
    }

};


// Upload handlers
const uploadImage = multer({
    storage: storage,
    fileFilter: imageFileFilter
}).single('image');

// Upload handlers
const uploadFile = multer({
    storage: storage,
    fileFilter: imageFileFilter
}).single('file');

// Upload handlers
const uploadAvatar = multer({
    storage: storage,
    fileFilter: apiImageFileFilter
}).single('avatar');



module.exports = { uploadImage, uploadAvatar, uploadFile };