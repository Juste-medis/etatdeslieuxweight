const userModel = require("../models/userModel");

const PropertySchema = require("../models/propertyModel")
const OwnerSchema = require("../models/ownerModel")
const ReviewSchema = require("../models/reviewModel")
const FileAccessSchema = require("../models/fileaccessModel")
const PieceSchema = require("../models/pieceModel")
const CompteurSchema = require("../models/compteurModel")
const CleDePorteSchema = require("../models/cledeporteModel")
const ThingSchema = require("../models/thingModel")
const FileModel = require('../models/File');
const randomstring = require('randomstring');
const path = require('path');

const fs = require('fs');
const puppeteer = require('puppeteer');
const { generateEntrantProcurationHTML } = require("../utils/pdfs/pdfkit");
const { checkUniqueKey, isValidObjectId, gettempfilePath, autoPopulateRecursively, getRoleName } = require("../utils/utils");
const TenantSchema = require("../models/tenantModel");
const { tenantShema } = require("../utils/shemas");
const { generateReviewHTML } = require("../utils/pdfs/reviewpdfkit");
const { exec } = require('child_process');
const { get } = require("http");
const { sendInviteMail } = require("../services/sendmail");
const config = require("../config/config");


module.exports = {
    addphotos: async (req, res) => {
        var result = {}
        try {
            // Update owners to include photos field
            await OwnerSchema.updateMany(
                { photos: { $exists: false } },
                { $set: { photos: [] } }
            );

            // Update tenants to include photos field
            await TenantSchema.updateMany(
                { photos: { $exists: false } },
                { $set: { photos: [] } }
            );

            result = {
                message: "Photos field added successfully to all owners and tenants",
                status: "success"
            };
        } catch (error) {
            console.error("Error adding photos field:", error);
            return res.status(500).json({
                message: "Error adding photos field",
                error: error.message,
                status: "error"
            });
        }



        return res.status(201).json(result);

    },
}
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
// const superagent = require("superagent");
// const config = require("../config/config");
// setTimeout(async () => {
//     let url = `${config.appUrl}/api/preview-review/683baed4583391769a085a0d`;
//     console.log(`Fetching preview from: ${url}`);

//     try {
//         infos = await superagent
//             .post(url)
//             .query({
//                 "reviewId": "683baed4583391769a085a0d",
//                 "section": "preview",
//             })
//             .set("accept", "application/json")
//             .set("Content-Type", "application/json")
//             .set("Authorization", `Bearer ${config.token}`)
//             .set("User-Agent", "yambro");

//     } catch (error) {
//         console.log(error);
//         throw "search_failed";
//     }
// }, 3000);
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
