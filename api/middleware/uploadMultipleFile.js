// Importing required modules
const multer = require("multer");
const path = require("path");
const fs = require("fs");

// Importing the service function to delete uploaded files
const deleteImages = require("../services/deleteImage");

// Configuration for Multer and file storage
const galleryStorage = multer.diskStorage({

    destination: function (req, file, cb) {
        if (file.fieldname === 'image' || file.fieldname === 'gallery') {
            const destinationPath = path.join(__dirname, '../uploads/');
            cb(null, destinationPath);
        }
    },
    filename: (req, file, cb) => {
        const timestamp = Date.now();
        const extension = path.extname(file.originalname);
        // Replace spaces with hyphens in the original filename
        const sanitizedOriginalName = file.originalname.replace(/\s+/g, '-');
        // Combine the timestamp with the sanitized filename
        const newFilename = `${timestamp}_${sanitizedOriginalName}`;
        cb(null, newFilename);
    }

});

const galleryUpload = multer({
    storage: galleryStorage
});

const uploadMiddleware = (fields) => {

    return (req, res, next) => {

        galleryUpload.fields(fields)(req, res, (err) => {

            if (err) {
                return res.status(400).json({ error: err.message });
            }

            const files = req.files;
            const errors = [];
            let galleryImageCount = 0; // Variable to count gallery images

            // Loop through the keys of the files object
            Object.keys(files).forEach((fieldname) => {


                files[fieldname].forEach((file) => {
                     // MIME types for PDF and common video formats
                     const disallowedTypes = ['application/pdf', 'video/mp4', 'video/mpeg', 'video/ogg', 'video/webm', 'video/quicktime', 'video/x-msvideo', 'video/x-flv'];

                     if (disallowedTypes.includes(file.mimetype)) {
                         errors.push(`Invalid file type: ${file.originalname}. PDF and video formats are not allowed. Only image formats are allowed.`);
                     }
                });
            });

            if (errors.length > 0) {
                // Remove uploaded files
                Object.keys(files).forEach((fieldname) => {
                    files[fieldname].forEach((file) => {
                        deleteImages(file.filename)
                    });
                });
                req.flash('error', errors.join('\n'));
                return res.redirect('back');
            }

            req.files = files;
            next();
        });
    };
};

// Use uploadMiddleware with specified fields
const fieldsToUpload = [
    { name: 'image', maxCount: 1 },
    { name: 'gallery', maxCount: 30 }
];

const multiplefile = uploadMiddleware(fieldsToUpload);

module.exports = multiplefile;

