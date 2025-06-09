const { isValidObjectId } = require('mongoose');
const fs = require('fs');
const path = require('path');
const os = require('os');
const util = require('util');
const FileAccessSchema = require("../models/fileaccessModel");
const FileModel = require('../models/File');

const PropertySchema = require("../models/propertyModel")
const OwnerSchema = require("../models/ownerModel")
const TenantSchema = require("../models/tenantModel")
const ReviewSchema = require("../models/reviewModel")
const PieceSchema = require("../models/pieceModel")
const CompteurSchema = require("../models/compteurModel")
const ThingSchema = require("../models/thingModel")
const CleDePorteSchema = require("../models/cledeporteModel");
const userModel = require("../models/userModel");
const reviewController = require("../controllers/reviewController");

// Convert fs functions to promise-based
const accessAsync = util.promisify(fs.access);
const statAsync = util.promisify(fs.stat);

// Get the system's temporary directory
const tempDir = os.tmpdir();

// Allowed image sizes (prevent path traversal by size parameter)
const ALLOWED_SIZES = ['thumbnail', 'small', 'medium', 'large', 'original'];

module.exports = {
  reviewfile: async (req, res, next) => {
    try {
      const { id } = req.params;
      const theDocument = await FileModel.findOne({
        $or: [
          isValidObjectId(id) ? { _id: id } : { shield: id }
        ]
      })
      const filePath = theDocument.location;

      // Verify file exists and is accessible
      try {
        await accessAsync(filePath, fs.constants.F_OK | fs.constants.R_OK);

        // Get file stats for Content-Length header
        const stats = await statAsync(filePath);

        // Set proper headers
        res.set({
          'Content-Type': theDocument.type || 'image/jpeg',
          'Content-Length': stats.size,
          'Cache-Control': 'public, max-age=86400', // Cache for 24 hours
          'Last-Modified': stats.mtime.toUTCString()
        });

        // Handle If-Modified-Since header for caching
        if (req.headers['if-modified-since']) {
          const ifModifiedSince = new Date(req.headers['if-modified-since']);
          if (stats.mtime <= ifModifiedSince) {
            return res.status(304).end(); // Not Modified
          }
        }

        // Stream the file
        const stream = fs.createReadStream(filePath);

        // Handle stream errors
        stream.on('error', (err) => {
          console.error('File stream error:', err);
          if (!res.headersSent) {
            res.status(500).json({ error: 'Error streaming file' });
          }
        });

        // Pipe the file to response
        stream.pipe(res);

      } catch (err) {
        if (err.code === 'ENOENT') {
          return res.status(404).json({ error: 'File not found' });
        }
        console.error('File access error:', err);
        return res.status(500).json({ error: 'Unable to access file' });
      }

    } catch (err) {
      console.error('Middleware error:', err);
      res.status(500).json({ error: 'Internal server error' });
    }
  },
  getFile: async (req, res, next) => {
    try {
      const { id, size } = req.params;
      const userId = req.user._id.toString();

      // Validate parameters
      if (!isValidObjectId(id)) {
        return res.status(400).json({ error: 'Invalid file ID format' });
      }

      if (size && !ALLOWED_SIZES.includes(size)) {
        return res.status(400).json({ error: 'Invalid image size requested' });
      }

      // Check file access in database

      const fileAccess = await FileAccessSchema.findOne({
        fileId: id,
        userId
      }).lean();

      if (!fileAccess) {
        return res.status(403).json({ error: 'You do not have permission to access this file' });
      }
      const theDocument = await FileModel.findOne({
        $or: [
          isValidObjectId(id) ? { _id: id } : { shield: id }
        ]
      })
      const filePath = theDocument.location;

      // Verify file exists and is accessible
      try {
        await accessAsync(filePath, fs.constants.F_OK | fs.constants.R_OK);

        // Get file stats for Content-Length header
        const stats = await statAsync(filePath);

        // Set proper headers
        res.set({
          'Content-Type': theDocument.type || 'image/jpeg',
          'Content-Length': stats.size,
          'Cache-Control': 'public, max-age=86400', // Cache for 24 hours
          'Last-Modified': stats.mtime.toUTCString()
        });

        // Handle If-Modified-Since header for caching
        if (req.headers['if-modified-since']) {
          const ifModifiedSince = new Date(req.headers['if-modified-since']);
          if (stats.mtime <= ifModifiedSince) {
            return res.status(304).end(); // Not Modified
          }
        }

        // Stream the file
        const stream = fs.createReadStream(filePath);

        // Handle stream errors
        stream.on('error', (err) => {
          console.error('File stream error:', err);
          if (!res.headersSent) {
            res.status(500).json({ error: 'Error streaming file' });
          }
        });

        // Pipe the file to response
        stream.pipe(res);

      } catch (err) {
        if (err.code === 'ENOENT') {
          return res.status(404).json({ error: 'File not found' });
        }
        console.error('File access error:', err);
        return res.status(500).json({ error: 'Unable to access file' });
      }

    } catch (err) {
      console.error('Middleware error:', err);
      res.status(500).json({ error: 'Internal server error' });
    }
  },
  upFile: async (req, res, next) => {
    try {
      const { id, size, thing } = req.params;
      const userId = req.user._id.toString();
      const { file, } = req;
      const profile = req.body.profile || false;
      const reviewId = req.body.review_id || false;
      // Validate file exists
      if (!file) {
        return res.status(400).json({ status: false, message: 'No file uploaded' });
      }
      if (profile) {
        await userModel.findByIdAndUpdate(req.user._id, { imageUrl: file.filename });

        res.status(200).json({
          status: true,
          data: {
            photoUrl: file.filename
          },
          message: "Profile picture updated successfully"
        });


        return
      }

      // Validate thing type
      const validThingTypes = ["compteur", "piece", "property", "reviewauthor", "review", "thing", "cledeporte"];
      if (!validThingTypes.includes(thing)) {
        return res.status(400).json({ status: false, message: 'Invalid thing type', validTypes: validThingTypes });
      }


      const fullReviewt = await reviewController.getfullReview(reviewId)
      if (!fullReviewt) {
        return res.status(404).json({ status: false, message: 'Review not found or unauthorized access' });
      }
      const userPosition = await reviewController.getUserPositionInreview(fullReviewt, req.user.email, userId)

      if (!userPosition) {
        return res.status(404).json({ status: false, message: 'Review not found or unauthorized access' });
      }

      // Validate ID format
      if (!isValidObjectId(id)) {
        return res.status(400).json({
          status: false,
          message: 'Invalid ID format'
        });
      }
      const schemaMap = {
        compteur: CompteurSchema,
        piece: PieceSchema,
        property: PropertySchema,
        owner: OwnerSchema,
        review: ReviewSchema,
        thing: ThingSchema,
        cledeporte: CleDePorteSchema,
      };
      let TheThunSchema, pistage = "photos"
      if ('reviewauthor' === thing) {
        let thingPosition = await reviewController.getUserPositionInreview(fullReviewt, null, id)
        if (!thingPosition) { return res.status(404).json({ status: false, message: 'youw to update an non existing review author for this review' }); }
        TheThunSchema = `${thingPosition}`.includes('owner') ? OwnerSchema : TenantSchema;
        pistage = `meta.${reviewId}`
        const sharp = require('sharp');
        // Add watermark to the image
        const watermarkedImagePath = path.join(tempDir, `watermarked_${file.filename}`);
        const watermark = await sharp("./public/assets/media/logos/app_icon_main.png").resize({ width: 400, height: 200 }).png().toBuffer();
        await sharp(file.path).composite([{ input: watermark, gravity: 'southeast' }]).toFile(watermarkedImagePath);
        // Replace original file with watermarked version
        await fs.promises.unlink(file.path);
        await fs.promises.rename(watermarkedImagePath, file.path);
      } else {
        TheThunSchema = schemaMap[thing];

        if (!TheThunSchema) {
          return res.status(400).json({
            status: false,
            message: "Schema not found for thing type"
          });
        }
      }

      // Find the document to update
      const updatingThing = await TheThunSchema.findOne({
        $or: [{ _id: id }, { shield: id }]
      });

      if (!updatingThing) {
        return res.status(404).json({
          status: false,
          message: `${thing} not found`
        });
      }

      // Create file record
      const fileob = new FileModel({
        name: file.filename,
        author: userId,
        location: file.path,
        shield: Date.now().toString(),
        type: file.mimetype,
        size: file.size,
        originalName: file.originalname
      });

      // Save file and update thing in parallel
      const savedFile = await fileob.save();


      if (thing == 'reviewauthor') {


        // Check if the user already has 4 or more photos
        let existingPhotos = updatingThing.meta?.[reviewId]?.photos || [];
        if (existingPhotos.length >= 4) {
          // Delete the uploaded file since we can't use it
          fs.unlink(file.path, () => { });
          return res.status(400).json({
            status: false,
            message: "Maximum 4 photos allowed"
          });
        }

        let reviewAuthor = await TheThunSchema.findById(updatingThing._id);
        let query = {}
        if (!reviewAuthor.meta?.[reviewId]) {
          query = {
            $set: {
              [pistage]: {
                photos: [`uploads/${file.filename}`]
              }
            }
          };
        } else {
          query = {
            $push: {
              [`${pistage}.photos`]: `uploads/${file.filename}`
            }
          };
        }
        await TheThunSchema.findByIdAndUpdate(
          updatingThing._id,
          query,
          { new: true }
        );
      } else {
        await TheThunSchema.findByIdAndUpdate(
          updatingThing._id,
          {
            $push: {
              photos: `uploads/${file.filename}`
            }
          },
          { new: true }
        )
      }
      // Create file access record
      await FileAccessSchema.create({
        userId: userId,
        fileId: savedFile._id,
        accessType: ['read', 'write', 'delete', 'write'],
      });

      return res.status(200).json({
        status: true,
        data: {
          file: savedFile,
          photoUrl: `uploads/${file.filename}`
        },
        message: "File uploaded successfully"
      });

    } catch (err) {
      console.error('File upload error:', err);

      // Delete the uploaded file if something went wrong
      if (req.file) {
        fs.unlink(req.file.path, () => { });
      }

      res.status(500).json({
        status: false,
        error: 'Internal server error',
        details: process.env.NODE_ENV === 'development' ? err.message : undefined
      });
    }
  },
  delFile: async (req, res, next) => {
    try {
      const { id, thing } = req.params;
      const { delete_id } = req.body;
      const userId = req.user._id.toString();
      const reviewId = req.body.review_id || false;

      if (!delete_id) {
        return res.status(400).json({ status: false, message: 'Missing delete_id in request body' });
      }

      // Validate thing type
      const validThingTypes = ["compteur", "piece", "property", "reviewauthor", "owner", "review", "thing", "cledeporte"];
      if (!validThingTypes.includes(thing)) {
        return res.status(400).json({ status: false, message: 'Invalid thing type', validTypes: validThingTypes });
      }

      const fullReviewt = await reviewController.getfullReview(reviewId)
      if (!fullReviewt) {
        return res.status(404).json({ status: false, message: 'Review not found or unauthorized access' });
      }

      // Get the file record
      const fileRecord = await FileModel.findOne({ $or: [{ location: `${delete_id}`.replace("uploads/", "") }, { name: `${delete_id}`.replace("uploads/", "") },] }).lean();

      if (!fileRecord) { return res.status(404).json({ status: false, message: 'File not found' }); }

      // Verify user owns the file or has delete permissions
      const fileAccess = await FileAccessSchema.findOne({ fileId: fileRecord._id, userId: userId, accessType: { $in: ['delete', 'write'] } });

      if (!fileAccess && fileRecord.author.toString() !== userId) { return res.status(403).json({ status: false, message: 'Unauthorized to delete this file' }); }

      const schemaMap = {
        compteur: CompteurSchema,
        piece: PieceSchema,
        property: PropertySchema,
        owner: OwnerSchema,
        review: ReviewSchema,
        thing: ThingSchema, cledeporte: CleDePorteSchema // Assuming cledeporte is a type of thing

      };
      let TheThunSchema, pistage = "photos"
      if ('reviewauthor' === thing) {
        let thingPosition = await reviewController.getUserPositionInreview(fullReviewt, null, id)
        if (!thingPosition) { return res.status(404).json({ status: false, message: 'youw to update an non existing review author for this review' }); }
        TheThunSchema = `${thingPosition}`.includes('owner') ? OwnerSchema : TenantSchema;
        pistage = `meta.${reviewId}`
      } else {
        TheThunSchema = schemaMap[thing];
        if (!TheThunSchema) { return res.status(400).json({ status: false, message: "Schema not found for thing type" }); }
      }
      // Remove the file reference from the parent document
      if (thing == 'reviewauthor') {
        let reviewAuthor = await TheThunSchema.findById(id);
        let query = {}
        if (!reviewAuthor.meta?.[reviewId]) {
          query = {
            $set: {
              [pistage]: {
                photos: reviewAuthor.meta?.[reviewId]?.photos?.filter(photo => photo !== `uploads/${fileRecord.name}`)
              }
            }
          };
        } else {
          query = {
            $pull: {
              [`${pistage}.photos`]: `uploads/${fileRecord.name}`
            }
          };
        }
        await TheThunSchema.findByIdAndUpdate(
          id,
          query,
          { new: true }
        );
      } else {
        await TheThunSchema.findByIdAndUpdate(id, { $pull: { photos: `uploads/${fileRecord.name}` } }, { new: true });
      }

      // Delete the file access records
      await FileAccessSchema.deleteMany({ fileId: fileRecord._id });

      // Delete the file record
      await FileModel.findByIdAndDelete(fileRecord._id);

      // Delete the actual file from storage
      fs.unlink(fileRecord.location, (err) => {
        if (err) console.error('Error deleting file:', err);
      });

      return res.status(200).json({
        status: true,
        message: "File deleted successfully"
      });

    } catch (err) {
      console.error('File deletion error:', err);

      res.status(500).json({
        status: false,
        error: 'Internal server error',
        details: process.env.NODE_ENV === 'development' ? err.message : undefined
      });
    }
  },
};