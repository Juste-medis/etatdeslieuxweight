
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
const { checkUniqueKey, personFillers, generateShield, getEstablishedDate, isValidObjectId, getRoleName, authorname, getAuthorById } = require("../utils/utils");
const { sendTenantsMailProcuration, sendGriefeNotification, sendOkToMantaire } = require("../services/sendmail");
const reviewController = require("./reviewController");
const fs = require('fs');
const TenantSchema = require("../models/tenantModel");
const { tenantShema } = require("../utils/shemas");
const userNotificationModel = require("../models/userNotificationModel");
const notificationModel = require("../models/notificationModel");
const firebaseAdmin = require('../config/firebaseinit');
const { sendandGetResponse } = require("./notificationController");
const trashModel = require("../models/trashModel");
const headerhtml = fs.readFileSync('./uploads/header.html', 'utf8');


const getfullProcuration = async (procuration) => {

    const fullReview = await ProcurationSchema.findById(procuration._id)
        .populate('propertyDetails')
        .populate({ path: 'accesgivenTo', populate: { path: 'representant', model: 'tenants' } })
        .populate({ path: 'owners', populate: { path: 'representant', model: 'owners' } })
        .populate({ path: 'exitenants', populate: { path: 'representant', model: 'tenants' } })
        .populate({ path: 'entrantenants', populate: { path: 'representant', model: 'tenants' } })
        .lean()

    if (!fullReview) {
        return null;
    }
    fullReview.author = await userModel.findById(fullReview.author)

    // Vérifier les signatures
    return {
        ...fullReview,
    };


}
const generateProcurationPDF = async (procurationData, entrantPdfPath, sortantPdfPath) => {
    try {
        const browser = await puppeteer.launch({
            headless: true,
            args: ['--no-sandbox', '--disable-setuid-sandbox']
        });
        const page = await browser.newPage();

        // Generate the HTML content
        const htmlContent = generateEntrantProcurationHTML(procurationData, "entrant");
        const htmlContentso = generateEntrantProcurationHTML(procurationData, "exitant");
        //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
        fs.writeFileSync(`./uploads/preview.html`, `${htmlContent}`, 'utf-8');
        //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

        await page.setContent(htmlContent, {
            waitUntil: 'networkidle0'
        });

        await page.pdf({
            path: entrantPdfPath,
            format: 'A4',
            margin: {
                top: '20px',
                right: '20px',
                bottom: '20px',
                left: '20px'
            },
            printBackground: true,
            waitForFonts: true,
            headerTemplate: headerhtml,
            displayHeaderFooter: true,

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
            printBackground: true,
            waitForFonts: true,
            headerTemplate: headerhtml,
            displayHeaderFooter: true,


        });

        await browser.close();
        return { entrant_pdfPath: entrantPdfPath, sortant_pdfPath: sortantPdfPath };
    } catch (error) {
        throw error;
    }
};

const senProcurationEmails = async (reviewId) => {
    const fullprocuration = await getfullProcuration({ _id: reviewId });
    const emailRoles = new Map();
    const tenantemailRoles = new Map();

    // Add owners and their representatives
    fullprocuration.owners.forEach(owner => {
        emailRoles.set(owner.email, { ...owner, role: 'owner', });
        if (owner.representant) {
            emailRoles.set(owner.representant.email, { ...owner, role: 'owner_representative', });
        }
    });

    // Add exit tenants and their representatives
    fullprocuration.exitenants.forEach(tenant => {
        tenantemailRoles.set(tenant.email, { ...tenant, role: 'exit_tenant', });
        if (tenant.type == "morale") { tenantemailRoles.set(tenant.representant.email, { ...tenant, role: 'exit_tenant_representative', }); }
    });
    // Add entrance tenants and their representatives
    fullprocuration.entrantenants.forEach(tenant => {
        tenantemailRoles.set(tenant.email, { ...tenant, role: 'entrance_tenant', });
        if (tenant.type == "morale") {
            tenantemailRoles.set(tenant.representant.email, { ...tenant, role: 'entrance_tenant_representative', });
        }
    });


    const ___senProcurationNotifications = async (
        fullprocuration,
        userMap
    ) => {
        const notificationPromises = Array.from(userMap.entries()).map(async ([email, user]) => {
            const title = "Nouvelle Procuration Créée";
            const body = `Bonjour ${authorname(user)}, une nouvelle procuration a été créée pour le bien situé à ${fullprocuration.propertyDetails.address}. Veuillez vérifier vos emails pour plus de détails.`;
            const data = {
                toUser: email,
                "type": "procuration_created",
                "procurationId": fullprocuration._id.toString(),
                timestamp: new Date().toISOString(),
            }
            let response = await sendandGetResponse(email, title, body, data);
            await new notificationModel({
                title,
                message: body,
                recipient_user: user._id,
                recipient: email,
                is_read: false,
                push_response: response,
                data
            }).save();
            return;

        });
        await Promise.all(notificationPromises);
        return;
    }

    ___senProcurationNotifications(fullprocuration, new Map([...emailRoles, ...tenantemailRoles]));

    const emailPromises = Array.from(tenantemailRoles.entries()).map(([email, tenant]) => {

        return sendTenantsMailProcuration(email, fullprocuration,
            {
                role: tenant.role || tenant,
                roleName: getRoleName(tenant.role || tenant),
                name: authorname(tenant),
                userdirection: tenant.role.includes("entrance") ? "entrée" : "sortie",
            }
        )
    });


    await Promise.all(emailPromises);

}


const ___sengrieffeEmails = async (reviewId, tenantSignatures) => {

    const ___senProcurationGriffeNotification = async (
        fullprocuration
    ) => {
        const title = "Signature de la Procuration";
        const body = `Bonjour ${authorname(fullprocuration.author)}, une signature a été ajoutée à la procuration pour le bien situé à ${fullprocuration.propertyDetails.address}. Veuillez vérifier vos emails pour plus de détails.`;
        const data = {
            toUser: fullprocuration.author.email,
            "type": "procuration_signed",
            "procurationId": fullprocuration._id.toString(),
            timestamp: new Date().toISOString(),
        }
        let response = await sendandGetResponse(fullprocuration.author.email, title, body, data);
        await new notificationModel({
            title,
            message: body,
            recipient_user: fullprocuration.author._id,
            recipient: fullprocuration.author.email,
            is_read: false,
            push_response: response,
            data
        }).save();
        return;

    }
    const fullprocuration = await getfullProcuration({ _id: reviewId });

    const tenantsPromises = Object.keys(tenantSignatures).map(owner => {
        return getAuthorById(owner);
    });
    const SignersUsers = await Promise.all(tenantsPromises);
    let restToSign = []
    let allSignedUsers = []
    let JoinNowSignerNames = [];
    SignersUsers.map(tenant => {
        if (!tenant) return;
        JoinNowSignerNames.push(tenant.name);
        return tenant.name;
    }).join(", ");


    if (fullprocuration
        .meta?.["signaturesMeta"]?.["missingSignatures"]
    ) {
        await Promise.all(fullprocuration
            .meta?.["signaturesMeta"]?.["missingSignatures"].map(async (tenant) => {
                let user = await getAuthorById(tenant);
                if (!user) return;
                restToSign.push(user.name);
                return user.name;
            }));
    }

    if (fullprocuration.meta?.["signatures"]) {
        await Promise.all(Object.keys(fullprocuration.meta?.["signatures"]).map(async (tenant) => {
            let user = await getAuthorById(tenant);
            if (!user) return;
            allSignedUsers.push(user.name);
            return user.name;
        }));
    }


    for (const tenant of SignersUsers) {
        if (!tenant) continue;
    }



    sendGriefeNotification(fullprocuration.author.email, fullprocuration,
        {
            JoinNowSignerNames,
            restToSign,
            allSignedUsers,
            authorName: authorname(fullprocuration.author),
            allSigned: fullprocuration.meta?.["signaturesMeta"]?.["allSigned"] || false,
        }
    )
    ___senProcurationGriffeNotification(fullprocuration);



}

const ___sengrieffeEmailsToMandataire = async (reviewId, concernedReview) => {
    const fullprocuration = await getfullProcuration({ _id: reviewId });

    const mandataire = fullprocuration.accesgivenTo[0];

    sendOkToMantaire(mandataire.email, fullprocuration,
        {
            mandataireName: authorname(mandataire),
        }
    )
    const notyfyMandataire = async (
        fullprocuration
    ) => {
        const title = "Etat des lieux débloqué";
        const body = `Bonjour ${authorname(fullprocuration.accesgivenTo[0])}, la procuration pour le bien situé à ${fullprocuration.propertyDetails.address} est maintenant complète et vous pouvez procéder à l'état des lieux.`;
        const data = {
            toUser: fullprocuration.author.email,
            "type": "review_ready",
            "reviewId": concernedReview._id.toString(),
            timestamp: new Date().toISOString(),
        }
        let response = await sendandGetResponse(fullprocuration.accesgivenTo[0].email, title, body, data);
        await new notificationModel({
            title,
            message: body,
            recipient_user: fullprocuration.accesgivenTo[0]._id,
            recipient: fullprocuration.accesgivenTo[0].email,
            is_read: false,
            push_response: response,
            data
        }).save();
        return;

    }
    notyfyMandataire(fullprocuration);
}

// ___sengrieffeEmailsToMandataire("68ec5f63d7e85c91d4f82e38", { _id: '68ec5f63d7e85c91d4f82e3f' })
// (async function sendCompleteReviewNotification() {
//     ___sengrieffeEmails(
//         (await ProcurationSchema.findOne().sort({ createdAt: -1 }).limit(1))._id, {}
//     )
// })();

// (async function sendCompleteReviewNotification() {
//     ___sengrieffeEmailsToMandataire(
//         (await ProcurationSchema.findOne().sort({ createdAt: -1 }).limit(1))._id, {}
//     )
// })();

// (async function sendCompleteReviewNotification() {
//     reviewController.previewage(
//         (await ProcurationSchema.findOne().sort({ createdAt: -1 }).limit(1))._id, {}
//     )
// })();


module.exports = {
    previewage: async (req, res) => {
        // Logic for editing user details
        const userId = req.user._id;
        const userEmail = req.user.email;

        const isAdmin = req.casper === true;

        const proccurationId = req.params.proccurationId;

        if (!isValidObjectId(proccurationId)) { return res.status(400).json({ status: false, message: "Invalid review ID" }); }
        const theproc = await getfullProcuration({ _id: proccurationId });
        if (!theproc) { throw "Pprocuration introuvable ou supprimée" }
        if (!isAdmin && await reviewController.getUserPositionInreview(theproc, userEmail, req.user._id) === null) { throw "Vous n'êtes pas autorisé à voir cette procuration" }
        let result = { status: true, data: {} }
        try {
            let { meta, entranDocumentId, sortantDocumentId } = theproc

            if (theproc.status === "completed") {
                result.data = { entrant_pdfPath: entranDocumentId, sortant_pdfPath: sortantDocumentId }
            } else {
                const entranDocument = await FileModel.findOne({ _id: entranDocumentId })
                const sortantDocument = await FileModel.findOne({ _id: sortantDocumentId })

                await generateProcurationPDF(theproc, entranDocument?.location, sortantDocument?.location);
                result.data = {
                    entrant_pdfPath: entranDocument._id,
                    sortant_pdfPath: sortantDocument._id,
                }

            }



        } catch (error) {
            console.log('PDF generation failed:', error);
        }



        return res.status(201).json(result);
    },
    createprocuration: async (req, res) => {
        const userId = req.user._id;

        const { owners, exitenants, entrantenants, propertyDetails, documentDetails, complementaryDetails, documentDetails: { address, review_type, review_estimed_date } } = req.body;

        // throw new Error("This endpoint is deprecated, please use the new one");
        try {
            checkUniqueKey([...owners, exitenants, entrantenants], "email", "Les emails des acteurs doivent être uniques");
        } catch (err) {
            throw err.message;
        }

        const ownerPromises = owners.map(owner => personFillers(owner, OwnerSchema));
        const exitenantPromises = exitenants.map(tenant => personFillers(tenant, TenantSchema));
        const entrantenantPromises = entrantenants.map(tenant => personFillers(tenant, TenantSchema));


        const createdOwners = await Promise.all(ownerPromises);
        const createdExitenants = await Promise.all(exitenantPromises);
        const createdEntrantenants = await Promise.all(entrantenantPromises);


        //-----------------creation du mandateire--------------------------


        let frontmandataire = [...exitenants, ...entrantenants].find((tenant) => tenant._id === documentDetails.accesgivenTo);
        let backmandataire = [...createdExitenants, ...createdEntrantenants].find((tenant) => tenant.email === frontmandataire.email);

        //===================================================================

        const createdProperty = await PropertySchema.create({
            address: propertyDetails.address,
            complement: propertyDetails.complement ?? "",
            floor: propertyDetails.floor ?? 0,
            surface: propertyDetails.surface ?? 0,
            roomCount: propertyDetails.roomCount ?? 1,
            furnitured: propertyDetails.furnitured ?? false,
            box: propertyDetails.box,
            cellar: propertyDetails.cellar,
            garage: propertyDetails.garage,
            parking: propertyDetails.parking,
            heatingType: propertyDetails.heatingType,
            heatingMode: propertyDetails.heatingMode,
            hotWaterType: propertyDetails.hotWaterType,
            hotWaterMode: propertyDetails.hotWaterMode,
        });

        let procuration = await ProcurationSchema.create({
            dateOfProcuration: documentDetails.dateOfProcuration || new Date(),
            author: userId,
            owners: createdOwners.map(owner => owner._id),
            exitenants: createdExitenants.map(tenant => tenant._id),
            entrantenants: createdEntrantenants.map(tenant => tenant._id),
            propertyDetails: createdProperty._id,
            document_address: complementaryDetails.doccument_city ?? address,
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
            document_address: complementaryDetails.doccument_city ?? address,
            review_type: "exit",
            meta: {
                signatures: {},
                "fillingPercentage": 42.85,
                ...complementaryDetails,
                status: "draft",
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
            document_address: complementaryDetails.doccument_city ?? address,
            review_type: "entrance",
            meta: {
                signatures: {},
                "fillingPercentage": 42.85,
                ...complementaryDetails,
                status: "draft",
            },
            pieces: [],
            clesDePorte: [],
            compteurs: [],
        });

        const createFileForReview = async (review, review_type = "exit", documentId = "sortantDocumentId") => {
            const shield = generateShield(), pdfFileName = `review_${shield}.pdf`;
            let pdfPath = `./public/documents/${review_type}_${pdfFileName}`;

            try {
                const SortantFileObject = new FileModel({ name: `${review_type}_${pdfFileName}`, author: userId, location: pdfPath, shield, type: "application/pdf" });
                SortantFileObject.save();
                await FileAccessSchema.create({ userId: userId, fileId: SortantFileObject._id, accessType: ['read', 'write', 'delete', 'update'], email: req.user.email });
                await Promise.all([...[...createdExitenants, ...createdEntrantenants, ...createdOwners].map(tenant => FileAccessSchema.create({ userId: tenant._id, fileId: SortantFileObject._id, accessType: ['read', 'update'], email: tenant.email }))]);
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
        createFileForReview(sortantreview, "exit", "sortantDocumentId");





        // Populate the procuration data for PDF generation
        const fullProcuration = await getfullProcuration(procuration)


        // Generate PDF
        const shield = randomstring.generate({ length: 120, charset: 'alphanumeric', capitalization: 'lowercase', });
        const pdfFileName = `procuration_${shield}.pdf`;
        const entrantPdfPath = `./public/documents/entrance_${pdfFileName}`, sortantPdfPath = `./public/documents/sortant_${pdfFileName}`;

        try {
            const EntrantFileObject = new FileModel({ name: `entrance_${pdfFileName}`, author: userId, location: entrantPdfPath, shield, type: "application/pdf" }), SortantFileObject = new FileModel({ name: `sortant_${pdfFileName}`, author: userId, location: sortantPdfPath, shield, type: "application/pdf" });
            EntrantFileObject.save();
            SortantFileObject.save();
            await generateProcurationPDF(fullProcuration, entrantPdfPath, sortantPdfPath);



            // Grant access to the user, tenants, and owners for the generated PDF
            await FileAccessSchema.create({ userId, fileId: EntrantFileObject._id, accessType: ['read', 'write', 'delete', 'update'], });
            await FileAccessSchema.create({ userId, fileId: SortantFileObject._id, accessType: ['read', 'write', 'delete', 'update'], });


            await Promise.all([
                ...(createdEntrantenants.concat(createdOwners)).map(owner => FileAccessSchema.create({ userId: owner._id, fileId: EntrantFileObject._id, email: owner.email, accessType: ['read',], email: owner.email })),
                ...(createdExitenants.concat(createdOwners)).map(tenant => FileAccessSchema.create({ userId: tenant._id, fileId: SortantFileObject._id, email: tenant.email, accessType: ['read',], email: tenant.email })),]
            );

            let meta = fullProcuration.meta || {};
            const establishedDate = getEstablishedDate(meta);
            let checkingAllSignatures = reviewController.checkAllSignatures(fullProcuration, meta);

            meta.signaturesMeta = { ...(meta.signaturesMeta || {}), ...checkingAllSignatures, establishedDate: establishedDate, }

            await ProcurationSchema.findByIdAndUpdate(procuration._id, {
                entranDocumentId: EntrantFileObject._id,
                sortantDocumentId: SortantFileObject._id,
                status: "draft",
                meta
            });

            let result = {
                status: true,
                message: "Procuration crée avec succès",
                data: {
                    ...fullProcuration,

                    entranDocumentId: EntrantFileObject._id,
                    sortantDocumentId: SortantFileObject._id,
                }
            }
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
    updaterproccuration: async (req, res) => {
        // Logic for editing user details
        const userId = req.user._id;
        const userEmail = req.user.email;
        const proccurationId = req.params.proccurationId;
        const isAdmin = req.casper

        if (!isValidObjectId(proccurationId)) { return res.status(400).json({ status: false, message: "Id de procuration invalide" }); }
        const tproccuration = await ProcurationSchema.findById(proccurationId)
        if (!tproccuration) { return res.status(404).json({ status: false, message: "proccuration introuvable ou supprimée" }); }
        if (!isAdmin && await reviewController.getUserPositionInreview(tproccuration, userEmail, userId) === null) { return res.status(403).json({ status: false, message: "Vous n'êtes pas autorisé à modifier cette procuration" }); }
        if (!isAdmin && (tproccuration.author.toString() !== userId.toString())) {
            return res.status(403).json({ status: false, message: "Vous n'êtes pas autorisé à modifier cette procuration" });
        }


        const {
            owners,
            exitenants,
            entrantenants,
            documentDetails,
            propertyDetails,
            complementaryDetails,
            author,
            isMandated,
            section,
            mandataire,
            canModifyMandataire
        } = req.body;
        if (section !== "sendToAutors" &&
            (tproccuration.status === "completed" || tproccuration.status === "signing")) {
            return res.status(403).json({ status: false, message: "Vous ne pouvez pas modifier une procuration déjà signée ou complétée" });
        }

        let createdProperty, createdpush, createdpull;
        if (author) {
            if (isValidObjectId(author?._id)) {
                if (section == "deleteauthor") {
                    let okowners = (tproccuration.owners.filter(owner => owner.toString() !== author?._id.toString())).length > 0;
                    if (!okowners) {
                        return res.status(403).json({ status: false, message: "Vous devriez avoir au moins un propriétaire" });
                    }
                    let okexitenants = (tproccuration.exitenants.filter(tenant => tenant.toString() !== author?._id.toString())).length > 0;
                    if (!okexitenants) {
                        return res.status(403).json({ status: false, message: "Vous devriez avoir au moins un locataire sortant" });
                    }
                    let okentrantenants = (tproccuration.entrantenants.filter(tenant => tenant.toString() !== author?._id.toString())).length > 0;
                    if (!okentrantenants) {
                        return res.status(403).json({ status: false, message: "Vous devriez avoir au moins un locataire entrant" });
                    }
                    createdpull = {
                        owners: author?._id,
                        exitenants: author?._id,
                        entrantenants: author?._id
                    }
                } else {
                    await reviewController.updateAuthor(req, res, userId);
                }
            } else {
                delete author._id; // Remove _id if it exists to avoid conflicts
                var newlyuser
                const AuthorSchema = (section === "addsortantlocataire" || section === "addentrantlocataire") ? TenantSchema : OwnerSchema;
                try { tenantShema.parse(author); } catch (e) { throw e; }

                if (author.type === "morale" && !author.representant) {
                    throw new Error("Le type morale doit avoir un représentant");
                }
                if (author.type === "morale" && author.representant) {
                    delete author.representant._id;
                    try { tenantShema.parse(author.representant); } catch (e) { throw e; }
                    const representant = await AuthorSchema.create({ ...author.representant, type: "physique" });
                    newlyuser = await AuthorSchema.create({ ...author, representant: representant._id });
                } else {
                    delete author.representant;
                    newlyuser = await AuthorSchema.create(author);
                }


                if (section === "addsortantlocataire" || section === "addentrantlocataire") {
                    createdpush = {
                        [section === "addsortantlocataire" ? "exitenants" : "entrantenants"]: newlyuser._id
                    }
                } else if (section === "addowner") {
                    createdpush = {
                        "owners": newlyuser._id
                    }
                }

            }
        }

        if (canModifyMandataire) {
            if (isMandated && mandataire) {

                if (tproccuration.mandataire) {
                    await reviewController.updateAuthor(req, res, userId, 'mandataire');
                } else {
                    delete mandataire._id;

                    validateAutor(mandataire);
                    if (mandataire.type === "morale" && !mandataire.representant) { throw new Error("Le type morale doit avoir un représentant"); }
                    if (mandataire.type === "morale" && mandataire.representant) {
                        delete mandataire.representant._id;
                        const representant = await TenantSchema.create({ ...mandataire.representant, type: "physique" });
                        createdpullmandataire = await TenantSchema.create({ ...mandataire, representant: representant._id });
                    } else {
                        delete mandataire.representant;
                        createdpullmandataire = await TenantSchema.create(mandataire);
                    }

                }
            } else {
                if (!isMandated && tproccuration.mandataire) {
                    await TenantSchema.findByIdAndDelete(tproccuration.mandataire);
                }
            }
        }
        try {
            if (owners)
                checkUniqueKey(owners, "representantemail", "Les emails des mandants doivent être uniques");
            if (exitenants) checkUniqueKey(exitenants, "representantemail", "Les emails des locataires sortant doivent être uniques");
            if (entrantenants) checkUniqueKey(entrantenants, "representantemail", "Les emails des locataires entrant doivent être uniques");
        } catch (err) {
            throw err.message;
        }



        if (propertyDetails || complementaryDetails) {

            if (propertyDetails?._id) {
                const updateFields = {};
                if (propertyDetails.address !== null) updateFields.address = propertyDetails.address;
                if (propertyDetails.complement !== null) updateFields.complement = propertyDetails.complement;
                if (propertyDetails.floor !== null) updateFields.floor = propertyDetails.floor;
                if (propertyDetails.surface !== null) updateFields.surface = propertyDetails.surface;
                if (propertyDetails.roomCount !== null) updateFields.roomCount = propertyDetails.roomCount;
                if (propertyDetails.furnitured !== null) updateFields.furnitured = propertyDetails.furnitured;
                if (propertyDetails.box !== null) updateFields.box = propertyDetails.box;
                if (propertyDetails.cellar !== null) updateFields.cellar = propertyDetails.cellar;
                if (propertyDetails.garage !== null) updateFields.garage = propertyDetails.garage;
                if (propertyDetails.parking !== null) updateFields.parking = propertyDetails.parking;

                if (propertyDetails.heatingType !== null) updateFields.heatingType = propertyDetails.heatingType;
                if (propertyDetails.heatingMode !== null) updateFields.heatingMode = propertyDetails
                    .heatingMode;
                if (propertyDetails.hotWaterType !== null) updateFields.hotWaterType = propertyDetails
                    .hotWaterType;
                if (propertyDetails.hotWaterMode !== null) updateFields.hotWaterMode = propertyDetails
                    .hotWaterMode;

                createdProperty = await PropertySchema.findByIdAndUpdate(propertyDetails._id, updateFields);
            }
        }


        let thereview = await ProcurationSchema.findById(proccurationId)

        let proccuration = await ProcurationSchema.findByIdAndUpdate(proccurationId, {
            ...(propertyDetails ? { propertyDetails: createdProperty._id } : {}),
            ...(createdpush ? { $push: createdpush } : {}),
            ...(createdpull ? { $pull: createdpull } : {}),
            estimatedDateOfReview: documentDetails?.review_estimed_date || thereview.estimatedDateOfReview,
            document_address: documentDetails?.doccument_city || thereview.document_address,
            accesgivenTo: documentDetails?.accesgivenTo || thereview.accesgivenTo,
            // mandataire: isMandated ? (createdpullmandataire ? createdpullmandataire._id : thereview.mandataire) : null,
            meta: {
                ...thereview.meta,
                ...(complementaryDetails ? { ...complementaryDetails } : {}),
            }
        },
            { new: true })
            .populate('author')
            .populate('propertyDetails')
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



        let fillingPercentage = 0;
        const steps = [
            ((proccuration.propertyDetails?.surface != "" && proccuration.propertyDetails?.address != "") ? 2 : 1),
            ((proccuration.meta?.heatingType != null && proccuration.meta?.heatingMode != null) ? 2 : 1),
            (proccuration.pieces?.length > 0 ? 2 : 0),
            (proccuration.compteurs?.length > 0 ? 2 : 0),
            (proccuration.cledeportes?.length > 0 ? 2 : 0),
            ((proccuration.exitenants?.length > 0 &&
                ((!proccuration.procuration && proccuration.exitenants?.length > 0) ||
                    (proccuration.procuration && proccuration.entrantenants?.length > 0)) &&
                proccuration.owners?.length > 0) ? 2 : 0),
            ((proccuration.meta?.tenant_new_address != null &&
                (proccuration.review_type == "exit" && proccuration.meta?.tenant_new_address != "") || proccuration.review_type != "exit"
                && proccuration.meta?.tenant_new_address != "") ? 2 : 1)
        ];

        fillingPercentage = Math.round((steps.reduce((a, b) => a + b, 0) / (steps.length * 2)) * 100);


        await ProcurationSchema.findByIdAndUpdate(proccurationId, {
            meta: {
                ...proccuration.meta,
                signaturesMeta: {
                    ...(proccuration?.meta?.signaturesMeta || {}),
                    ...reviewController.checkAllSignatures(proccuration),
                },
                fillingPercentage
            }
        });
        proccuration.meta.fillingPercentage = fillingPercentage;

        let result = {
            status: true,
            message: "Procuration mise à jour avec succès",
            data: {
                ...proccuration.toObject(),
            }
        }
        try {
            // generatePdfOfReview(review);
        } catch (error) {

        }
        return res.status(201).json(result);

    },
    deleteprocurarion: async (req, res) => {
        const userId = req.user._id;
        const userEmail = req.user.email;
        const proccurationId = req.params.proccurationId;

        if (!isValidObjectId(proccurationId)) { return res.status(400).json({ status: false, message: "Id de procuration invalide" }); }
        const tproccuration = await ProcurationSchema.findById(proccurationId)
        if (!tproccuration) { return res.status(404).json({ status: false, message: "Procuration non trouvée" }); }
        if (tproccuration.author.toString() !== userId.toString()) {
            return res.status(403).json({ status: false, message: "Vous n'êtes pas autorisé à supprimer cette procuration" });
        }
        await trashModel.create({
            originalId: tproccuration._id,
            collectionName: 'procurations',
            deletedBy: userId,
            deletedAt: new Date(),
            data: tproccuration.toObject(),
        });

        await ProcurationSchema.findByIdAndDelete(proccurationId);
        return res.status(200).json({ status: true, message: "Procuration supprimée avec succès" });
    }
    ,
    griffeprocurarion: async (req, res) => {
        // Logic for editing user details
        const userId = req.user._id;
        const userEmail = req.user.email;

        const { tenantSignatures, procurationId } = req.body;

        let { meta, entranDocumentId, sortantDocumentId } = await ProcurationSchema.findById(procurationId).lean();
        let fullProcuration = await getfullProcuration({ _id: procurationId });
        if (!fullProcuration) { return res.status(404).json({ status: false, message: "Procuration not found" }); }

        const userPosition = await reviewController.getUserPositionInreview(fullProcuration, userEmail, userId);
        if (!userPosition) { return res.status(403).json({ status: false, message: "Vous n'êtes pas autorisé à signer cet état des lieux" }); }

        if (!fullProcuration.credited) {
            return res.status(400).json({ status: false, message: "L'état des lieux doit être reglé avant de pouvoir être signé" });
        }
        let createdTenantSignatures = {}
        if (tenantSignatures && Object.keys(tenantSignatures).length > 0) {
            // Validate tenant signatures
            for (const [tenantId, signature] of Object.entries(tenantSignatures)) {
                if (!isValidObjectId(tenantId)) { return res.status(400).json({ status: false, message: `Invalid tenant ID: ${tenantId}` }); }
                const tenantPosition = await reviewController.getUserPositionInreview(fullProcuration, null, tenantId);
                if (!tenantPosition) { return res.status(404).json({ status: false, message: `Tenant with ID ${tenantId} not found in the review` }); }
                if (!signature) { return res.status(400).json({ status: false, message: `Signature path is required for tenant with ID ${tenantId}` }); }

                createdTenantSignatures[tenantId] = {
                    path: signature,
                    timestamp: new Date(),
                    position: tenantPosition
                };
            }
        }
        meta.signatures = {
            ...(meta.signatures || {}),
            ...createdTenantSignatures
        };
        const establishedDate = getEstablishedDate(meta);
        let checkingAllSignatures = reviewController.checkAllSignatures(fullProcuration, meta);
        meta.signaturesMeta = {
            ...(meta.signaturesMeta || {}),
            ...checkingAllSignatures,
            establishedDate: establishedDate,
        }
        await ProcurationSchema.findByIdAndUpdate(procurationId, { status: checkingAllSignatures.allSigned ? "completed" : "signing", meta }, { new: true });

        ___sengrieffeEmails(procurationId, createdTenantSignatures);

        //débloquer l'accès au mandataire si tous les signataires ont signé
        if (checkingAllSignatures.allSigned) {
            const backmandataire = fullProcuration.accesgivenTo[0];
            const bacbackmandatairePosition = await reviewController.getUserPositionInreview(fullProcuration, backmandataire.email);
            const concernedReview = await ReviewSchema.findOne(
                {
                    procuration: procurationId,
                    review_type: bacbackmandatairePosition == "entrantenant" ? "entrance" : "exit"
                });

            const RecAccess = new ReviewAccessModel({
                user: `${backmandataire.email}`,
                procuration: procurationId,
                review: concernedReview._id,
                expiryDate: new Date(new Date().getTime() + 24 * 60 * 60 * 1000 * 30),
            });

            RecAccess.save();

            await FileAccessSchema.create({ userId: backmandataire._id, fileId: entranDocumentId, accessType: ['read'], email: backmandataire.email });
            await FileAccessSchema.create({ userId: backmandataire._id, fileId: sortantDocumentId, accessType: ['read'], email: backmandataire.email });

            ___sengrieffeEmailsToMandataire(procurationId, concernedReview);





        }



        fullProcuration = await getfullProcuration({ _id: procurationId });


        const entranDocument = await FileModel.findOne({ _id: entranDocumentId })
        const sortantDocument = await FileModel.findOne({ _id: sortantDocumentId })

        try {
            await generateProcurationPDF(fullProcuration, entranDocument.location, sortantDocument.location);

            return res.status(201).json({
                status: true,
                message: "Procuration signé avec succès",
                data: {
                    entranDocumentId,
                    sortantDocumentId,
                    meta
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
    getProccurations: async (req, res) => {
        const userId = req.user._id;
        const isAdmin = req.casper === true;

        const userEmail = req.user.email;
        const { filter } = req.query;

        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 10;
        const skip = (page - 1) * limit;
        let filtering = { status: "mine" };

        try {

            if (filter) {
                filtering = JSON.parse(filter);
            };

            // Find all owners and tenants where userEmail is present
            const ownersWithUserEmail = await OwnerSchema.find({ email: userEmail }).distinct('_id');
            const tenantsWithUserEmail = await TenantSchema.find({ email: userEmail }).distinct('_id');


            if (!filtering.status) { filtering.status = "mine" }
            const baseMatch = isAdmin ? {} : {
                $or: [
                    ...(["mine", "all"].includes(filtering.status) ? [{ author: userId, }] : []),
                    ...(["guess", "all"].includes(filtering.status) ? [{ owners: { $in: ownersWithUserEmail }, author: { $ne: userId }, credited: true }] : []),
                    ...(["guess", "all"].includes(filtering.status) ? [{ exitenants: { $in: tenantsWithUserEmail }, author: { $ne: userId }, credited: true }] : []),
                    ...(["guess", "all"].includes(filtering.status) ? [{ entrantenants: { $in: tenantsWithUserEmail }, author: { $ne: userId }, credited: true }] : []),
                ],
            };


            if (filtering.progress) {
                baseMatch.status = filtering.progress == "all" || !filtering.progress ? { $in: ["draft", "signing", "completed"] } :
                    filtering.progress;
                if (baseMatch.progress === undefined) delete baseMatch.progress;
            }

            if (filtering.status === "guess") {
                baseMatch['credited'] = true;
            }

            let postMatch = {};
            if (filtering.q) {
                postMatch.$or = [
                    { 'meta.tenant_new_address': { $regex: filtering.q, $options: 'i' } },
                    { 'meta.notes': { $regex: filtering.q, $options: 'i' } },
                    { 'propertyDetails.address': { $regex: filtering.q, $options: 'i' } },
                    { 'propertyDetails.complement': { $regex: filtering.q, $options: 'i' } },
                    { 'author.email': { $regex: filtering.q, $options: 'i' } },
                    { 'author.firstName': { $regex: filtering.q, $options: 'i' } },
                    { 'author.lastName': { $regex: filtering.q, $options: 'i' } },
                    { 'owners.representantemail': { $regex: filtering.q, $options: 'i' } },
                    { 'owners.firstname': { $regex: filtering.q, $options: 'i' } },
                    { 'owners.lastname': { $regex: filtering.q, $options: 'i' } },
                    { 'exitenants.representantemail': { $regex: filtering.q, $options: 'i' } },
                    { 'exitenants.firstname': { $regex: filtering.q, $options: 'i' } },
                    { 'exitenants.lastname': { $regex: filtering.q, $options: 'i' } },
                    { 'entrantenants.representantemail': { $regex: filtering.q, $options: 'i' } },
                    { 'entrantenants.firstname': { $regex: filtering.q, $options: 'i' } },
                    { 'entrantenants.lastname': { $regex: filtering.q, $options: 'i' } },
                ];
            }
            if (filtering.dateRange && filtering.dateRange.includes('-')) {
                const [startStr, endStr] = filtering.dateRange.split('-').map(s => s.trim());
                const [startDay, startMonth, startYear] = startStr.split('/').map(Number);
                const [endDay, endMonth, endYear] = endStr.split('/').map(Number);
                const startDate = new Date(startYear, startMonth - 1, startDay);
                const endDate = new Date(endYear, endMonth - 1, endDay, 23, 59, 59, 999);
                postMatch.createdAt = { $gte: startDate, $lte: endDate };
            }


            // console.log("baseMatch:", JSON.stringify(baseMatch, null, 2));
            // console.log("postMatch:", JSON.stringify(postMatch, null, 2));

            let globalProject = { 'procuration.author.password': 0, 'author.password': 0, 'author.dob': 0, 'procuration.author.balance': 0, 'author.balance': 0 };



            const [result] = await
                ProcurationSchema.aggregate([
                    { $match: baseMatch },
                    { $lookup: { from: 'properties', localField: 'propertyDetails', foreignField: '_id', as: 'propertyDetails' } },
                    { $lookup: { from: 'users', localField: 'author', foreignField: '_id', as: 'author' } },
                    { $lookup: { from: 'owners', localField: 'owners', foreignField: '_id', pipeline: [{ $lookup: { from: 'owners', localField: 'representant', foreignField: '_id', as: 'representant' } }, { $set: { representant: { $first: '$representant' } } },], as: 'owners' } },
                    { $lookup: { from: 'tenants', localField: 'mandataire', foreignField: '_id', pipeline: [{ $lookup: { from: 'tenants', localField: 'representant', foreignField: '_id', as: 'representant' } }, { $set: { representant: { $first: '$representant' } } },], as: 'mandataire' } },
                    { $lookup: { from: 'tenants', localField: 'exitenants', foreignField: '_id', pipeline: [{ $lookup: { from: 'tenants', localField: 'representant', foreignField: '_id', as: 'representant' }, }, { $set: { representant: { $first: '$representant' } } },], as: 'exitenants' } },
                    { $lookup: { from: 'tenants', localField: 'entrantenants', foreignField: '_id', pipeline: [{ $lookup: { from: 'tenants', localField: 'representant', foreignField: '_id', as: 'representant' } }, { $set: { representant: { $first: '$representant' } } }], as: 'entrantenants' } },
                    {
                        $set: {
                            propertyDetails: { $arrayElemAt: ['$propertyDetails', 0] },
                            author: { $arrayElemAt: ['$author', 0] },
                            mandataire: { $arrayElemAt: ['$mandataire', 0] },
                            "entrantenants.representant": { $arrayElemAt: ['$entrantenants.representant', 0] },
                            "exitenants.representant": { $arrayElemAt: ['$exitenants.representant', 0] },
                        }
                    },
                    ...(Object.keys(postMatch).length ? [{ $match: postMatch }] : []),
                    { $sort: { createdAt: -1 } },
                    { $project: globalProject },
                    { $facet: { data: [{ $skip: skip }, { $limit: limit }, { $project: globalProject }], meta: [{ $count: 'total' }] } },
                    {
                        $project: {
                            data: 1,
                            total: { $ifNull: [{ $arrayElemAt: ['$meta.total', 0] }, 0] }
                        }
                    }
                ]);

            const { data: reviews, total } = result;


            res.json({
                success: true,
                data: reviews,
                pagination: {
                    currentPage: page,
                    totalPages: Math.ceil(total / limit),
                    totalItems: total,
                    itemsPerPage: limit
                }
            });
        } catch (err) {
            console.log(err);

            res.status(500).json({
                success: false,
                error: 'Server Error',
                details: err.message
            });
        }
    },
    getProcurationById: async (req, res) => {
        //wait 10 sec 
        const userId = req.user._id;
        const userEmail = req.user.email;
        const isAdmin = req.casper === true;

        const proccurationId = req.params.proccurationId;
        if (!isValidObjectId(proccurationId)) { return res.status(400).json({ status: false, message: "Id de procuration invalide" }); }
        const proccuration = await getfullProcuration({ _id: proccurationId });
        if (!proccuration) { return res.status(404).json({ status: false, message: "proccuration Introuvable" }); }
        if (!isAdmin && await reviewController.getUserPositionInreview(proccuration, userEmail, userId) === null) { return res.status(403).json({ status: false, message: "Vous n'êtes pas autorisé à voir cette procuration" }); }

        return res.status(200).json({ status: true, data: proccuration });
    },

    getfullProcuration,
    senProcurationEmails

}