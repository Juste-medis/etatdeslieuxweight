const config = require("../../config/config");
const { authorname } = require("../utils");

module.exports = {
    generateEntrantProcurationHTML: (data, fortenant) => {
        const owners = data.owners;
        let { signatures, doccument_city } = data.meta || {};

        const tenants = [fortenant == "entrant" ? data.entrantenants[0] : data.exitenants[0]];
        const Theothertenants = [fortenant == "entrant" ? data.exitenants[0] : data.entrantenants[0]];
        const property = data.propertyDetails;
        const date = new Date(data.estimatedDateOfReview).toLocaleDateString('fr-FR');
        const today = new Date().toLocaleDateString('fr-FR');
        const multiowners = owners.length > 1;
        const multitenants = tenants.length > 1;

        const authorPresentText = (owner) => {
            if (owner.type == "morale") {
                return `<strong>${authorname(owner.representant)}</strong> <span>Né(e) le <strong>${new Date(owner.dob).toLocaleDateString('fr-FR')}</strong> à <strong>${owner.placeofbirth ?? owner.representant.placeofbirth}</strong> <span>représentant la société <strong>${authorname(owner)}</strong></span> <span>domicilié(e) au <strong>${owner.address}</strong></span>`
            } else {
                return `<strong>${authorname(owner)}</strong> <span>Né(e) le <strong>${new Date(owner.dob).toLocaleDateString('fr-FR')}</strong> à <strong>${owner.placeofbirth ?? owner.representant.placeofbirth}</strong> <span>demeurant au <strong>${owner.address}</strong></span>`
            }
        };

        const ownerText = multiowners ?
            `Nous soussignés: ${owners.map((owner, i) => authorPresentText(owner)).join(' et ')} ` :
            `Je soussigné(e) ${authorPresentText(owners[0])}`;

        // Gestion du singulier/pluriel pour les locataires
        const tenantText = multitenants ?
            `${tenants.map(t => authorPresentText(t)).join(' et ')}` :
            `${authorPresentText(tenants[0])}`;

        // Gestion du "mon/notre" logement 
        const propertyPossessive = multiowners ? 'notre' : 'mon';

        // Construction des blocs Bailleurs
        const ownersHTML = owners.map(owner =>
            owner.type == "morale" ?
                `<div class="owner-address-block">
                <strong>Mandant: ${authorname(owner)}</strong>
                <span>Domicilié(e) au ${owner.address}</span>
                <span>Représenté(e) par ${authorname(owner.representant)}</span>
                <span>Né(e) le ${new Date(owner.representant.dob).toLocaleDateString('fr-FR')} à ${owner.representant.placeofbirth}</span>
            </div>
        `
                :

                `<div class="owner-address-block">
                <strong>Mandant: ${authorname(owner)}</strong>
                 <span>Demeurant à ${owner.address}</span>
                <span>Né(e) le ${new Date(owner.dob).toLocaleDateString('fr-FR')} à ${owner.placeofbirth}</span>
            </div>
        `).join('');

        // Construction des blocs locataires
        const tenantsHTML = tenants.map(tenant =>
            tenant.type == "morale" ? `<div class="tenant-address-block">
                <strong>${authorname(tenant)}</strong>
                <span>Domicilié(e) au ${tenant.address}</span>
                <span>Représenté(e) par ${authorname(tenant.representant)}</span>
                <span>Né(e) le ${new Date(tenant.representant.dob).toLocaleDateString('fr-FR')} à ${tenant.representant.placeofbirth}</span>
            </div> ` :
                `
            <div class="tenant-address-block">
                <strong>${authorname(tenant)}</strong>
                 <span>Né(e) le ${new Date(tenant.dob).toLocaleDateString('fr-FR')} à ${tenant.placeofbirth}</span>
                <span>Demeurant à ${tenant.address}</span>
            </div> `


        ).join('');

        return `<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 1000px;
            margin: 0 auto;
            padding: 70px;
            font-size: 12px;
        }
        .titleblock {
            display: flex;
            flex-direction: column;            
            max-width: 325px;
        }
        .header-block {
            display: flex;
            flex-direction: row;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .logo {
             object-fit: contain;
            width: 130px;
            margin-bottom: 15px;
        }
        .maintitle {
            font-size: 14px;
            font-weight: 700;
         }
        .owner-address-block {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
            max-width: 400px;
        }
        .tenant-address-block {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
  
        }
        .signature-block {
            margin-top: 50px;
        }
        .signature-line {
            width: 300px;
            border-top: 1px solid #333; 
        }
        .footer {
            font-size: 12px; 
            text-align: center;
            margin-top: 50px;
            color: #666;
        }
        .text-underline {
            text-decoration: underline;
        }
        .signatures-container {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
         }
        .signature-item {
            margin-bottom: 30px;
            width: ${multiowners ? '45%' : '45%'};
             display: flex;
            flex-direction: column;
         }
            .selfie-photo{ width: 300px; height: 300px; object-fit: cover; border-radius: 6px; margin-top: 10px; }
    </style>
</head>
<body>
    <div class="header-block">
        <div class="titleblock">
            <span class="maintitle">
            ${fortenant == "entrant" ? "Procuration pour état des lieux de sortie" : "Procuration pour état des lieux d'entrée"}
            </span>
            <span>Procuration contradictoire à annexer au contrat de location dont il ne peut être dissocié.</span>
        </div>
        <img src="${config.appUrl}/assets/media/logos/rocketdeliveries.png" class="logo" alt="Logo">
    </div>
     ${ownersHTML} 
     <div style="display:flex;justify-content: space-between; ">
        <div style="min-width: 250px;"> </div>

         <div>${tenantsHTML} </div>
     </div>
    
    <p>Madame, Monsieur,</p>

    <p>Ne pouvant ${multiowners ? 'nous' : 'me'} présenter le <span class="text-underline">${date}</span> à l'état des lieux ${fortenant != "entrant" ? "de sortie" : "d'entrée"} concernant ${propertyPossessive} logement situé au :</p>

<p><strong>${property.address}</strong><br>
    ${property.complement ? `<strong>Complément :</strong> ${property.complement}<br>` : ""}
    ${property.floor ? `<strong>Étage :</strong> ${property.floor}<br>` : ""}
    <strong>Surface :</strong> ${property.surface}m² (${property.roomCount} pièces)<br>
    ${property.box ? `<strong>Box :</strong> ${property.box}<br>` : ""}
    ${property.cellar ? `<strong>Cave :</strong> ${property.cellar}<br>` : ""}
    ${property.garage ? `<strong>Garage :</strong> ${property.garage}<br>` : ""}
    ${property.parking ? `<strong>Parking :</strong> ${property.parking}<br>` : ""}
</p>
            <p class="body-text">${ownerText} <br /><br />${multiowners ? 'donnons' : 'donne'} par la présente, pouvoir à
                    :</p>

                <p class="body-text"> ${tenantText} , pour ${multiowners ?
                'nous' : 'me'} représenter lors de cet état des lieux.</p>


    <p>À cet effet, cette${multitenants ? 's personne' : ' personne'} pourra${multitenants ? 'ont' : ''} signer, pour ${multiowners ? 'notre' : 'mon'} compte et en ${multiowners ? 'notre' : 'mon'} nom, tout formulaire et/ou document nécessaire à la bonne exécution de cet état des lieux.</p>
        <p>Fait à <strong>${data.document_address || 'Paris'}</strong>, le ${today}</p>

    <div class="signature-block">

        <div class="signatures-container"> 
            ${owners.map((tenant) => {
                    tenant._id = tenant._id?.toString()

                    return `<div class="signature-item"> 
                 <div style="display: flex; flex-direction: column; margin-bottom: 10px;">
                    <strong>Signature du ${multiowners ? 'mandant' : 'mandant'}</strong>
                    <span>${authorname(tenant)}</span>
                </div>
                               ${signatures?.[tenant._id] ? `<span class="signature-date"><strong>Bon pour pouvoir</strong></span>` : ""}
 ${(signatures && signatures?.[tenant._id]) ? `<img src="data:image/png;base64,${signatures?.[tenant._id]?.path}" />` : "<span></span>"}
                ${signatures?.[tenant._id] ? `<span class="signature-date">Signé le <strong>${tenant ? new Date(signatures?.[tenant._id]?.timestamp).toLocaleDateString('fr-FR') : ''}</strong></span>` : ""}

                <div class="selfiephotos"> ${tenant.meta?.[data._id]?.photos ? tenant.meta?.[data._id]?.photos.map((p) => { return `<img src="${config.appUrl}/${p}" alt="Selfie photo"  class="selfie-photo" />` }) : ""} </div>
            </div>
            `}).join('')}  

            ${[...tenants].map((tenant) => {
                        tenant._id = tenant._id?.toString()

                        return `<div class="signature-item"> 
                 <div style="display: flex; flex-direction: column; margin-bottom: 10px;">
                    <strong>Mandataire </strong>
                    <span>${authorname(tenant)}</span>
                </div>
                         ${signatures?.[tenant._id] ? `<span class="signature-date"><strong>Bon pour acceptation</strong></span>` : ""}
       ${(signatures && signatures?.[tenant._id]) ? `<img src="data:image/png;base64,${signatures?.[tenant._id]?.path}" />` : "<span></span>"}
                ${signatures?.[tenant._id] ? `<span class="signature-date">Signé le <strong>${tenant ? new Date(signatures?.[tenant._id]?.timestamp).toLocaleDateString('fr-FR') : ''}</strong></span>` : ""}

                <div class="selfiephotos"> ${tenant.meta?.[data._id]?.photos ? tenant.meta?.[data._id]?.photos.map((p) => { return `<img src="${config.appUrl}/${p}" alt="Selfie photo"  class="selfie-photo" />` }) : ""} </div>
            </div>
            `}).join('')}   

        </div>
    </div> 
</body>
</html>`;
    }
};