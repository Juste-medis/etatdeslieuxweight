
const userModel = require("../models/userModel");

const PropertySchema = require("../models/propertyModel")
const OwnerSchema = require("../models/ownerModel")
const ProcurationSchema = require("../models/procurationModel")
const FileAccessSchema = require("../models/fileaccessModel")
const FileModel = require('../models/File');
const ReviewAccessModel = require('../models/reviewAccessModel');
const randomstring = require('randomstring');
const path = require('path');
const ReviewSchema = require("../models/reviewModel")
const config = require("../config/config");

const puppeteer = require('puppeteer');
const { generateEntrantProcurationHTML } = require("../utils/pdfs/pdfkit");
const { checkUniqueKey } = require("../utils/utils");
const { sendInviteMailProcuration } = require("../services/sendmail");
const reviewController = require("./reviewController");

const generateProcurationPDF = async (procurationData, outputPath, sortantPdfPath, signature) => {
    try {
        const browser = await puppeteer.launch({
            headless: true,
            args: ['--no-sandbox', '--disable-setuid-sandbox']
        });
        const page = await browser.newPage();

        // Generate the HTML content
        const htmlContent = generateEntrantProcurationHTML(procurationData, "entrant", signature);
        const htmlContentso = generateEntrantProcurationHTML(procurationData, "exitant", signature);

        await page.setContent(htmlContent, {
            waitUntil: 'networkidle0'
        });

        await page.pdf({
            path: outputPath,
            format: 'A4',
            margin: {
                top: '20px',
                right: '20px',
                bottom: '20px',
                left: '20px'
            },
            printBackground: true
        });

        await page.setContent(htmlContentso, {
            waitUntil: 'networkidle0'
        });

        await page.pdf({
            path: sortantPdfPath,
            format: 'A4',
            margin: {
                top: '20px',
                right: '20px',
                bottom: '20px',
                left: '20px'
            },
            printBackground: true
        });

        await browser.close();
        return outputPath;
    } catch (error) {
        throw error;
    }
};


const getfullProcuration = async (procuration) => {
    // Récupérer l'état des lieux complet
    const fullReview = await ProcurationSchema.findById(procuration._id)
        .populate('propertyDetails')
        .populate({
            path: 'accesgivenTo',
            populate: {
                path: 'representant',
                model: 'owners'
            }
        })
        .populate({
            path: 'owners',
            populate: {
                path: 'representant',
                model: 'owners'
            }
        })
        .populate({
            path: 'exitenants',
            populate: {
                path: 'representant',
                model: 'tenants'
            }
        })
        .populate({
            path: 'entrantenants',
            populate: {
                path: 'representant',
                model: 'tenants'
            }
        })
        .lean()

    if (!fullReview) {
        throw new Error("Review not found");
    }
    // Vérifier les signatures
    return {
        ...fullReview,
    };


}
const ___senProcurationEmails = async (reviewId) => {
    const fullprocuration = await getfullProcuration(reviewId);
    const emailRoles = new Map();

    // Add owners and their representatives
    fullprocuration.owners.forEach(owner => {
        emailRoles.set(owner.email, 'owner');
        if (owner.representant) {
            emailRoles.set(owner.representant.email, 'owner_representative');
        }
    });

    // Add exit tenants and their representatives
    // fullprocuration.exitenants.forEach(tenant => {
    //     sendInviteMailProcuration(tenant.email, fullprocuration)
    // });
    // fullprocuration.entrantenants.forEach(tenant => {
    //     sendInviteMailProcuration(tenant.email, fullprocuration)
    // });

    if (fullprocuration.accesgivenTo) {
        sendInviteMailProcuration(fullprocuration.accesgivenTo[0].email, fullprocuration, {
            accesgivenTo: fullprocuration.accesgivenTo[0],
        })
        emailRoles.set(fullprocuration.accesgivenTo.email, 'mandataire');
        if (fullprocuration.accesgivenTo.representant) {
            emailRoles.set(fullprocuration.mandataire.representant.email, 'mandataire_representative');
        }
    }

}


module.exports = {
    createprocuration: async (req, res) => {

        // Logic for editing user details
        const userId = req.user._id;
        const TenantSchema = require("../models/tenantModel")

        const { owners, exitenants, entrantenants, propertyDetails, documentDetails, complementaryDetails, documentDetails: { address, review_type, review_estimed_date } } = req.body;
        try {
            checkUniqueKey(owners, "representantemail", "Les emails des mandants doivent être uniques");
            checkUniqueKey(exitenants, "representantemail", "Les emails des locataires sortant doivent être uniques");
            checkUniqueKey(entrantenants, "representantemail", "Les emails des locataires entrant doivent être uniques");
        } catch (err) {
            throw err.message;
        }

        // return res.status(201).json({});


        // Create or update owners
        const ownerPromises = owners.map(async (owner) => {
            if (owner.type === 'physique') {
                return await OwnerSchema.create({ type: owner.type, lastname: owner.lastname, firstname: owner.firstname, dob: owner.dob, placeofbirth: owner.placeofbirth, address: owner.address, email: owner.representantemail, phone: owner.representantphone, });
            } else if (owner.type === 'morale') {
                const representant = await OwnerSchema.create({ type: owner.type, lastname: owner.representantlastname, firstname: owner.representantfirstname, dob: owner.dob, placeofbirth: owner.placeofbirth, phone: owner.representantphone, address: owner.address, email: owner.representantemail, gender: owner.gender, });
                return await OwnerSchema.create({ type: owner.type, denomination: owner.denomination, representant: representant._id, dob: owner.dob, address: owner.address, phone: owner.phone, email: owner.representantemail, });
            }
        });

        const exitenantPromises = exitenants.map(async (tenant) => {
            if (tenant.type === 'physique') {
                return await TenantSchema.create({ type: tenant.type, lastname: tenant.lastname, firstname: tenant.firstname, dob: tenant.dob, placeofbirth: tenant.placeofbirth, address: tenant.address, phone: tenant.phone, email: tenant.representantemail ?? tenant.email });
            } else if (tenant.type === 'morale') {
                const representant = await TenantSchema.create({ type: "physique", lastname: tenant.representantlastname, firstname: tenant.representantfirstname, dob: tenant.dob, placeofbirth: tenant.placeofbirth, phone: tenant.representantphone, address: tenant.address, email: tenant.representantemail ?? tenant.email });
                return await TenantSchema.create({ type: tenant.type, denomination: tenant.denomination, representant: representant._id, dob: tenant.dob, address: tenant.address, phone: tenant.phone, email: tenant.representantemail ?? tenant.email });
            }
        });
        const entrantenantPromises = entrantenants.map(async (tenant) => {
            if (tenant.type === 'physique') {
                return await TenantSchema.create({ type: tenant.type, lastname: tenant.lastname, firstname: tenant.firstname, dob: tenant.dob, placeofbirth: tenant.placeofbirth, address: tenant.address, phone: tenant.phone, email: tenant.representantemail ?? tenant.email });
            } else if (tenant.type === 'morale') {
                const representant = await TenantSchema.create({ type: "physique", lastname: tenant.representantlastname, firstname: tenant.representantfirstname, dob: tenant.dob, placeofbirth: tenant.placeofbirth, phone: tenant.representantphone, address: tenant.address, email: tenant.representantemail ?? tenant.email });
                return await TenantSchema.create({ type: tenant.type, denomination: tenant.denomination, representant: representant._id, dob: tenant.dob, address: tenant.address, phone: tenant.phone, email: tenant.representantemail ?? tenant.email });
            }
        });


        const createdOwners = await Promise.all(ownerPromises);
        const createdExitenants = await Promise.all(exitenantPromises);
        const createdEntrantenants = await Promise.all(entrantenantPromises);


        //-----------------creation du mandateire--------------------------

        let frontmandataire = [...exitenants, ...entrantenants].find((tenant) => tenant.id === documentDetails.accesgivenTo);
        let backmandataire = [...createdExitenants, ...createdEntrantenants].find((tenant) => tenant.email === frontmandataire.email);

        //===================================================================

        const createdProperty = await PropertySchema.create({
            address: propertyDetails.address,
            complement: propertyDetails.complement,
            floor: propertyDetails.floor,
            surface: propertyDetails.surface,
            roomCount: propertyDetails.roomCount,
            furnitured: propertyDetails.furnitured,
            box: propertyDetails.box,
            cellar: propertyDetails.cellar,
            garage: propertyDetails.garage,
            parking: propertyDetails.parking,
        });
        let procuration = await ProcurationSchema.create({
            dateOfProcuration: documentDetails.dateOfProcuration || new Date(),
            author: userId,
            owners: createdOwners.map(owner => owner._id),
            exitenants: createdExitenants.map(tenant => tenant._id),
            entrantenants: createdEntrantenants.map(tenant => tenant._id),
            propertyDetails: createdProperty._id,
            document_address: address,
            review_type,
            accesgivenTo: backmandataire._id,
            estimatedDateOfReview: review_estimed_date,
            meta: {
                signatures: {},
                ...complementaryDetails
            }
        });
        let sortantreview = await ReviewSchema.create({
            author: userId,
            mandataire: backmandataire._id,
            procuration: procuration._id,
            owners: createdOwners.map(owner => owner._id),
            exitenants: createdExitenants.map(tenant => tenant._id),
            entrantenants: createdEntrantenants.map(tenant => tenant._id),
            propertyDetails: createdProperty._id,
            document_address: createdProperty.address,
            review_type: "exit",
            meta: {
                signatures: {},
                "fillingPercentage": 0,
                ...complementaryDetails
            },
            pieces: [],
            clesDePorte: [],
            compteurs: [],
        });

        let entrantreview = await ReviewSchema.create({
            author: userId,
            mandataire: backmandataire._id,
            procuration: procuration._id,
            owners: createdOwners.map(owner => owner._id),
            exitenants: createdExitenants.map(tenant => tenant._id),
            entrantenants: createdEntrantenants.map(tenant => tenant._id),
            propertyDetails: createdProperty._id,
            document_address: createdProperty.address,
            review_type: "entrance",
            meta: {
                signatures: {},
                "fillingPercentage": 0,
                ...complementaryDetails
            },
            pieces: [],
            clesDePorte: [],
            compteurs: [],
        });

        const bacbackmandatairePosition = await reviewController.getUserPositionInreview(entrantreview._id, backmandataire.email);


        const RecAccess = new ReviewAccessModel({
            user: `${backmandataire.email}`, review: bacbackmandatairePosition == "entrantenant" ? entrantreview._id : sortantreview._id,
            expiryDate: new Date(new Date().getTime() + 24 * 60 * 60 * 1000 * 30),
        });
        RecAccess.save();

        const createFileForReview = async (review, review_type = "exit", documentId = "sortantDocumentId") => {
            const shield = randomstring.generate({ length: 120, charset: 'alphanumeric', capitalization: 'lowercase', });
            const pdfFileName = `review_${shield}.pdf`;
            let pdfPath = `./public/documents/${review_type}_${pdfFileName}`;

            try {
                const SortantFileObject = new FileModel({ name: `${review_type}_${pdfFileName}`, author: userId, location: pdfPath, shield, type: "application/pdf" });
                SortantFileObject.save();
                await FileAccessSchema.create({ userId: userId, fileId: SortantFileObject._id, accessType: ['read', 'write', 'delete', 'update'], });
                await Promise.all([...[...createdExitenants, ...createdOwners].map(tenant => FileAccessSchema.create({ userId: tenant._id, fileId: SortantFileObject._id, accessType: ['read', 'update'] }))]);
                await ReviewSchema.findByIdAndUpdate(review._id, { [documentId]: SortantFileObject._id, });
            } catch (error) {
                console.error('PDF generation failed:', error);
                return res.status(500).json({
                    status: false,
                    message: "Procuration created but PDF generation failed",
                    data: review
                });
            }
        }
        createFileForReview(entrantreview, "entrance", "entranDocumentId");
        createFileForReview(sortantreview, "sortant", "sortantDocumentId");





        // Populate the procuration data for PDF generation
        const fullProcuration = await getfullProcuration(procuration._id)

        // Generate PDF
        const shield = randomstring.generate({ length: 120, charset: 'alphanumeric', capitalization: 'lowercase', });
        const pdfFileName = `procuration_${shield}.pdf`;
        const entrantPdfPath = `./public/documents/entrance_${pdfFileName}`, sortantPdfPath = `./public/documents/sortant_${pdfFileName}`;

        try {
            await generateProcurationPDF(fullProcuration, entrantPdfPath, sortantPdfPath);

            const EntrantFileObject = new FileModel({ name: `entrance_${pdfFileName}`, author: userId, location: entrantPdfPath, shield, type: "application/pdf" }), SortantFileObject = new FileModel({ name: `sortant_${pdfFileName}`, author: userId, location: sortantPdfPath, shield, type: "application/pdf" });
            EntrantFileObject.save();
            SortantFileObject.save();

            // Grant access to the user, tenants, and owners for the generated PDF
            await FileAccessSchema.create({ userId: userId, fileId: EntrantFileObject._id, accessType: ['read', 'write', 'delete', 'update'], }); await FileAccessSchema.create({ userId: userId, fileId: SortantFileObject._id, accessType: ['read', 'write', 'delete', 'update'], });


            await Promise.all([...createdOwners.map(owner => FileAccessSchema.create({ userId: owner._id, fileId: EntrantFileObject._id, accessType: ['read',] })), ...createdEntrantenants.map(owner => FileAccessSchema.create({ userId: owner._id, fileId: EntrantFileObject._id, accessType: ['read',] })), ...createdExitenants.map(tenant => FileAccessSchema.create({ userId: tenant._id, fileId: SortantFileObject._id, accessType: ['read',] }))]);

            await ProcurationSchema.findByIdAndUpdate(procuration._id, {
                entranDocumentId: EntrantFileObject._id,
                sortantDocumentId: SortantFileObject._id,
            });

            let result = {
                status: true,
                message: "Procuration crée avec succès",
                data: {
                    ...procuration.toObject(),
                    entranDocumentId: EntrantFileObject._id,
                    sortantDocumentId: SortantFileObject._id,
                }
            }
            ___senProcurationEmails(procuration._id);
            return res.status(201).json(result);

        } catch (error) {
            console.error('PDF generation failed:', error);
            return res.status(500).json({
                status: false,
                message: "Procuration created but PDF generation failed",
                data: procuration
            });
        }



    },
    griffeprocurarion: async (req, res) => {
        // Logic for editing user details
        const userId = req.user._id;

        const { signature, procurationId } = req.body;


        let { meta, entranDocumentId, sortantDocumentId } = await ProcurationSchema.findById(procurationId).lean();
        const fullProcuration = await ProcurationSchema.findById(procurationId)
            .populate('owners')
            .populate('exitenants')
            .populate('entrantenants')
            .populate('propertyDetails')
            .populate({
                path: 'owners',
                populate: {
                    path: 'representant',
                    model: 'owners'
                }
            })
            .lean();


        const asOwner = fullProcuration.owners.find((mes) => mes.email == req.user.email)


        if (meta) {
            meta.signatures[asOwner._id] = {
                path: signature,
                date: new Date()
            }
        } else {
            meta = {
                signatures: {
                    [asOwner._id]: {
                        path: signature,
                        date: new Date()
                    }
                }
            }
        }
        await ProcurationSchema.findByIdAndUpdate(procurationId, {
            meta
        });
        const entranDocument = await FileModel.findOne({ _id: entranDocumentId })
        const sortantDocument = await FileModel.findOne({ _id: sortantDocumentId })
        let temp = await ProcurationSchema.findById(procurationId).lean();

        try {
            await generateProcurationPDF({ ...fullProcuration, meta: temp.meta }, entranDocument.location, sortantDocument.location, signature);

            return res.status(201).json({
                status: true,
                message: "Procuration signé avec succès",
                data: {
                    entranDocumentId,
                    sortantDocumentId,
                }
            });
        } catch (error) {
            console.error('PDF generation failed:', error);
            return res.status(500).json({
                status: false,
                message: "Procuration created but PDF generation failed",
                data: "procuration"
            });
        }



    },

}