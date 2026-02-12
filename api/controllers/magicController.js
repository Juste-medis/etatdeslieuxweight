

const { generateEntrantProcurationHTML } = require("../utils/pdfs/pdfkit");
const { checkUniqueKey, isValidObjectId, gettempfilePath, autoPopulateRecursively, getRoleName, getReviewExplicitName, getFullDate, personFillers, generateShield, getEstablishedDate, numerizeObject } = require("../utils/utils");
const { tenantShema, moraltenantShema } = require("../utils/shemas");
const { generateReviewHTML } = require("../utils/pdfs/reviewpdfkit");
const { exec } = require('child_process');
const { get } = require("http");
const { sendInviteMail } = require("../services/sendmail");
// Generate the HTML content
const ollama = require('ollama').default
const fs = require('fs');
const path = require('path');
const { runImageAnalysis } = require("../ai/anlayzer");
const superagent = require("superagent");
const config = require("../config/config");


async function analyzePropertyImages(photos) {
    try {
        // Vérifier que les photos existent
        const existingPhotos = photos.filter(photoPath => {
            const exists = fs.existsSync(photoPath);
            if (!exists) {
                console.warn(`Photo non trouvée: ${photoPath}`);
            }
            return exists;
        });

        if (existingPhotos.length === 0) {
            throw new Error('Aucune photo valide trouvée');
        }

        // Préparer le prompt avec les chemins des photos
        const prompt = `
        fait moi l'etat des lieu de cette image : ${existingPhotos.join(', ')} en francais de maniere professionnelle et detaillée.
        donne le resultat sous forme tableau de meuble, en json avec les cles suivantes pour chaque element detecté :

        {
            "meuble": "nom du meuble",
            "etat": "etat du meuble",(good,average,bad,new)
            "nombre": "nombre d'element",
            "remarques": "remarques supplémentaires", 
            "testingStage: (unknown,ok,not_working,not_testes)
        } `;

        console.log("Envoi de la requête à Ollama...");

        // Utiliser un modèle disponible
        const availableModels = ['llava'];
        let response;
        let modelUsed;

        // Essayer différents modèles
        for (const model of availableModels) {
            try {
                console.log(`Essai avec le modèle: ${model}`);
                response = await ollama.chat({
                    model: model,
                    messages: [
                        {
                            role: 'system',
                            content: 'Detecte les meubles sur cette image'
                        },
                        { role: 'user', content: prompt }
                    ],
                    max_tokens: 1500,
                    temperature: 0.3, // Plus bas pour plus de précision
                });
                modelUsed = model;
                break; // Sortir de la boule si ça fonctionne
            } catch (modelError) {
                console.warn(`Modèle ${model} non disponible: ${modelError.message}`);
                continue;
            }
        }

        if (!response) {
            throw new Error('Aucun modèle Ollama disponible');
        }

        console.log(`Réponse reçue du modèle: ${modelUsed}`);

        return {
            success: true,
            model: modelUsed,
            analysis: response.message.content,
            photosAnalyzed: existingPhotos.length
        };

    } catch (error) {
        console.error("Erreur lors de l'analyse:", error);
        return {
            success: false,
            error: error.message,
            suggestion: 'Vérifiez que Ollama est installé et qu\'un modèle est disponible (ollama pull llama3)'
        };
    }
}

// Utilisation
const photos = [
    "./uploads/1757317329954-9xpw2134sc_68bda14dbe1f402098e0cb0d_image.jpg"
];

// analyzePropertyImages(photos)
//     .then(result => {
//         if (result.success) {
//             console.log("✅ Analyse réussie!");
//             console.log(`Modèle utilisé: ${result.model}`);
//             console.log(`Photos analysées: ${result.photosAnalyzed}`);
//             console.log("\n📋 Rapport d'analyse:");
//             console.log(result.analysis);
//         } else {
//             console.log("❌ Échec de l'analyse:");
//             console.log(result.error);
//             console.log(result.suggestion);
//         }
//     })
//     .catch(console.error);

module.exports = {
    magicanalyse: async (req, res) => {
        const { photos, piece_order } = req.body;

        //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

        let url = `https://adidome.com/etatia/api/analyse`;
        let infos;
        try {
            infos = await superagent
                .post(url)
                .send({
                    photos: photos.map(p => `${config.appUrl}/${p}`),
                    "section": "preview",
                })
                .set("accept", "application/json")
                .set("Content-Type", "application/json")
                // .set("Authorization", `Bearer ${config.token}`)
                .set("User-Agent", "yambro");

        } catch (error) {
            console.log(error);
            infos = {
                text: [
                    { "name": "meuble", "count": 1, "etat": "average", error }
                ]
            }
            throw "search_failed";
        }
        //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
        let response = typeof infos.text === 'string' ? (JSON.parse(infos.text)).data : (infos.text);

        response = numerizeObject(response)
        console.log(response);

        await new Promise(resolve => setTimeout(resolve, 1000));
        res.json({
            message: 'Image analysis complete',
            status: true,
            data: response

        });
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
