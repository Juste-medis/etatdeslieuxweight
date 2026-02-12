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
const ReviewAccessModel = require('../models/reviewAccessModel');
const ProcurationSchema = require("../models/procurationModel")
const settingModel = require("../models/settingModel");
const couponModel = require("../models/couponModel");
const otpModel = require("../models/otpModel");
const userNotificationModel = require("../models/userNotificationModel");
const notificationModel = require("../models/notificationModel");
const { backupAllCollections } = require("../utils/backupdbs");

const clearSomeCollection = async (req, res) => {

    var result = {};

    await backupAllCollections().catch(console.error);

    try {
        // Clear all collections without users
        await CleDePorteSchema.deleteMany({});
        await CompteurSchema.deleteMany({});
        await FileAccessSchema.deleteMany({});
        await FileModel.deleteMany({});
        await OwnerSchema.deleteMany({});
        await PropertySchema.deleteMany({});
        await ReviewSchema.deleteMany({});
        await TenantSchema.deleteMany({});
        await PieceSchema.deleteMany({});
        await ThingSchema.deleteMany({});
        await ReviewAccessModel.deleteMany({});
        await ProcurationSchema.deleteMany({});
        await settingModel.deleteMany({});
        await couponModel.deleteMany({});
        await otpModel.deleteMany({});
        await userNotificationModel.deleteMany({});
        await notificationModel.deleteMany({});


        // Clear all files in public/documents directory
        const documentsPath = path.join(__dirname, '../public/documents');
        if (fs.existsSync(documentsPath)) {
            const deleteFiles = (dirPath) => {
                const items = fs.readdirSync(dirPath);
                for (const item of items) {
                    const itemPath = path.join(dirPath, item);
                    if (fs.statSync(itemPath).isDirectory()) {
                        deleteFiles(itemPath);
                    } else {
                        fs.unlinkSync(itemPath);
                    }
                }
            };
            deleteFiles(documentsPath);
        }

        result = {
            message: "All specified collections cleared successfully",
            status: "success"
        };
    } catch (error) {
        console.error("Error clearing collections:", error);
        return res.status(500).json({
            message: "Error clearing collections",
            error: error.message,
            status: "error"
        });
    }

    return res.status(200).json(result);


}

const addphotos = async (req, res) => {
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

}
module.exports = {
    addphotos: clearSomeCollection
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
