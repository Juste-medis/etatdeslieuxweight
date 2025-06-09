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
const ProcurationSchema = require("../models/procurationModel")
const ReviewAccessModel = require('../models/reviewAccessModel');

const fs = require('fs');
const puppeteer = require('puppeteer');
const { generateEntrantProcurationHTML } = require("../utils/pdfs/pdfkit");
const { checkUniqueKey, isValidObjectId, gettempfilePath, autoPopulateRecursively, getRoleName, getReviewExplicitName } = require("../utils/utils");
const TenantSchema = require("../models/tenantModel");
const { tenantShema } = require("../utils/shemas");
const { generateReviewHTML } = require("../utils/pdfs/reviewpdfkit");
const { exec } = require('child_process');
const { get } = require("http");
const { sendInviteMail } = require("../services/sendmail");
const config = require("../config/config");


// Fonction utilitaire pour vérifier les signatures
const checkAllSignatures = (fullReview, meta) => {
    // Récupérer toutes les adresses email qui ont signé
    const signedEmails = Object.keys(meta.signatures || {});

    // Créer un ensemble d'emails requis
    const requiredEmails = new Set();

    // Ajouter les emails des Bailleurs et leurs représentants
    fullReview.owners.forEach(owner => {
        requiredEmails.add(owner.email);
        if (owner.representant) {
            requiredEmails.add(owner.representant.email);
        }
    });

    // Ajouter les emails des locataires sortants et leurs représentants
    fullReview.exitenants.forEach(tenant => {
        requiredEmails.add(tenant.email);
        if (tenant.representant) {
            requiredEmails.add(tenant.representant.email);
        }
    });

    // Ajouter les emails des locataires entrants et leurs représentants
    fullReview.entrantenants.forEach(tenant => {
        requiredEmails.add(tenant.email);
        if (tenant.representant) {
            requiredEmails.add(tenant.representant.email);
        }
    });

    // Ajouter l'email du mandataire s'il existe
    if (fullReview.mandataire) {
        requiredEmails.add(fullReview.mandataire.email);
        if (fullReview.mandataire.representant) {
            requiredEmails.add(fullReview.mandataire.representant.email);
        }
    }

    // Vérifier si tous les emails requis ont signé
    const allSigned = Array.from(requiredEmails).every(email => signedEmails.includes(email));

    return {
        allSigned,
        totalRequired: requiredEmails.size,
        totalSigned: signedEmails.length,
        missingSignatures: Array.from(requiredEmails).filter(email => !signedEmails.includes(email))
    };
};
// Fonction utilitaire pour vérifier les signatures
const getfullReview = async (reviewId, query = {}) => {
    // Récupérer l'état des lieux complet
    const fullReview = await ReviewSchema.findOne({ _id: reviewId, ...query })
        .populate('propertyDetails')
        .populate('compteurs')
        .populate('cledeportes')
        .populate({
            path: 'mandataire',
            populate: {
                path: 'representant',
                model: 'owners'
            }
        })
        .populate({ path: 'procuration', populate: [{ path: 'author', model: 'user' }, { path: 'accesgivenTo', model: 'tenants' }] })

        .populate({
            path: 'pieces',
            populate: {
                path: 'things',
                model: 'things'
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
        signatures: checkAllSignatures(fullReview, fullReview.meta)
    };


}

const getUserPositionInreview = async (review, email, id) => {
    // Check owners
    const ownerMatch = review.owners?.find(owner =>
        (email && (owner.email === email || owner.representant?.email === email)) ||
        (id && (owner._id.toString() === id.toString() || owner.representant?._id.toString() === id.toString()))
    );
    if (ownerMatch) return 'owner';


    const exitTenantMatch = review.exitenants?.find(tenant =>
        (email && (tenant.email === email || tenant.representant?.email === email)) ||
        (id && (tenant._id.toString() === id.toString() || tenant.representant?._id.toString() === id.toString()))
    );
    if (exitTenantMatch) return 'exitenant';

    // Check entrance tenants
    const entranceTenantMatch = review.entrantenants?.find(tenant =>
        (email && (tenant.email === email || tenant.representant?.email === email)) ||
        (id && (tenant._id.toString() === id.toString() || tenant.representant?._id.toString() === id.toString()))
    );
    if (entranceTenantMatch) return 'entrantenant';

    // Check mandataire
    if (review.mandataire && (
        (email && (review.mandataire.email === email || review.mandataire.representant?.email === email)) ||
        (id && (review.mandataire._id.toString() === id.toString() || review.mandataire.representant?._id.toString() === id.toString()))
    )) {
        return 'mandataire';
    }


    // Check if the user is the author
    if (review.author?.toString() === id?.toString()) {
        return 'author';
    }

    return null;
}

const generatePdfOfReview = async (review, userId) => {
    // Populate the procuration data for PDF generation
    const fullReview = review;

    //======================================================================The reviewType
    const SortantFileObject = await FileModel.findById(review.sortantDocumentId);
    //======================================================================


    //======================================================================The second PDF for procuration
    let EntrantFileObject = review.procuration ? await FileModel.findById(review.entranDocumentId) : null;




    //======================================================================







    try {


        try {
            const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox', '--disable-setuid-sandbox'] });
            const page = await browser.newPage();

            let tempPaths = gettempfilePath();

            // Generate the HTML content
            const footerhtml = fs.readFileSync('./uploads/footer.html', 'utf8');
            const htmlContent = generateReviewHTML(fullReview, fullReview.review_type);

            //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
            fs.writeFileSync(`./uploads/preview.html`, `${htmlContent}`, 'utf-8');
            //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

            await page.setContent(htmlContent, { waitUntil: ['load', 'domcontentloaded', 'networkidle0'], });
            let tempPathe = gettempfilePath();
            await page.pdf({
                path: tempPathe,
                format: 'A4',
                margin: { top: '50px', right: '5px', bottom: '50px', left: '5px' },
                printBackground: true,
                preferCSSPageSize: false,
                scale: 1,
                displayHeaderFooter: true,
                headerTemplate: `<style> .footer { width: 100%; font-size: 10px; color: #666; text-align: center; padding: 5px; border-top: 1px solid #eee; } </style> <div class="footer"> Page <span class="pageNumber"></span> sur <span class="totalPages"></span> </div>`,
                footerTemplate: `${footerhtml}`,
            });

            if (ReviewData.procuration) {
                const htmlContentso = generateReviewHTML(ReviewData, ReviewData.review_type);
                // Génération du second PDF
                await page.setContent(htmlContentso, {
                    waitUntil: 'networkidle0'
                });
                await page.pdf({
                    path: tempPaths,
                    format: 'A4',
                    margin: {
                        top: '20px',
                        right: '5px',
                        bottom: '20px',
                        left: '5px'
                    },
                    printBackground: true,
                    preferCSSPageSize: true,
                    displayHeaderFooter: true,
                    headerTemplate: '<div>Mon En-tête</div>',
                    footerTemplate: '<div>Mon Bas de page</div>',

                });
            }

            await browser.close();
            let formfields = await new Promise(function (resolve, reject) {

                exec(`gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
          -dNOPAUSE -dQUIET -dBATCH -sOutputFile=${outputPath} ${tempPathe}`,
                    (err, stdout, stderr) => {
                        if (err) {
                            reject(`Erreur : ${err}`);
                            return;
                        }
                        if (ReviewData.procuration) {
                            exec(`gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
          -dNOPAUSE -dQUIET -dBATCH -sOutputFile=${sortantPdfPath} ${tempPaths}`,
                                (err, stdout, stderr) => {
                                    if (err) {
                                        reject(`Erreur : ${err}`);
                                        return;
                                    }
                                    // Delete temp files
                                    fs.unlinkSync(tempPathe);
                                    fs.unlinkSync(tempPaths);
                                    resolve({ outputPath, sortantPdfPath });
                                });
                        } else {
                            // Delete temp files
                            fs.unlinkSync(tempPathe);
                            resolve({ outputPath });
                        }

                    });
            })
            if (typeof formfields === "object") {
                return formfields;
            } else {
                throw formfields;
            }
        } catch (error) {
            throw error;
        }































        return {
            entranDocumentId: review.entranDocumentId,
            sortantDocumentId: review.sortantDocumentId,
        }
    } catch (error) {
        console.error('PDF generation failed:', error);

    }

};
const generateClassicPdfOfReview = async (review) => {
    // Populate the procuration data for PDF generation
    const fullReview = review;
    const TheFileObject = await FileModel.findById(review.review_type === "exit" ? review.sortantDocumentId : review.entranDocumentId);

    try {
        const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox', '--disable-setuid-sandbox'] });
        const page = await browser.newPage();

        let tempPaths = gettempfilePath();

        // Generate the HTML content
        const footerhtml = fs.readFileSync('./uploads/footer.html', 'utf8');
        const headerhtml = fs.readFileSync('./uploads/header.html', 'utf8');
        const htmlContent = generateReviewHTML(fullReview, fullReview.review_type);

        //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
        fs.writeFileSync(`./uploads/preview.html`, `${htmlContent}`, 'utf-8');
        //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

        await page.setContent(htmlContent, { waitUntil: ['load', 'domcontentloaded', 'networkidle0'], });
        await page.pdf({
            path: tempPaths,
            format: 'A4',
            margin: { top: '50px', right: '5px', bottom: '50px', left: '5px' },
            printBackground: true,
            preferCSSPageSize: false,
            scale: 1,
            displayHeaderFooter: true,
            headerTemplate: headerhtml,
            footerTemplate: `${footerhtml}`,
        });
        await browser.close();
        let formfields = await new Promise(function (resolve, reject) {
            exec(`gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook  -dNOPAUSE -dQUIET -dBATCH -sOutputFile=${TheFileObject.location} ${tempPaths}`,
                (err, stdout, stderr) => {
                    if (err) {
                        reject(`Erreur : ${err}`);
                        return;
                    }
                    fs.unlinkSync(tempPaths);
                    const lulu = getReviewExplicitName(fullReview.review_type);
                    resolve({ [`${lulu}_pdfPath`]: lulu == "sortant" ? review.sortantDocumentId : review.entranDocumentId });
                });
        })
        if (typeof formfields === "object") {
            return formfields;
        } else {
            throw formfields;
        }

    } catch (error) {
        console.error('Une erreur est survenue lors de la génération du document. Cliquez ici pour réessayer.', error);

    }

};

const ___senReviewEmails = async (reviewId) => {
    const fullReview = await getfullReview(reviewId);
    const emailRoles = new Map();

    // Add owners and their representatives
    fullReview.owners.forEach(owner => {
        emailRoles.set(owner.email, 'owner');
        if (owner.representant) {
            emailRoles.set(owner.representant.email, 'owner_representative');
        }
    });

    // Add exit tenants and their representatives
    fullReview.exitenants.forEach(tenant => {
        emailRoles.set(tenant.email, 'exit_tenant');
        if (tenant.representant) {
            emailRoles.set(tenant.representant.email, 'tenant_representative');
        }
    });

    if (fullReview.mandataire) {
        emailRoles.set(fullReview.mandataire.email, 'mandataire');
        if (fullReview.mandataire.representant) {
            emailRoles.set(fullReview.mandataire.representant.email, 'mandataire_representative');
        }
    }

    const emailPromises = Array.from(emailRoles.entries()).map(([email, role]) =>
        sendInviteMail(getRoleName(role), email, fullReview)
    );

    await Promise.all(emailPromises);
}


module.exports = {
    previewage: async (req, res) => {
        // Logic for editing user details
        const userId = req.user._id;
        const userEmail = req.user.email;

        const reviewId = req.params.reviewid;
        if (!isValidObjectId(reviewId)) { return res.status(400).json({ status: false, message: "Invalid review ID" }); }
        const treview = await getfullReview(reviewId)
        if (!treview) { throw "Review not found" }
        if (await getUserPositionInreview(treview, userEmail, req.user._id) === null) { throw "Vous n'êtes pas autorisé à modifier cet état des lieux"; }
        let result = { status: true, data: {} }
        try {
            result.data = treview.procuration ? await generatePdfOfReview(treview) : await generateClassicPdfOfReview(treview);
        } catch (error) {
            console.log('PDF generation failed:', error);
        }

        return res.status(201).json(result);
    },
    createreview: async (req, res) => {

        // Logic for editing user details 
        const userId = req.user._id;

        const { owners, exitenants, propertyDetails, documentDetails, complementaryDetails, documentDetails: { review_type }, mandataire, isMandated } = req.body;
        let emails = [];

        try {
            checkUniqueKey([...exitenants, ...owners], ["representantemail", "email"], "Les emails des auteurs doivent être uniques");
        } catch (err) {
            throw err.message;
        }

        if (isMandated && !mandataire) {
            return res.status(400).json({
                status: false,
                message: "Le mandataire est requis lorsque isMandated est vrai"
            });
        }

        let createMandataire = null;
        if (isMandated && mandataire) {
            try { tenantShema.parse(mandataire); } catch (e) { throw e; }
            if (mandataire.type === "morale" && !mandataire.representant) {
                throw ("Le type morale doit avoir un représentant");
            }
            if (mandataire.type === "morale" && mandataire.representant) {
                const representant = await OwnerSchema.create({ type: "physique", lastname: mandataire.lastname, firstname: mandataire.firstname, dob: mandataire.dob, placeofbirth: mandataire.placeofbirth, phone: mandataire.phone, address: mandataire.address, email: mandataire.email, });
                createMandataire = await TenantSchema.create({ ...mandataire, representant: representant._id });
            } else {
                saverepresentant = await TenantSchema.create(mandataire);
            }
        }

        const ownerPromises = owners.map(async (owner) => {

            if (owner.type === 'physique') {
                return await OwnerSchema.create({ type: owner.type, lastname: owner.lastname, firstname: owner.firstname, dob: owner.dob, placeofbirth: owner.placeofbirth, address: owner.address, email: owner.representantemail, phone: owner.representantphone, });
            } else if (owner.type === 'morale') {
                const representant = await OwnerSchema.create({ type: "physique", lastname: owner.representantlastname, firstname: owner.representantfirstname, dob: owner.dob, placeofbirth: owner.placeofbirth, phone: owner.representantphone, address: owner.address, email: owner.representantemail, gender: owner.gender, });
                return await OwnerSchema.create({ type: owner.type, denomination: owner.denomination, representant: representant._id, dob: owner.dob, address: owner.address, phone: owner.phone, email: owner.representantemail, });

            }
        });
        // Create or update exitenants
        const exitenantPromises = exitenants.map(async (tenant) => {
            if (tenant.type === 'physique') {
                return await TenantSchema.create({
                    type: tenant.type,
                    lastname: tenant.lastname,
                    firstname: tenant.firstname,
                    dob: tenant.dob,
                    placeofbirth: tenant.placeofbirth,
                    address: tenant.address,
                    phone: tenant.phone,
                    email: tenant.email
                });
            } else if (tenant.type === 'morale') {
                const representant = await TenantSchema.create({
                    type: "physique",
                    lastname: tenant.representantlastname,
                    firstname: tenant.representantfirstname,
                    dob: tenant.dob,
                    placeofbirth: tenant.placeofbirth,
                    phone: tenant.representantphone,
                    address: tenant.address,
                    email: tenant.representantemail
                });
                return await TenantSchema.create({
                    type: tenant.type,
                    denomination: tenant.denomination,
                    representant: representant._id,
                    dob: tenant.dob,
                    address: tenant.address,
                    phone: tenant.phone,
                    email: tenant.representantemail
                });
            }
        });
        const createdOwners = await Promise.all(ownerPromises);
        const createdExitenants = await Promise.all(exitenantPromises);

        let createdProperty = await PropertySchema.create({
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

        let review = await ReviewSchema.create({
            author: userId,
            mandataire: isMandated ? createMandataire?._id : null,
            owners: createdOwners.map(owner => owner._id),
            exitenants: createdExitenants.map(tenant => tenant._id),
            propertyDetails: createdProperty._id,
            document_address: createdProperty.address,
            review_type,
            meta: {
                signatures: {},
                "fillingPercentage": 0,
                ...complementaryDetails
            },
            pieces: [],
            clesDePorte: [],
            compteurs: [],
        });

        const shield = randomstring.generate({ length: 120, charset: 'alphanumeric', capitalization: 'lowercase', });
        const pdfFileName = `review_${shield}.pdf`;

        const lulu = getReviewExplicitName(review_type);

        let thPdfPath = `./public/documents/${lulu}_${pdfFileName}`;

        try {

            const TheFileObject = new FileModel({ name: `${lulu}_${pdfFileName}`, author: userId, location: thPdfPath, shield, type: "application/pdf" });
            TheFileObject.save();

            await FileAccessSchema.create({ userId: userId, fileId: TheFileObject._id, accessType: ['read', 'write', 'delete', 'update'], });

            await Promise.all([...[...createdExitenants, ...createdOwners].map(tenant => FileAccessSchema.create({ userId: tenant._id, fileId: TheFileObject._id, accessType: ['read', 'update'] }))]);
            await ReviewSchema.findByIdAndUpdate(review._id, {
                [`${lulu}DocumentId`]: TheFileObject._id,
            });
            let result = {
                status: true,
                message: "Etat des lieux crée avec succès",
                data: {
                    ...review.toObject(),
                    [`${lulu}DocumentId`]: TheFileObject._id,
                }
            }

            //email processing
            // ___senReviewEmails(review._id);
            //<><><><><><><><><><><><><><><><><><><><><> 
            return res.status(201).json(result);
        } catch (error) {
            console.error('PDF generation failed:', error);
            return res.status(500).json({
                status: false,
                message: "Procuration created but PDF generation failed",
                data: review
            });
        }
    },
    updatereview: async (req, res) => {
        // Logic for editing user details
        const userId = req.user._id;
        const userEmail = req.user.email;

        const reviewId = req.params.reviewid;
        if (!isValidObjectId(reviewId)) {
            return res.status(400).json({
                status: false,
                message: "Invalid review ID"
            });
        }
        const treview = await ReviewSchema.findById(reviewId)
        if (!treview) {
            return res.status(404).json({
                status: false,
                message: "Review not found"
            });
        }


        // Get X-Access-Code from request headers if present
        const accessCode = req.headers['x-access-code'] || req.headers['X-Access-Code'];
        // You can now use accessCode as needed in your logic 

        if (treview.author.toString() !== userId.toString()) {
            if (accessCode) {
                const procuration = await ProcurationSchema.findOne({ $or: [{ accessCode: `JET-${accessCode}`, }, { accessCode: `${accessCode}`, }] }).populate('accesgivenTo');
                if (!procuration) {
                    return res.status(400).json({ status: false, message: "Mauvais code ou état des lieux introuvable" });
                }
                // Check if the current user's email matches the accesgivenTo email
                if (!procuration.accesgivenTo || procuration.accesgivenTo[0].email !== req.user.email) {
                    return res.status(401).json({ status: false, message: "Vous n'avez pas accès à cet état des lieux" });
                }
            } else {
                const accessibleReviewIds = await ReviewAccessModel.find({ user: userEmail }).distinct('review');

                if (!(!accessibleReviewIds || accessibleReviewIds.length === 0)) {
                    if (!(accessibleReviewIds.map((e) => e.toString()).includes(reviewId))) {
                        return res.status(403).json({
                            status: false,
                            message: "Vous n'avez pas la permission de modifier cet état des lieux"
                        });
                    }
                } else {
                    return res.status(403).json({
                        status: false,
                        message: "Vous n'avez pas la permission de modifier cet état des lieux"
                    });
                }
            }
        }


        const {
            owners,
            exitenants,
            entrantenants,
            propertyDetails,
            compteurs,
            cledeportes,
            documentDetails,
            complementaryDetails,
            inventoryPieces,
            author,
            isMandated,
            section,
            mandataire
        } = req.body;


        let createdProperty, createdPieces, createdCompteurs, createdcles, createdpush, createdpull, createdpullmandataire;
        if (author) {

            if (isValidObjectId(author?._id)) {
                if (section == "deleteauthor") {
                    createdpull = {
                        owners: author?._id,
                        exitenants: author?._id,
                        entrantenants: author?._id
                    }
                } else {
                    await module.exports.updateAuthor(req, res, userId);
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
        if (isMandated && mandataire) {

            if (treview.mandataire) {
                await module.exports.updateAuthor(req, res, userId, 'mandataire');
            } else {
                delete mandataire._id; // Remove _id if it exists to avoid conflicts
                try { tenantShema.parse(mandataire); } catch (e) { throw e; }

                if (mandataire.type === "morale" && !mandataire.representant) {
                    throw new Error("Le type morale doit avoir un représentant");
                }
                if (mandataire.type === "morale" && mandataire.representant) {
                    delete mandataire.representant._id;
                    try { tenantShema.parse(mandataire.representant); } catch (e) { throw e; }
                    const representant = await TenantSchema.create({ ...mandataire.representant, type: "physique" });
                    createdpullmandataire = await TenantSchema.create({ ...mandataire, representant: representant._id });
                } else {
                    delete mandataire.representant;
                    createdpullmandataire = await TenantSchema.create(mandataire);
                }

            }
        } else {
            if (!isMandated && treview.mandataire) {
                await TenantSchema.findByIdAndDelete(treview.mandataire);
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

        if (propertyDetails) {
            if (propertyDetails._id) {
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
                createdProperty = await PropertySchema.findByIdAndUpdate(propertyDetails._id, updateFields);
            }
        }
        if (inventoryPieces) {
            createdPieces = await Promise.all(inventoryPieces.map(async (piece) => {
                if (piece.things && piece.things.length > 0) {
                    piece.things = await Promise.all(piece.things.map(async (thing) => {
                        let updatingThing = isValidObjectId(thing._id) ? await ThingSchema.findById(thing._id) : null;

                        let rawthing = {
                            name: thing.name,
                            count: thing.count,
                            condition: thing.condition,
                            testingStage: thing.testingStage,
                            order: thing.order,
                            comment: thing.comment,
                            meta: {
                                ...(updatingThing?.meta || {}),
                                ...((Object.fromEntries(
                                    Object.entries(thing.meta || {})
                                        .filter(([_, value]) => value !== null)
                                ))),
                            },
                        }
                        if (thing._id && isValidObjectId(thing._id)) {
                            return await ThingSchema.findByIdAndUpdate(thing._id, rawthing, { new: true });
                        } else {
                            return await ThingSchema.create(rawthing);
                        }
                    }));
                } else {
                    piece.things = [];
                }
                let updatingpiece = isValidObjectId(piece._id) ? await PieceSchema.findById(piece._id) : null;
                let rawpiece = {
                    name: piece.name,
                    type: piece.type,
                    area: piece.area,
                    count: piece.count,
                    order: piece.order,
                    comment: piece.comment,
                    meta: {
                        ...(updatingpiece?.meta || {}),
                        ...((Object.fromEntries(
                            Object.entries(piece?.meta || {})
                                .filter(([_, value]) => value !== null)
                        ))),

                    },
                    things: piece.things.map(thing => thing._id),
                }
                if (piece._id && isValidObjectId(piece._id)) {
                    return await PieceSchema.findByIdAndUpdate(piece._id, rawpiece, { new: true });
                } else {
                    return await PieceSchema.create(rawpiece);
                }
            }));

        }

        if (compteurs) {
            createdCompteurs = await Promise.all(compteurs.map(async (piece) => {
                let updatingCompteur = isValidObjectId(piece._id) ? await CompteurSchema.findById(piece._id) : null;
                delete piece.photos;
                let rawdata = {
                    ...piece,
                    meta: {
                        ...(updatingCompteur?.meta || {}),
                        ...((Object.fromEntries(
                            Object.entries(piece?.meta || {})
                                .filter(([_, value]) => value !== null)
                        ))),

                    },
                }
                if (piece._id && isValidObjectId(piece._id)) {
                    return await CompteurSchema.findByIdAndUpdate(piece._id, rawdata, { new: true });
                } else {
                    return await CompteurSchema.create(rawdata);
                }
            }));

        }

        if (cledeportes) {
            createdcles = await Promise.all(cledeportes.map(async (piece) => {
                let updatingCompteur = isValidObjectId(piece._id) ? await CleDePorteSchema.findById(piece._id) : null;

                delete piece.photos;
                let rawdata = {
                    ...piece,
                    meta: {
                        ...(updatingCompteur?.meta || {}),
                        ...((Object.fromEntries(
                            Object.entries(piece?.meta || {})
                                .filter(([_, value]) => value !== null)
                        ))),

                    },
                }
                if (piece._id && isValidObjectId(piece._id)) {
                    return await CleDePorteSchema.findByIdAndUpdate(piece._id, rawdata, { new: true });
                } else {
                    return await CleDePorteSchema.create(rawdata);
                }
            }));

        }


        let thereview = await ReviewSchema.findById(reviewId)



        let review = await ReviewSchema.findByIdAndUpdate(reviewId, {
            ...(propertyDetails ? { propertyDetails: createdProperty._id } : {}),
            ...(inventoryPieces ? { pieces: createdPieces.map(piece => piece._id) } : {}),
            ...(compteurs ? { compteurs: createdCompteurs.map(compteur => compteur._id) } : {}),
            ...(cledeportes ? { cledeportes: createdcles.map(cle => cle._id) } : {}),
            ...(createdpush ? { $push: createdpush } : {}),
            ...(createdpull ? { $pull: createdpull } : {}),
            mandataire: isMandated ? (createdpullmandataire ? createdpullmandataire._id : thereview.mandataire) : null,
            meta: {
                ...thereview.meta,
                ...((Object.fromEntries(
                    Object.entries(complementaryDetails || {})
                        .filter(([_, value]) => value !== null)
                ))),
            }
        },
            { new: true })
            .populate('propertyDetails')
            .populate('compteurs')
            .populate('cledeportes')
            .populate({
                path: 'pieces',
                populate: {
                    path: 'things',
                    model: 'things'
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
                path: 'mandataire',
                populate: {
                    path: 'representant',
                    model: 'tenants'
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
            ((review.propertyDetails?.surface != "" && review.propertyDetails?.address != "") ? 2 : 1),
            ((review.meta?.heatingType != null && review.meta?.heatingMode != null) ? 2 : 1),
            (review.pieces?.length > 0 ? 2 : 0),
            (review.compteurs?.length > 0 ? 2 : 0),
            (review.cledeportes?.length > 0 ? 2 : 0),
            ((review.exitenants?.length > 0 &&
                ((review.review_type != "procuration" && review.exitenants?.length > 0) ||
                    (review.review_type == "procuration" && review.entrantenants?.length > 0)) &&
                review.owners?.length > 0) ? 2 : 0),
            ((review.meta?.tenant_new_address != null &&
                (review.review_type == "exit" && review.meta?.tenant_new_address != "") || review.review_type != "exit"
                && review.meta?.tenant_new_address != "") ? 2 : 1)
        ];

        fillingPercentage = Math.round((steps.reduce((a, b) => a + b, 0) / (steps.length * 2)) * 100);

        await ReviewSchema.findByIdAndUpdate(reviewId, {
            meta: {
                ...review.meta,
                fillingPercentage
            }
        });
        review.meta.fillingPercentage = fillingPercentage;

        let result = {
            status: true,
            message: "Etat des lieux modifié avec succès",
            data: {
                ...review.toObject(),
            }
        }
        try {
            // generatePdfOfReview(review);
        } catch (error) {

        }
        return res.status(201).json(result);




    },
    deleteReview: async (req, res) => {
        const userId = req.user._id;

        if (!req.params.reviewid || !isValidObjectId(req.params.reviewid)) {
            return res.status(400).json({
                status: false,
                message: "Invalid review ID"
            });
        }

        const review = await ReviewSchema.findById(req.params.reviewid);

        if (!review) {
            return res.status(404).json({
                status: false,
                message: "Review not found"
            });
        }

        if (review.author.toString() !== userId.toString()) {
            return res.status(403).json({
                status: false,
                message: "You are not authorized to delete this review"
            });
        }

        // Delete associated files
        if (review.sortantDocumentId) {
            const sortantFile = await FileModel.findById(review.sortantDocumentId);
            if (sortantFile && fs.existsSync(sortantFile.location)) {
                fs.unlinkSync(sortantFile.location);
            }
            await FileModel.findByIdAndDelete(review.sortantDocumentId);
            await FileAccessSchema.deleteMany({ fileId: review.sortantDocumentId });
        }

        if (review.entranDocumentId) {
            const entranFile = await FileModel.findById(review.entranDocumentId);
            if (entranFile && fs.existsSync(entranFile.location)) {
                fs.unlinkSync(entranFile.location);
            }
            await FileModel.findByIdAndDelete(review.entranDocumentId);
            await FileAccessSchema.deleteMany({ fileId: review.entranDocumentId });
        }

        // Delete the review
        await ReviewSchema.findByIdAndDelete(req.params.reviewid);

        return res.status(200).json({
            status: true,
            messagez: "Review deleted successfully"
        });
    },
    updateAuthor: async (req, res, userId, authorkey = 'author') => {
        const author = req.body[authorkey];

        try { tenantShema.parse(author); } catch (e) { throw e; }


        if (!userId && (!author || !author._id)) {
            return res.status(400).json({ status: false, message: "Author ID is required" });
        }

        let updatedDoc = null;
        let saverepresentant = author.representant ? author.representant : null;
        delete author.representant; // Remove representant from author to avoid conflicts

        // Try updating Owner first
        updatedDoc = await OwnerSchema.findByIdAndUpdate(author._id, author, { new: true });

        if (!updatedDoc) {
            updatedDoc = await TenantSchema.findByIdAndUpdate(author._id, author, { new: true });
        }
        if (author.type === "morale" && saverepresentant) {

            if (saverepresentant._id && isValidObjectId(saverepresentant._id)) {
                const representant = await TenantSchema.findByIdAndUpdate(saverepresentant._id, saverepresentant, { new: true });
                updatedDoc.representant = representant._id;
            } else {
                delete saverepresentant._id;
                delete saverepresentant.representant;
                saverepresentant.type = "physique";
                const representant = await TenantSchema.create(saverepresentant);
                updatedDoc.representant = representant._id;
            }
            updatedDoc = await updatedDoc.save();
        }

        if (userId) {
            return 1;
        }

        if (!updatedDoc) {
            return res.status(404).json({ status: false, message: "Author not found as owner or tenant" });
        }

        return res.status(200).json({
            status: true,
            message: "Author updated successfully",
            data: updatedDoc
        });


    },

    griffeReview: async (req, res) => {
        // Logic for editing user details
        const userId = req.user._id;
        const userEmail = req.user.email;
        const { tenantSignatures, reviewId } = req.body;
        let { meta, entranDocumentId, sortantDocumentId } = await ReviewSchema.findById(reviewId).lean();
        let fullReview = await getfullReview(reviewId);
        // Search for user's position in owners, exitenants, mandataire based on email
        const userPosition = await getUserPositionInreview(fullReview, userEmail, userId);
        if (!userPosition) {
            return res.status(403).json({
                status: false,
                message: "Vous n'êtes pas autorisé à signer cet état des lieux"
            });
        }
        let createdTenantSignatures = {}
        if (tenantSignatures && Object.keys(tenantSignatures).length > 0) {
            // Validate tenant signatures
            for (const [tenantId, signature] of Object.entries(tenantSignatures)) {
                if (!isValidObjectId(tenantId)) { return res.status(400).json({ status: false, message: `Invalid tenant ID: ${tenantId}` }); }
                const tenantPosition = await getUserPositionInreview(fullReview, null, tenantId);
                if (!tenantPosition) { return res.status(404).json({ status: false, message: `Tenant with ID ${tenantId} not found in the review` }); }
                if (!signature) { return res.status(400).json({ status: false, message: `Signature path is required for tenant with ID ${tenantId}` }); }

                createdTenantSignatures[tenantId] = {
                    path: signature,
                    timestamp: new Date(),
                    position: tenantPosition
                };
            }
        }
        // Update signatures in meta
        meta.signatures = {
            ...(meta.signatures || {}),
            ...createdTenantSignatures
        };

        let checkingAllSignatures = checkAllSignatures(fullReview, meta);
        meta.signaturesMeta = {
            ...checkingAllSignatures,
        }

        // Update review with new signatures
        await ReviewSchema.findByIdAndUpdate(reviewId, { status: checkingAllSignatures.allSigned ? "completed" : "signing", meta: meta }, { new: true });
        fullReview = await getfullReview(reviewId);
        // If all required parties have signed, regenerate PDF
        try {
            const pdfPaths = fullReview?.procuration ? await generatePdfOfReview(fullReview) : await generateClassicPdfOfReview(fullReview);
            return res.status(200).json({
                status: true,
                message: "Signature ajoutée et PDF régénéré avec succès",
                data: {
                    signatures: meta.signatures,
                    entranDocumentId: pdfPaths.entranDocumentId,
                    sortantDocumentId: pdfPaths.sortantDocumentId
                }
            });
        } catch (error) {
            console.error('PDF regeneration failed:', error);
        }


        return res.status(200).json({
            status: true,
            message: "Signature ajoutée avec succès",
            data: {
                entranDocumentId,
                sortantDocumentId
            }
        });


    },
    getReviews: async (req, res) => {
        try {
            const userId = req.user._id;
            const userEmail = req.user.email;

            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 10;
            const skip = (page - 1) * limit;
            const { review_type } = req.query;

            const accessibleReviewIds = await ReviewAccessModel.find({ user: userEmail }).distinct('review');

            const query = {
                $or: [
                    { author: userId, },
                    { _id: { $in: accessibleReviewIds } }
                ]
            };
            if (review_type) query.review_type = review_type;


            const [reviews, total] = await Promise.all([
                ReviewSchema.find(query)
                    .skip(skip)
                    .limit(limit)
                    .sort({ createdAt: -1 })
                    .populate('propertyDetails')
                    .populate('compteurs')
                    .populate('cledeportes')
                    .populate({ path: 'procuration', populate: [{ path: 'author', model: 'user' }, { path: 'accesgivenTo', model: 'tenants' }] })
                    .populate({ path: 'owners', populate: { path: 'representant', model: 'owners' } })
                    .populate({ path: 'mandataire', populate: { path: 'representant', model: 'tenants' } })
                    .populate({
                        path: 'pieces',
                        populate: {
                            path: 'things',
                            model: 'things'
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
                    .lean(),
                ReviewSchema.countDocuments(query)
            ]);

            console.log(reviews);


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
    getReviewBycode: async (req, res) => {
        const userId = req.user._id;

        const { code } = req.params

        if (!code || code.length < 6) {
            return res.status(200).json({ status: false, message: "Invalid code" });
        }
        // Build query to find review by ID and code

        // Find the procuration by accessCode
        const procuration = await ProcurationSchema.findOne({ $or: [{ accessCode: `JET-${code}`, }, { accessCode: `${code}`, }] }).populate('accesgivenTo');
        if (!procuration) {
            return res.status(200).json({ status: false, message: "Mauvais code ou état des lieux introuvable" });
        }

        // Check if the current user's email matches the accesgivenTo email
        if (!procuration.accesgivenTo || procuration.accesgivenTo[0].email !== req.user.email) {
            return res.status(200).json({ status: false, message: "Vous n'avez pas accès à cet état des lieux" });
        }

        // Find the review by id and make sure it is linked to this procuration
        let review = await ReviewSchema.findOne({ procuration: procuration._id })
            .select('author owners exitenants entrantenants')
            .populate({ path: 'owners', populate: { path: 'representant', model: 'owners' } })
            .populate({ path: 'exitenants', populate: { path: 'representant', model: 'tenants' } })
            .populate({ path: 'entrantenants', populate: { path: 'representant', model: 'tenants' } })
            .lean();

        if (!review) {
            return res.status(200).json({ status: false, message: "Etat des lieux introuvable ou non lié à ce code" });
        }


        const userPosition = await getUserPositionInreview(review, req.user.email, userId);

        if (!userPosition) {
            return res.status(200).json({ status: false, message: "Vous n'avez pas accès à cet état des lieux" });
        }
        console.log(`User position in review: ${userPosition}`);
        let review_type

        switch (userPosition) {
            case "entrantenant":
                review_type = "entrance";
                break;

            default:
                review_type = "exit";
                break;
        }


        let finalReview = await getfullReview(review._id, { review_type: review_type })

        // Wait for 5 seconds before returning the response

        return res.status(200).json({
            status: true,
            message: "Review found",
            data: finalReview
        });

    },
    frontreview: async (req, res) => {
        const { id } = req.params
        if (!id || !isValidObjectId(id)) {
            req.flash('error', 'Invalid review ID');
            return res.render("invalidlink");
        }
        // Check if the review exists
        const review = await ReviewSchema.findById(id).populate('propertyDetails')

        if (!review) {
            req.flash('error', 'Review not found');
            return res.render("invalidlink");
        }
        // Check if the review is public or the user has access
        // if (review.status !== 'public' && (!req.user || review.author.toString() !== req.user._id.toString())) {
        //     req.flash('error', 'You do not have permission to view this review');
        //     return res.render("invalidlink");
        // }

        let result = {
            address: review.propertyDetails?.address || "Aucune adresse fournie",
            date: new Date(review.dateOfRealisation || Date.now()).toLocaleDateString('fr-FR', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            }),
            downloadLink: `${config.appUrl}/api/reviewfile/${review.entranDocumentId || 'entrance.pdf'}`,
            status: review.status,
        };


        try {
            return res.render("frontreview", {
                review: result,
            });
        } catch (error) {
            console.log(error.message);
            req.flash('error', 'Something went wrong. Please try again.');
            res.redirect('/login');
        }
    },
    getfullReview, getUserPositionInreview, ___senReviewEmails
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
