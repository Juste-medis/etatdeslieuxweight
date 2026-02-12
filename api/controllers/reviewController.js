const userModel = require("../models/userModel");

const PropertySchema = require("../models/propertyModel")
const OwnerSchema = require("../models/ownerModel")
const TenantSchema = require("../models/tenantModel");
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
const { checkUniqueKey, isValidObjectId, gettempfilePath, getRoleName, getReviewExplicitName, personFillers, generateShield, getEstablishedDate, authorname, generateAccessCode, buildGsCommand } = require("../utils/utils");
const { tenantShema, moraltenantShema } = require("../utils/shemas");
const { generateReviewHTML } = require("../utils/pdfs/reviewpdfkit");
const { exec } = require('child_process');
const { get } = require("http");
const { sendInviteMail, sendReviewCompletedMail } = require("../services/sendmail");
const config = require("../config/config");
// Generate the HTML content
const footerhtml = fs.readFileSync('./uploads/footer.html', 'utf8');
const headerhtml = fs.readFileSync('./uploads/header.html', 'utf8');
const notificationModel = require("../models/notificationModel");
const { sendandGetResponse } = require("./notificationController");
const trashModel = require("../models/trashModel");

// Fonction utilitaire pour vérifier les signatures
const checkAllSignatures = (fullReview, meta) => {
    meta = meta || fullReview.meta || {};
    // Récupérer toutes les id qui ont signé
    const signedIds = Object.keys(meta.signatures || {});

    // Créer un ensemble d'ids requis
    const requiredIds = new Set();

    if (fullReview.mandataire) {
        requiredIds.add(fullReview.mandataire._id.toString());
    } else {
        // Ajouter les ids des Bailleurs et leurs représentants
        fullReview.owners.forEach(owner => {
            requiredIds.add(owner._id.toString());
        });
    }

    // Ajouter les ids des locataires sortants et leurs représentants
    fullReview.exitenants.forEach(tenant => {
        requiredIds.add(tenant._id.toString());
    });

    // Ajouter les ids des locataires entrants et leurs représentants
    fullReview.entrantenants.forEach(tenant => {
        requiredIds.add(tenant._id.toString());
    });


    // Vérifier si tous les ids requis ont signé
    const allSigned = Array.from(requiredIds).every(id => signedIds.includes(id));

    return {
        allSigned,
        totalRequired: requiredIds.size,
        totalSigned: signedIds.length,
        missingSignatures: Array.from(requiredIds).filter(id => !signedIds.includes(id))
    };
};
// Fonction utilitaire pour vérifier les signatures
const getfullReview = async (reviewId, query = {}) => {
    // Récupérer l'état des lieux complet
    const fullReview = await ReviewSchema.findOne({ _id: reviewId, ...query })
        .populate('propertyDetails')
        .populate('author')
        .populate('compteurs')
        .populate('cledeportes')
        .populate({
            path: 'mandataire',
            populate: {
                path: 'representant',
                model: 'tenants'
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
        return null;
    }
    fullReview.author = await userModel.findById(fullReview.author, {
        password: 0, balances: 0, createdAt: 0, updatedAt: 0, __v: 0
    }).lean();


    // Vérifier les signatures
    return {
        ...fullReview,
        signatures: checkAllSignatures(fullReview)
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
    if (review.author?.toString() === id?.toString() || review.author?.email === email) {
        return 'author';
    }


    return null;
}

const generateProcurationPdfOfReview = async (review) => {
    // Populate the procuration data for PDF generation
    const fullReview = review;
    //======================================================================The reviewType

    // Check if we have the sortant document
    if (review.sortantDocumentId) {
        const entranceReview = await ReviewSchema.findOne({ procuration: review.procuration, review_type: "entrance", _id: { $ne: review._id } }).lean();

        if (entranceReview && entranceReview.entranDocumentId) { review.entranDocumentId = entranceReview.entranDocumentId; }
    } else {
        const sortantReview = await ReviewSchema.findOne({ procuration: review.procuration, review_type: "exit", _id: { $ne: review._id } }).lean();
        if (sortantReview && sortantReview.sortantDocumentId) { review.sortantDocumentId = sortantReview.sortantDocumentId; }
    }

    const SortantFileObject = await FileModel.findById(review.sortantDocumentId.toString());
    const EntrantFileObject = await FileModel.findById(review.entranDocumentId.toString());
    let mandatairePosition = await getUserPositionInreview(review, review.mandataire?.email, review.mandataire?._id.toString())

    try {
        try {
            const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox', '--disable-setuid-sandbox'] });
            const page = await browser.newPage();

            let tempPaths = gettempfilePath();
            let tempPathe = gettempfilePath();

            // Generate the HTML content
            let generatedReview = generateReviewHTML(fullReview, "entrance", mandatairePosition == "exitenant" ? review.mandataire : review.exitenants[0]);
            const htmlContent = generatedReview.content;

            //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
            fs.writeFileSync(`./uploads/preview.html`, `${htmlContent}`, 'utf-8');
            //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

            await page.setContent(htmlContent, { waitUntil: ['load', 'domcontentloaded', 'networkidle0'], });
            await page.pdf({
                path: tempPathe,
                format: 'A4',
                margin: { top: '50px', right: '5px', bottom: '55px', left: '5px' },
                printBackground: true,
                preferCSSPageSize: false,
                scale: 1,
                displayHeaderFooter: true,
                headerTemplate: headerhtml,
                footerTemplate: `${footerhtml}`,
            });
            generatedReview = generateReviewHTML(fullReview, "exit", mandatairePosition == "entrantenant" ? review.mandataire : review.entrantenants[0]);
            const htmlContentso = generatedReview.content;
            // Génération du second PDF
            await page.setContent(htmlContentso, { waitUntil: 'networkidle0' });
            await page.pdf({
                path: tempPaths,
                format: 'A4',
                margin: { top: '50px', right: '5px', bottom: '55px', left: '5px' },
                printBackground: true,
                preferCSSPageSize: false,
                scale: 1,
                displayHeaderFooter: true,
                headerTemplate: headerhtml,
                footerTemplate: `${footerhtml}`,
            });

            await browser.close();
            let formfields = await new Promise(function (resolve, reject) {

                exec(buildGsCommand(tempPathe, EntrantFileObject.location),
                    (err) => {
                        if (err) { reject(`Erreur : ${err}`); return; }
                        exec(buildGsCommand(tempPaths, SortantFileObject.location),
                            (err) => {
                                if (err) {
                                    reject(`Erreur : ${err}`);
                                    return;
                                }
                                // Delete temp files
                                fs.unlinkSync(tempPathe);
                                fs.unlinkSync(tempPaths);
                                resolve({ sortant_pdfPath: review.sortantDocumentId, entran_pdfPath: review.entranDocumentId });
                            });


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

const generateReviewPdf = async (review) => {
    // Populate the procuration data for PDF generation
    const fullReview = review;
    const TheFileObject = await FileModel.findById(review.review_type === "exit" ? review.sortantDocumentId : review.entranDocumentId);

    try {
        const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox', '--disable-setuid-sandbox'] });
        const page = await browser.newPage();

        let tempPaths = gettempfilePath();


        const generatedReview = generateReviewHTML(fullReview, fullReview.review_type, fullReview.mandataire)
        const htmlContent = generatedReview.content;

        //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
        fs.writeFileSync(`./uploads/preview.html`, `${htmlContent}`, 'utf-8');
        //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

        await page.setContent(htmlContent, { waitUntil: ['load', 'domcontentloaded', 'networkidle0'], });
        await page.pdf({
            path: tempPaths,
            format: 'A4',
            margin: { top: '50px', right: '5px', bottom: '55px', left: '5px' },
            printBackground: true,
            preferCSSPageSize: false,
            scale: 1,
            displayHeaderFooter: true,
            headerTemplate: headerhtml,
            footerTemplate: `${footerhtml}`,
            waitForFonts: true,
        });
        await browser.close();
        let formfields = await new Promise(function (resolve, reject) {
            exec(buildGsCommand(tempPaths, TheFileObject.location),
                (err) => {
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

const ___senReviewEmails = async (reviewId,
    completed = false
) => {
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


const sendCompleteReviewNotification = async (
    fullReview
) => {
    const title = "Etat des lieux signé";
    const body = `Bonjour ${authorname(fullReview.author)}, l'état des lieux pour le bien situé au ${fullReview.propertyDetails?.address || 'adresse inconnue'} a été signé par toutes les parties. Vous pouvez désormais consulter et télécharger le document finalisé.`;
    const data = {
        toUser: fullReview.author.email,
        "type": "review_completed",
        "reviewId": fullReview._id.toString(),
        "link": `${config.appUrl}/etat-des-lieux/${fullReview._id.toString()}`,
        timestamp: new Date().toISOString(),
    }
    let response = await sendandGetResponse(fullReview.author.email, title, body, data);
    await new notificationModel({
        title,
        message: body,
        recipient_user: fullReview.author._id,
        recipient: fullReview.author.email,
        is_read: false,
        push_response: response,
        data
    }).save();
    return;
}

const ___senCompleteReviewEmails = async (reviewId) => {
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


    // await Promise.all(emailPromises);
    sendCompleteReviewNotification(fullReview);

}
// ___senCompleteReviewEmails("68ec5f63d7e85c91d4f82e3f")
const validateAutor = (author) => {
    if (author.type === "morale") {

        try { tenantShema.parse(author.representant); } catch (e) { throw e; }

        try { moraltenantShema.parse(author); } catch (e) { throw e; }
    } else {
        try { tenantShema.parse(author); } catch (e) { throw e; }

    }
}


module.exports = {
    previewage: async (req, res) => {
        // Logic for editing user details
        const userEmail = req.user.email;
        const isAdmin = req.casper === true;

        const reviewId = req.params.reviewid;
        if (!isValidObjectId(reviewId)) { return res.status(400).json({ status: false, message: "Invalid review ID" }); }
        const treview = await getfullReview(reviewId)
        if (!treview) { throw "Review not found" }
        if (!isAdmin && await getUserPositionInreview(treview, userEmail, req.user._id) === null) { throw "Vous n'êtes pas autorisé à voir cet état des lieux"; }
        let result = { status: true, data: {} }
        try {
            result.data = treview.procuration ? await generateProcurationPdfOfReview(treview) : await generateReviewPdf(treview);
        } catch (error) {
            console.log('PDF generation failed:', error);
        }
        return res.status(201).json(result);
    },
    createreview: async (req, res) => {

        // Logic for editing user details 
        const userId = req.user._id;

        const { owners, exitenants, propertyDetails, copyOptions, complementaryDetails, documentDetails: { review_type }, mandataire, isMandated } = req.body;
        try {
            checkUniqueKey([...exitenants, ...owners], ["representantemail", "email"], "Les emails des auteurs doivent être uniques");
        } catch (err) {
            throw err.message;
        }


        let newReviewData = {
            pieces: [],
            cledeportes: [],
            compteurs: [],
            incPerc: 0,
        };

        if (copyOptions) {
            let theOptions = copyOptions.copyOptions;
            let theReviewId = copyOptions.reviewId;

            // Récupérer le review existant
            const existingReview = await getfullReview(theReviewId);

            // Créer un nouveau review en copiant les données de l'existant

            const copyphoto = async (photo) => {
                try {
                    let filename = photo.split('/').pop();
                    const fileRecord = await FileModel.findOne({ $or: [{ name: `${filename}` }] }).lean();

                    if (fileRecord && fs.existsSync(fileRecord.location)) {
                        let newName = `${randomstring.generate(12)}_${path.basename(photo)}`;
                        const newPhotoPath = path.join('./uploads', newName);
                        await fs.promises.copyFile(fileRecord.location, newPhotoPath);

                        const newFileModel = new FileModel({
                            name: newName,
                            author: userId,
                            location: newPhotoPath,
                            shield: Date.now().toString(),
                            type: "image/jpeg",
                            size: (await fs.promises.stat(newPhotoPath)).size,
                            originalName: filename
                        });
                        await newFileModel.save();
                        await FileAccessSchema.create({
                            userId: userId,
                            fileId: newFileModel._id,
                            accessType: ['read', 'write', 'delete', 'write']
                        });

                        return `uploads/${newName}`;
                    }
                    return null;
                } catch (error) {
                    console.error('Error copying photo:', error);
                    return null;
                }
            }
            if (theOptions.includes("pieces")) {

                const newPieces = await Promise.all(existingReview.pieces.map(async (piece) => {
                    // Copie des objets (things) avec leurs photos
                    const newThings = await Promise.all(piece.things.map(async (thing) => {
                        let thingPhotos = [];

                        // Copie des photos de l'objet si l'option est sélectionnée
                        if (theOptions.includes("photos") && thing.photos && thing.photos.length > 0) {
                            thingPhotos = await Promise.all(thing.photos.map(copyphoto));
                            thingPhotos = thingPhotos.filter(photo => photo !== null);
                        }

                        return ThingSchema.create({
                            ...thing,
                            _id: undefined,
                            photos: thingPhotos,
                            testingStage: theOptions.includes("states") ? thing.testingStage : null,
                            condition: theOptions.includes("states") ? thing.condition : null,
                            comment: theOptions.includes("observations") ? thing.comment : null,
                        });
                    }));

                    // Copie des photos de la pièce si l'option est sélectionnée
                    let piecePhotos = [];
                    if (theOptions.includes("photos") && piece.photos && piece.photos.length > 0) {
                        piecePhotos = await Promise.all(piece.photos.map(copyphoto));
                        piecePhotos = piecePhotos.filter(photo => photo !== null);
                    }

                    return PieceSchema.create({
                        ...piece,
                        _id: undefined,
                        things: newThings.map(t => t._id),
                        photos: piecePhotos,
                        comment: theOptions.includes("observations") ? piece.comment : null,
                    });
                }));

                newReviewData.pieces = newPieces.map(p => p._id);
                newReviewData.incPerc += 14;
            }

            if (theOptions.includes("compteurs")) {
                const newCompteurs = await Promise.all(existingReview.compteurs.map(async (c) => {
                    let photos = [];
                    if (theOptions.includes("photos") && c.photos && c.photos.length > 0) {
                        photos = await Promise.all(c.photos.map(copyphoto));
                        photos = photos.filter(photo => photo !== null);
                    }

                    return CompteurSchema.create({
                        comment: theOptions.includes("observations") ? c.comment : null,
                        ...c,
                        photos: photos,
                        _id: undefined
                    });
                }));
                newReviewData.compteurs = newCompteurs.map(c => c._id);
                newReviewData.incPerc += 14;
            }
            if (theOptions.includes("cles")) {
                const newCles = await Promise.all(existingReview.cledeportes.map(async (c) => {
                    let photos = [];
                    if (theOptions.includes("photos") && c.photos && c.photos.length > 0) {
                        photos = await Promise.all(c.photos.map(copyphoto));
                        photos = photos.filter(photo => photo !== null);
                    }
                    return CleDePorteSchema.create({
                        ...c,
                        comment: theOptions.includes("observations") ? c.comment : null,
                        photos: photos,
                        _id: undefined
                    });
                }));
                newReviewData.cledeportes = newCles.map(c => c._id);
                newReviewData.incPerc += 14;
            }
            newReviewData.copyOptions = copyOptions;
            // // Copier les options sélectionnées
            // if (theOptions.includes("owners")) {
            //     newReviewData.owners = existingReview.owners.map(o => o._id);
            // }

            // if (theOptions.includes("exitenants")) {
            //     newReviewData.exitenants = existingReview.exitenants.map(t => t._id);
            // }


        } else {
            // const defaultPieceSetting = await settingModel.findOne({ name: 'defaultPiece' });
            // if (defaultPieceSetting) {
            //     const defaultPiece = await PieceSchema.findById(defaultPieceSetting.value).populate('things');
            //     if (defaultPiece) {
            //         const copiedThings = await Promise.all(defaultPiece.things.map(async (thing) => {
            //             return ThingSchema.create({ ...thing.toObject(), _id: undefined, createdAt: new Date(), updatedAt: new Date() });
            //         }));
            //         const copiedPiece = await PieceSchema.create({
            //             ...defaultPiece.toObject(), _id: undefined, things: copiedThings.map(thing => thing._id),
            //             createdAt: new Date(), updatedAt: new Date()
            //         });
            //         newReviewData.pieces = [copiedPiece._id];
            //     }
            // }
        }

        if (isMandated && !mandataire) { return res.status(400).json({ status: false, message: "Le mandataire est requis lorsque isMandated est vrai" }); }

        let createMandataire = null;
        if (isMandated && mandataire) {
            validateAutor(mandataire);
            if (mandataire.type === "morale" && !mandataire.representant) {
                throw ("Le type morale doit avoir un représentant");
            }
            if (mandataire.type === "morale" && mandataire.representant) {
                delete representant.representant;

                const representant = await TenantSchema.create({ type: "physique", lastname: mandataire.representant.lastname, firstname: mandataire.representant.firstname, dob: mandataire.representant.dob, placeofbirth: mandataire.representant.placeofbirth, phone: mandataire.phone ?? mandataire.representant.phone, address: mandataire.representant.address, email: mandataire.representant.email, });
                createMandataire = await TenantSchema.create({ ...mandataire, representant: representant._id });
            } else {
                delete mandataire.representant;
                delete mandataire._id;

                createMandataire = await TenantSchema.create(mandataire);
            }
        }


        const exitenantPromises = exitenants.map(tenant => personFillers(tenant, TenantSchema));
        const ownerPromises = owners.map(owner => personFillers(owner, OwnerSchema));

        const createdOwners = await Promise.all(ownerPromises);
        const createdExitenants = await Promise.all(exitenantPromises);

        let createdProperty = await PropertySchema.create({
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
                "fillingPercentage": 42.85 + newReviewData.incPerc,
                ...complementaryDetails,
                status: "draft",
            },
            ...newReviewData,
        });

        const shield = generateShield(), pdfFileName = `review_${shield}.pdf`;

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
            review = await getfullReview(review._id);
            let result = {
                status: true,
                message: "Etat des lieux crée avec succès",
                data: {
                    ...review,
                    [`${lulu}DocumentId`]: TheFileObject._id,
                }
            }

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
        const isAdmin = req.casper == true;

        const {
            owners,
            exitenants,
            entrantenants,
            propertyDetails,
            compteurs,
            cledeportes,
            complementaryDetails,
            inventoryPieces,
            author,
            isMandated,
            section,
            mandataire,
            canModifyMandataire
        } = req.body;

        const reviewId = req.params.reviewid;
        if (!isValidObjectId(reviewId)) { return res.status(400).json({ status: false, message: "Id d'état des lieux invalide" }); }
        const treview = await ReviewSchema.findById(reviewId)
        if (!treview) { return res.status(404).json({ status: false, message: "Etat des lieux introuvable" }); }

        if (treview.status === "signing" || treview.status === "completed" && section !== "griffe") {
            return res.status(400).json({ status: false, message: "Vous ne pouvez pas modifier un état des lieux déjà signé" });
        }

        // Get X-Access-Code from request headers if present
        const accessCode = req.headers['x-access-code'] || req.headers['X-Access-Code'];
        // You can now use accessCode as needed in your logic 

        if (!isAdmin && treview.author.toString() !== userId.toString()) {
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
                console.log("Author to be created:", author);
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

                if (treview.mandataire) {
                    await module.exports.updateAuthor(req, res, userId, 'mandataire');
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
                if (!isMandated && treview.mandataire) {
                    await TenantSchema.findByIdAndDelete(treview.mandataire);
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
                    photos: piece.photos,
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
                ...(complementaryDetails ? { ...complementaryDetails } : {}),
            }
        }, { new: true })
            .populate('propertyDetails')
            .populate('compteurs')
            .populate('cledeportes')
            .populate('author')
            .populate({
                path: 'mandataire',
                populate: {
                    path: 'representant',
                    model: 'tenants'
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



        let fillingPercentage = 0;
        const steps = [
            ((review.propertyDetails?.surface != "" && review.propertyDetails?.address != "") ? 2 : 1),
            ((review.meta?.heatingType != null && review.meta?.heatingMode != null) ? 2 : 1),
            (review.pieces?.length > 0 ? 2 : 0),
            (review.compteurs?.length > 0 ? 2 : 0),
            (review.cledeportes?.length > 0 ? 2 : 0),
            ((review.exitenants?.length > 0 &&
                ((!review.procuration && review.exitenants?.length > 0) ||
                    (review.procuration && review.entrantenants?.length > 0)) &&
                review.owners?.length > 0) ? 2 : 0),
            ((review.meta?.tenant_new_address != null &&
                (review.review_type == "exit" && review.meta?.tenant_new_address != "") || review.review_type != "exit"
                && review.meta?.tenant_new_address != "") ? 2 : 1)
        ];

        fillingPercentage = Math.round((steps.reduce((a, b) => a + b, 0) / (steps.length * 2)) * 100);


        await ReviewSchema.findByIdAndUpdate(reviewId, {
            meta: {
                ...review.meta,
                signaturesMeta: {
                    ...(review?.meta?.signaturesMeta || {}),
                    ...checkAllSignatures(review),
                },
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

        //si l'etat des lieu a une proccuration copier ses champs dans le seconds etat des lieux de meme proccuration
        if (review.procuration) {
            const linkedReviews = await ReviewSchema.find({ procuration: review.procuration, _id: { $ne: review._id } });
            for (const linkedReview of linkedReviews) {
                await ReviewSchema.findByIdAndUpdate(linkedReview._id, {
                    mandataire: review.mandataire,
                    owners: review.owners,
                    exitenants: review.exitenants,
                    entrantenants: review.entrantenants,
                    propertyDetails: review.propertyDetails,
                    pieces: review.pieces,
                    compteurs: review.compteurs,
                    cledeportes: review.cledeportes,
                    meta: {
                        ...linkedReview.meta,
                        ...review.meta,
                    }
                });
            }
        }

        return res.status(201).json(result);




    },
    deleteReview: async (req, res) => {
        const isAdmin = req.casper == true;

        const userId = req.user._id;

        if (!req.params.reviewid || !isValidObjectId(req.params.reviewid)) { return res.status(400).json({ status: false, message: "Identifiant d'état des lieux invalide" }); }

        const review = await ReviewSchema.findById(req.params.reviewid);

        if (!review) { return res.status(404).json({ status: false, message: "Etat des lieux non trouvé" }); }

        if (!isAdmin && review.author.toString() !== userId.toString()) {
            throw "Vous n'avez pas la permission de supprimer cet état des lieux";
        }
        // Delete associated files
        if (review.status != "completed") {
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
        }

        await trashModel.create({
            originalId: review._id,
            collectionName: 'reviews',
            deletedBy: userId,
            deletedAt: new Date(),
            data: review.toObject()
        });

        // Delete the review
        await ReviewSchema.findByIdAndDelete(req.params.reviewid);

        return res.status(200).json({
            status: true,
            message: "Etat des lieux supprimé avec succès"
        });
    },
    updateAuthor: async (req, res, userId, authorkey = 'author') => {


        const author = req.body[authorkey];
        if (author.type === "morale") {
            author.representant = {
                ...author.representant,
                email: author.representant?.email || author.email,
                phone: author.representant?.phone || author.phone,
                address: author.representant?.address || author.address,
                dob: author.representant?.dob || author.dob,
            }
        }


        validateAutor(author);

        if (!userId && (!author || !author._id)) {
            return res.status(400).json({ status: false, message: "Author ID is required" });
        }

        let updatedDoc = null, isOwner = true;
        let saverepresentant = author.representant ? author.representant : null;
        delete author.representant;
        delete saverepresentant.representant;

        // Try updating Owner first
        updatedDoc = await OwnerSchema.findByIdAndUpdate(author._id, author, { new: true });

        if (!updatedDoc) {
            isOwner = false;
            updatedDoc = await TenantSchema.findByIdAndUpdate(author._id, author, { new: true });
        }
        if (author.type === "morale" && saverepresentant) {

            if (saverepresentant._id && isValidObjectId(saverepresentant._id)) {
                const representant = await TenantSchema.findByIdAndUpdate(saverepresentant._id, saverepresentant, { new: true })
                    ?? await OwnerSchema.findByIdAndUpdate(saverepresentant._id, saverepresentant, { new: true });
                updatedDoc.representant = representant._id;
            } else {
                delete saverepresentant._id;
                delete saverepresentant.representant;
                saverepresentant.type = "physique";
                const representant = isOwner
                    ? await OwnerSchema.create(saverepresentant) :
                    await TenantSchema.create(saverepresentant);
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
        let { meta, } = await ReviewSchema.findById(reviewId).lean();
        let fullReview = await getfullReview(reviewId);
        // Search for user's position in owners, exitenants, mandataire based on email
        const userPosition = await getUserPositionInreview(fullReview, userEmail, userId);
        if (!userPosition) {
            return res.status(403).json({
                status: false,
                message: "Vous n'êtes pas autorisé à signer cet état des lieux"
            });
        }
        // if (fullReview.status === "completed") {
        //     return res.status(400).json({ status: false, message: "Vous ne pouvez pas signer un état des lieux déjà complété" });
        // }
        if (!fullReview.credited) {
            return res.status(400).json({ status: false, message: "L'état des lieux doit être reglé avant de pouvoir être signé" });
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
        const establishedDate = getEstablishedDate(meta);

        let checkingAllSignatures = checkAllSignatures(fullReview, meta);
        meta.signaturesMeta = {
            ...(meta.signaturesMeta || {}),
            ...checkingAllSignatures,
            establishedDate: establishedDate,
        }

        await ReviewSchema.findByIdAndUpdate(reviewId, { status: checkingAllSignatures.allSigned ? "completed" : "signing", meta: meta }, { new: true });


        if (checkingAllSignatures.allSigned && fullReview.procuration) {
            const procurationController = require("./procurationController");

            // Give access to all tenants and owners involved in the procuration review
            const procurationId = fullReview.procuration._id;
            let fullProcuration = await procurationController.getfullProcuration(procurationId);

            const backmandataire = fullProcuration.accesgivenTo[0];
            const bacbackmandatairePosition = await getUserPositionInreview(fullProcuration, backmandataire.email);
            const concernedReview = await ReviewSchema.findOne(
                {
                    procuration: procurationId,
                    review_type: bacbackmandatairePosition == "entrantenant" ? "entrance" : "exit"
                });

            const exitenants = fullProcuration.exitenants || [];
            const entrantenants = fullProcuration.entrantenants || [];
            const owners = fullProcuration.owners || [];
            try {

                await Promise.all([
                    ...[...exitenants, ...entrantenants, ...owners].map(tenant => {
                        const newaccees = new ReviewAccessModel(
                            {
                                user: `${tenant.email}`,
                                procuration: procurationId,
                                review: concernedReview._id,
                                expiryDate: new Date(new Date().getTime() + 24 * 60 * 60 * 1000 * 360),
                                meta: {
                                    code: generateAccessCode(),
                                    reason: "Accès accordé automatiquement après signature de la procuration"
                                }
                            }
                        );
                        return newaccees.save();

                    }
                    )
                ]);
            } catch (error) {
                console.log("Error while granting access after procuration signing:", error);

                throw error;
            }
        }
        fullReview = await getfullReview(reviewId);
        // If all required parties have signed, regenerate PDF
        try {
            const pdfPaths = fullReview?.procuration ? await generateProcurationPdfOfReview(fullReview) : await generateReviewPdf(fullReview);

            //Envoie des mail et notifications si l'état des lieux est complété
            if (fullReview.status === "completed") {

                //email processing
                ___senCompleteReviewEmails(fullReview._id);
                //<><><><><><><><><><><><><><><><><><><><><> 

            }
            return res.status(200).json({
                status: true,
                message: "Signature ajoutée et PDF régénéré avec succès",
                data: {
                    signatures: meta.signatures,
                    entranDocumentId: pdfPaths.entranDocumentId,
                    sortantDocumentId: pdfPaths.sortantDocumentId,
                    meta: meta,
                }
            });
        } catch (error) {
            console.error('PDF regeneration failed:', error);
        }
    },
    getReviews: async (req, res) => {
        const isAdmin = req.casper === true;


        try {
            const userId = req.user._id;
            const userEmail = req.user.email;

            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 10;
            const skip = (page - 1) * limit;
            const { review_type, filter } = req.query;
            let globalProject = { 'procuration.author.password': 0, 'author.password': 0, 'author.dob': 0, 'procuration.author.balance': 0, 'author.balance': 0 };

            const accessibleReviewIds = await ReviewAccessModel.find({ user: userEmail }).distinct('review');
            const baseMatch = isAdmin ? {} : {
                $or: [
                    { $and: [{ author: userId }, { procuration: null }] },
                    ...(accessibleReviewIds.length ? [{ _id: { $in: accessibleReviewIds } }] : [])
                ]
            };

            if (review_type) baseMatch.review_type = review_type;

            let postMatch = {};
            if (filter) {
                const filtering = JSON.parse(filter);
                if (filtering.status) {
                    postMatch.status = filtering.status == "all" || !filtering.status ? { $in: ["draft", "signing", "completed"] } : filtering.status;
                    if (postMatch.status === undefined) delete postMatch.status;
                }
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
                //dateRangeformat "${picked.start.day}/${picked.start.month}/${picked.start.year} - ${picked.end.day}/${picked.end.month}/${picked.end.year}"
                if (filtering.dateRange && filtering.dateRange.includes('-')) {
                    const [startStr, endStr] = filtering.dateRange.split('-').map(s => s.trim());
                    const [startDay, startMonth, startYear] = startStr.split('/').map(Number);
                    const [endDay, endMonth, endYear] = endStr.split('/').map(Number);
                    const startDate = new Date(startYear, startMonth - 1, startDay);
                    const endDate = new Date(endYear, endMonth - 1, endDay, 23, 59, 59, 999);
                    postMatch.createdAt = { $gte: startDate, $lte: endDate };
                }
            }

            // console.log("baseMatch:", JSON.stringify(baseMatch, null, 2));
            // console.log("postMatch:", JSON.stringify(postMatch, null, 2));

            const [result] = await
                ReviewSchema.aggregate([
                    { $match: baseMatch },
                    { $lookup: { from: 'properties', localField: 'propertyDetails', foreignField: '_id', as: 'propertyDetails' } },
                    { $lookup: { from: 'compteurs', localField: 'compteurs', foreignField: '_id', as: 'compteurs' } },
                    { $lookup: { from: 'cledeportes', localField: 'cledeportes', foreignField: '_id', as: 'cledeportes' } },
                    { $lookup: { from: 'pieces', localField: 'pieces', foreignField: '_id', pipeline: [{ $lookup: { from: 'things', localField: 'things', foreignField: '_id', as: 'things' } }], as: 'pieces' } },
                    {
                        $lookup: {
                            from: 'procurations',
                            localField: 'procuration',
                            foreignField: '_id',
                            pipeline: [
                                { $lookup: { from: 'users', localField: 'author', foreignField: '_id', as: 'author', }, },
                                { $set: { author: { $first: '$author' } } },
                                { $lookup: { from: 'tenants', localField: 'accesgivenTo', foreignField: '_id', as: 'accesgivenTo', }, },
                            ],
                            as: 'procuration',
                        },
                    },
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
                            procuration: { $arrayElemAt: ['$procuration', 0] },
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
        const review = await ReviewSchema.findById(id).populate('propertyDetails').populate({ path: 'procuration', populate: [{ path: 'author', model: 'user' }, { path: 'accesgivenTo', model: 'tenants' }] });

        if (!review) {
            req.flash('error', 'Review not found');
            return res.render("invalidlink");
        }
        // Check if the review is public or the user has access
        // if (review.status !== 'public' && (!req.user || review.author.toString() !== req.user._id.toString())) {
        //     req.flash('error', 'You do not have permission to view this review');
        //     return res.render("invalidlink");
        // }

        let entrantLinkId, sortantLinkId;
        if (review.procuration) {
            entrantLinkId = (await ReviewSchema.findOne({ procuration: review.procuration._id, review_type: "entrance" }))?.entranDocumentId
            sortantLinkId = (await ReviewSchema.findOne({ procuration: review.procuration._id, review_type: "exit" }))?.sortantDocumentId
        }

        let result = {
            address: review.propertyDetails?.address || "Aucune adresse fournie",
            date: new Date(review.dateOfRealisation || Date.now()).toLocaleDateString('fr-FR', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            }),
            downloadLink: `${config.appUrl}/api/reviewfile/${review.entranDocumentId || review.sortantDocumentId || 'entrance.pdf'}`,
            isByProcuration: review.procuration ? true : false,
            entrantLink: entrantLinkId ? `${config.appUrl}/api/reviewfile/${entrantLinkId}` : null,
            sortantLink: sortantLinkId ? `${config.appUrl}/api/reviewfile/${sortantLinkId}` : null,

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

    getReviewById: async (req, res) => {
        //wait 10 sec 
        const userId = req.user._id;
        const userEmail = req.user.email;
        const { procurationId } = req.query;
        const isAdmin = req.casper === true;

        let reviewaccess
        if (procurationId) {
            if (!isAdmin) {
                reviewaccess = await ReviewAccessModel.findOne({ user: userEmail, procuration: procurationId });
                if (!reviewaccess) {
                    return res.status(403).json({ status: false, message: "Vous n'avez pas accès à cet état des lieux" });
                }
            } else {
                //get the review of AccesGivenTo user or the procuration
                const procuration = await ProcurationSchema.findById(procurationId).populate('accesgivenTo');
                if (!procuration) {
                    return res.status(404).json({ status: false, message: "Procuration introuvable" });
                }

                let theMandataire = procuration.accesgivenTo[0];

                reviewaccess = await ReviewAccessModel.findOne({ user: theMandataire.email, procuration: procurationId });
            }

            if (!reviewaccess) {
                return res.status(404).json({ status: false, message: "Aucun état des lieux lié à cette procuration" });
            }

            const review = await getfullReview(reviewaccess.review)

            if (!review) {
                return res.status(404).json({ status: false, message: "Etat des lieux introuvable ou supprimé" });
            }

            return res.status(200).json({ status: true, data: review });
        }

        const reviewId = req.params.reviewId;
        if (!isValidObjectId(reviewId)) { return res.status(400).json({ status: false, message: "Id de l'état des lieux invalide" }); }
        const review = await getfullReview({ _id: reviewId });
        if (!review) { return res.status(404).json({ status: false, message: "Etat des lieux introuvable" }); }
        if (!isAdmin && await getUserPositionInreview(review, userEmail, userId) === null) { return res.status(403).json({ status: false, message: "Vous n'êtes pas autorisé à voir cet état des lieux" }); }

        return res.status(200).json({ status: true, data: review });
    },

    getfullReview, getUserPositionInreview, ___senReviewEmails, checkAllSignatures
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
