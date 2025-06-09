const config = require("../../config/config");
const { getState, getTestingStates, getcompteurName, getFullDate } = require("../utils");

module.exports = {
    generateReviewHTML: (data, fortenant) => {
        const property = data.propertyDetails;
        const owners = data.owners;
        const cledeportes = data.cledeportes;
        const compteurs = data.compteurs.reduce((acc, compteur) => {
            if (!acc[compteur.type]) {
                acc[compteur.type] = [];
            }
            acc[compteur.type].push(compteur);
            return acc;
        }, {});




        // console.log(data.meta);




        const pieces = data.pieces;
        const dateOfEntryReview = new Date(data.dateOfRealisation).toLocaleDateString('fr-FR')
        const tenantEntryReviewDate = data.meta.tenant_entry_date ? new Date(data.meta.tenant_entry_date).toLocaleDateString('fr-FR') : "Inconnu";

        //Section Bien Concerné 

        //Section LE BAILLEUR

        const date = new Date(data.estimatedDateOfReview).toLocaleDateString('fr-FR');
        let { meta: signatures } = data;

        const establishedDate = Object.values(signatures?.signatures || {}).reduce((latest, sig) => {
            const sigDate = new Date(sig.timestamp);
            return !latest || sigDate > latest ? sigDate : latest;
        }, null) ? getFullDate(Object.values(signatures?.signatures || {}).reduce((latest, sig) => {
            const sigDate = new Date(sig.timestamp);
            return !latest || sigDate > latest ? sigDate : latest;
        }, null)) : '';



        const exitenants = [...data.exitenants, ...data.entrantenants];
        const entrantenants = data.entrantenants;
        const proccurarion = data.proccurarion ??
        //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
        {
            accesgivenTo: [exitenants[0]],
        }
        //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

        const today = new Date().toLocaleDateString('fr-FR');



        let photoCounter = {
            compteurs: 0,
            current: 0,
        }
        // console.log(data);

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
            height: 100px;
            object-fit: contain;
            width: 200px;
            margin-bottom: 15px;
        }
        .maintitle {
            font-size: 14px;
            font-weight: 700;
         }
        .header-info-block {
            margin-bottom: 30px;
            display: flex;
            flex-direction: column;
         }
            .header-info-block .section-label {
            display: flex;
            min-width: 70px;
         } 
             .tenant-address-block .section-label {
            min-width:100px  !important;
         } 
            .property-address-block .section-label {
            min-width:170px  !important;
         } 
             .header-info-block .tr {
            display: flex;
            flex-direction: row;
         }
            .section-title {
                font-weight: bold;
         font-size: 14px;
            margin-bottom: 10px;
            width: 100%;
            color: darkorange;
         }
            .piece-name {
                        font-weight: 600;
 font-size: 20px;
            margin-bottom: 10px;
            width: 100%;
         }
.photolabel {
            background-color:  black;
            padding: 2px 7px;
            margin-bottom: 4px;
            border-radius: 3px;
            color: white;
        }
        .tenant-address-block {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
  
        }
             thead {
            background-color: #f2f2f2;
                height: 66px;
        }
              table,
        th,
        td {
            border-width: 1.5px;
            border-style: solid;
            border-color: #333;
        }
        .signature-block {
            margin-top: 50px;
             page-break-before: avoid;
    page-break-inside: avoid;
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
            margin-top: 30px;
         }
        .signature-item {
            margin-bottom: 30px;
            width: ${owners.length > 1 ? '45%' : '45%'};
             display: flex;
            flex-direction: column;
         }

        .photo-block p {
            margin: 0px;
            text-align: center;
        }

        .photo-block p span {
            font-weight: bold;
        }
 
        .photo-block:nth-child(odd) {
            padding-left: 5rem;
        }

        .photo-block:nth-child(even) {
            padding-right: 5rem;
        }

        .photo-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 64px;
            margin-bottom: 30px;
        }

        .photo-desc {
            font-size: 12px;
            color: #666;
            margin-bottom: 10px !important;
             
        }
            .observationcol{ 
            width: 250px; }
            .observatiheberger{
             display: flex; flex-wrap: wrap}

/*
             .contitionstate{
            background-color: #f9b053;

             }
    */
             .contitionstate span {
             color: black;
            font-weight: bold;

             }

             .legitimetext {
            margin-bottom: 14px;
            font-size: 12px;
    }
        .rightqrcodecontainer {
            max-width: 275px;
            display: flex;
            flex-direction: row;
            justify-content: space-between;
            border: 1.9px solid #333;
            padding: 3px 5px;

        }  .rightqrcodecontainer span {
          font-size: 10px;
        }
        .qrcode {width:65px;height:65px;}

        .device-title { margin: 0 0 12px 0; color: #333; font-size: 1.1em; } .device-status { display: flex; flex-wrap: wrap; gap: 16px; margin-bottom: 12px; } .status-item { display: flex; align-items: center; gap: 8px; } .status-label { font-weight: 500; color: #555; } .status-value { padding: 4px 8px; border-radius: 4px; font-weight: 500; } 
        .status-value.presence { background-color: ${data.meta.security_smoke == "yes" ? '#e8f5e9' : '#ffebee'}; color: ${data.meta.security_smoke == "yes" ? '#2e7d32' : '#c62828'}; } 
.condition-value{
padding: 4px 8px;}  
.condition-value.good,
.condition-value.ok {
  background-color: #e8f5e9;
  color: #2e7d32;
}
.condition-value.average {
  background-color: #fff3e0;
  color: #ff9800;
}
.condition-value.bad {
  background-color: #ffebee;
  color: #f44336;
}
.condition-value.new {
  background-color: #e3f2fd;
  color: #1976d2;
}
.condition-value.not_applicable {
  background-color: #f5f5f5;
  color: #9e9e9e;
}

.heatingtr td{
            padding: 8px;
}

        .functionality-options { display: flex; gap: 12px; } .option { display: flex; align-items: center; gap: 4px; padding: 4px 8px; border-radius: 4px; cursor: default; } .option-marker { display: inline-block; width: 12px; height: 12px; border-radius: 50%; background: #e0e0e0; } .option.selected .option-marker { background: #4caf50; } 
        .yes-option.selected { background-color: #e8f5e9; color: #2e7d32; } 
        .no-option.selected { background-color: #ffebee; color: #c62828; } 
        .not_tested-option.selected { background-color: #fff8e1; color: #f57f17; } 
         .yes-option.selected .option-marker { background: #4caf50; }
         .no-option.selected .option-marker { background: #f44336; }
         .not-tested-option.selected .option-marker { background: #ff9800; }

        .device-observations { border-top: 1px solid #eee; padding-top: 12px; } .observations-title { margin: 0 0 8px 0; font-size: 0.9em; color: #555; } .photo-reference { display: inline-flex; align-items: center; gap: 6px; padding: 4px 8px; background-color: #f5f5f5; border-radius: 4px; font-size: 0.9em; } .photo-icon { font-size: 1.1em; }
   
   
   .selfie-photo{
   
   width: 300px; height: 300px; object-fit: cover; border-radius: 6px; margin-top: 10px;
   }
   
        </style>
</head>
<body>
    <div class="header-block">
        <div class="titleblock">
            <span class="maintitle">ETAT DES LIEUX ${data.proccurarion ? fortenant != "exit" ? "D'ENTREE" : "DE SORTIE" : fortenant != "entrance" ? " DE SORTIE" : " D'ENTREE"} </span>
            <span>Le présent état des lieux a été établi de manière contradictoire entre les parties mentionnées ci-après, pour le logement désigné ci-dessous, loué en vertu d’un contrat sous seing privé.</span>
        </div>
        <img src="https://jatai.fr/wp-content/uploads/2024/09/cropped-Copy-of-Jatai.png" class="logo" alt="Logo">
    </div>
     <div style="display: flex; justify-content: space-between; margin-bottom: 30px;">
        <div class="" style="display: flex;  width: 308px; flex-direction: column;">
            <div style="display: flex; justify-content: space-between; font-weight: bold;">
                <span style="">Date d'établissement :</span>
                <span>
                ${data.status == "draft" ? "à venir" : establishedDate}</span>
                </span>
            </div>
           ${data.status == "draft" ? `<span style="font-size: 7px; background-color: #dfaa74; width: fit-content; align-self: self-end;"  > la date d'établissement sera fixée lors de la signature du document</span>` : ""}</span>
            ${fortenant != "exit" ? "" : `<div style="display: flex; justify-content: space-between;">
                <span class="">Date d'état des lieux d'entrée :</span>
                <span>
                 ${data.status == "draft" ? "à venir" : tenantEntryReviewDate}</span>
                 </span>
            </div>`}
        </div>
        <div class="rightqrcodecontainer">
            <div style="display: flex; flex-direction: column; justify-content: center;">
                <span style="font-weight: bold; margin-bottom: 5px;">Ce document est protégé contre toute altération, un QR code permet de vérifier son intégrité.</span>
            </div>
            <div>
                <div style="display: flex; justify-content: center; align-items: center;">
                    <img src="${data.qrcode}"
                        alt="QR Code" class="qrcode"> 
                </div>
            </div>

        </div>
    </div> 
     <div class="header-info-block">
                <strong class="section-title">BIEN CONCERNÉ</strong>
                <div class="tr" ><span class="section-label" >Type:</span><span> Appartement loué ${property.furnitured ? 'meublé' : 'non meublé'} - ${property.roomCount} pièce${property.roomCount > 1 ? 's' : ''} - ${property.surface} m² </span></div>
                <div class="tr" ><span class="section-label">Adresse:</span><span> ${property.address}</span></div>
            </div>
     <div class="header-info-block tenant-address-block">
                <strong class="section-title">LE${owners.length > 0 ? "S" : ""} BAILLEUR${owners.length > 0 ? "S" : ""}</strong>
  
        ${owners.map(author => `
            <div class="tr" ><span class="section-label">${author.type != "morale" ? "M/Mme" : "Société"} :</span><span> ${author.type != "morale" ? `${author.firstname} ${author.lastname}` : `${author.denomination}`} </span></div>
            <div class="tr" ><span class="section-label">Domicilié(e) à :</span><span> ${author.address}</span></div> 
            <div class="tr" ><span class="section-label">Né(e) le :</span><span> ${new Date(author.dob).toLocaleDateString('fr-FR')}</span></div>
            <div class="tr" ><span class="section-label">à/au/en :</span><span> ${author.placeofbirth}</span></div>
         `).join('<span style="font-weight: bold; margin-top: 10px; margin-bottom: 10px;">et</span>')}
  
            </div>
     <div class="header-info-block tenant-address-block">
                <strong class="section-title">LE${exitenants.length > 0 ? "S" : ""} LOCATAIRE${exitenants.length > 0 ? "S" : ""}</strong>
  
        ${exitenants.map(author => `
            <div class="tr" ><span class="section-label">${author.type != "morale" ? "M/Mme" : "Société"} :</span><span> ${author.type != "morale" ? `${author.firstname} ${author.lastname}` : `${author.denomination}`} </span></div>
            <div class="tr" ><span class="section-label">Domicilié(e) à :</span><span> ${author.address}</span></div> 
            <div class="tr" ><span class="section-label">Né(e) le :</span><span> ${new Date(author.dob).toLocaleDateString('fr-FR')}</span></div>
            <div class="tr" ><span class="section-label">à/au/en :</span><span> ${author.placeofbirth}</span></div>
        `).join('<span style="font-weight: bold; margin-top: 10px; margin-bottom: 10px;">et</span>')}
 
        </div>
        ${proccurarion.accesgivenTo && proccurarion.accesgivenTo.length > 0 ? `
     <div class="header-info-block tenant-address-block">
                <strong class="section-title">LE MANDATAIRE</strong>
              <div class="tr" ><span>Pour l’établissement du présent état des lieux, le(s) bailleur(s) a/ont mandaté:</span></div>
        ${proccurarion.accesgivenTo.map(author => `
            <div class="tr" ><span class="section-label">${author.type != "morale" ? "M/Mme" : "Société"} :</span><span> ${author.type != "morale" ? `${author.firstname} ${author.lastname}` : `${author.denomination}`} </span></div>
            <div class="tr" ><span class="section-label">Domicilié(e) à :</span><span> ${author.address}</span></div> 
            <div class="tr" ><span class="section-label">Né(e) le :</span><span> ${new Date(author.dob).toLocaleDateString('fr-FR')}</span></div>
            <div class="tr" ><span class="section-label">à/au/en :</span><span> ${author.placeofbirth}</span></div>
        `).join('<span style="font-weight: bold; margin-top: 10px; margin-bottom: 10px;">et</span>')}
 
        </div>` : ''}


        <!-- *************************************************************************************************************************************************************************************************** -->
           <div class="header-info-block property-address-block"> 
                <strong class="section-title">RELEVÉ DES COMPTEURS</strong>
           
             <table style="width:100%; border-collapse: collapse; margin: 20px 0;">
    <thead>
        <tr>
            <th>CATEGORIE</th>
            <th>MODE</th>
            <th>TYPE</th>
        </tr>
    </thead>
    <tbody>
        <tr class="heatingtr" style="height: 55px;padding: 8px;">
            <td>Mode de chauffage</td>
            <td>
                ${config.heatingTypes[data.meta.heatingType] ?? data.meta.heatingType}
            </td>
            <td> 
                ${config.heatingModes[data.meta.heatingMode] ?? data.meta.heatingMode}
            </td>
        </tr>
        <tr class="heatingtr" style="height: 55px;padding: 8px;">
            <td>Production d'eau chaude</td>
            <td>
                ${config.hotWaterTypes[data.meta.hotWaterType] ?? data.meta.hotWaterType}
            </td>
            <td>
                ${config.heatingWaterModes[data.meta.hotWaterMode] ?? data.meta.hotWaterMode}
            </td>
    </tbody>
</table>
         </div>  
        ${Object.entries(compteurs).map(([type, items]) => ` 
    <strong class="piece-name">${getcompteurName(type)}</strong>
    <table cellpadding="8" cellspacing="0" style="width:100%; border-collapse: collapse; margin-bottom: 30px;">
        ${type == "electricity" ?
                `<thead>
                <tr>
                    <th rowspan="3">NUMÉRO DE COMPTEUR</th>
                    <th colspan="4">RELEVÉ</th>
                    <th rowspan="3">OBSERVATION(S)</th>
                </tr>
                <tr>
                    <th colspan="2">ENTRÉE</th>
                    <th colspan="2">SORTIE</th>
                </tr>
                <tr> 
                    <th>Heures Pleines</th>
                    <th>Heures Creuses</th>
                    <th>Heures Pleines</th>
                    <th>Heures Creuses</th>
                </tr>
            </thead>`
                :
                `<thead>
                <tr>
                    <th rowspan="2">NUMÉRO DE COMPTEUR</th>
                    <th colspan="2">RELEVÉ</th>
                    <th rowspan="2">OBSERVATION(S)</th>
                </tr>
                <tr>
                    <th>ENTRÉE</th>
                    <th>SORTIE</th>
                </tr>
            </thead>`
            }
        <tbody>
            ${items.map(compteur => `
                <tr>
                    <td>${compteur.serialNumber ?? ""}</td>
                    ${type == "electricity" ?
                    `    <td>${compteur.initialReadingHp ?? ""}</td>
                         <td>${compteur.currentReadingHp ?? ""}</td>
                         <td>${compteur.initialReadingHc ?? ""}</td>
                         <td>${compteur.currentReadingHc ?? ""}</td>`
                    :
                    `<td>${compteur.initialReading ?? ""}</td>
                     <td>${compteur.currentReading ?? ""}</td>`
                }
                    <td class="observationcol" colspan="2">
                        <div class="observatiheberger">
                            <span class="section-label">${compteur.comment ?? ''}</span>
                            ${compteur.photos ? compteur.photos.map((p, i) => `
                                <span style="padding: 2px 2px;">
                                    <span class="photolabel">Photo ${++photoCounter.compteurs}</span>
                                </span>
                            `).join('') : ''}
                        </div>
                    </td>
                </tr>
            `).join('')}
        </tbody>
    </table>
`).join('')} 
   <div class="photo-container">
  ${(() => {
                photoCounter.compteurs = photoCounter.current;
                let photosHTML = '';

                // Iterate through each counter type
                Object.entries(compteurs).forEach(([type, items]) => {
                    // items[0] contains the array of counters for this type
                    items.forEach(compteur => {
                        if (compteur.photos && compteur.photos.length > 0) {
                            photosHTML += compteur.photos.map(p => {
                                photoCounter.current = photoCounter.compteurs;
                                const photoNumber = ++photoCounter.compteurs;
                                return `
              <div class="photo-block">
                <p class="photo-title">
                  <span>PHOTO ${photoNumber} -</span> ${compteur.name || type}
                </p>
                <p class="photo-desc">
                  Photo prise lors de l'état des lieux <span>de sortie</span>
                </p>
                <img src="${config.appUrl}/${p}" 
                     alt="Photo ${photoNumber}" 
                     style="width:100%; object-fit:cover; border-radius:6px;">
              </div>
            `;
                            }).join(' ');
                        }
                    });
                });

                return photosHTML;
            })()}
</div>  
    <!-- *************************************************************************************************************************************************************************************************** -->
    <div style="margin-bottom: 1px;" class="header-info-block property-address-block">
        <strong class="section-title">DETECTEUR DE FUMEE</strong>
    </div>
    <div class="safety-device-card">
        <h3 class="device-title">Détecteur de fumée</h3>

        <div class="device-status">
            <div class="status-item">
                <span class="status-label">Présence:</span>
                <span class="status-value presence"> ${data.meta.security_smoke == "yes" ? 'Oui' : 'Non'}</span>
            </div>
             ${!data.meta.security_smoke ? "" : data.meta.security_smoke == "no" ? '' : `<div class="status-item">
                <span class="status-label">Fonctionnel:</span>
                <div class="functionality-options">
                    <span class="option yes-option ${data.meta.security_smoke_functioning == "yes" ? 'selected' : ''}">
                        <span class="option-marker"></span>
                        Oui 
                    </span>
                    <span class="option no-option ${data.meta.security_smoke_functioning == "no" ? 'selected' : ''}">
                        <span class="option-marker"></span>
                        Non 
                    </span> 
                    <span class="option not-tested-option ${data.meta.security_smoke_functioning == "not_tested" ? 'selected' : ''}">
                        <span class="option-marker"></span>
                        Non testé
                    </span>
                </div>
            </div>`}
        </div> 
    </div>

    <!-- *************************************************************************************************************************************************************************************************** -->
    <div class="header-info-block property-address-block" style="margin-bottom: 10px;">
        <strong class="section-title">RESTITUTION DES CLÉS</strong>
    </div> 
           ${cledeportes.map(cle => ` 
<table cellpadding="8" cellspacing="0"
        style="width:100%; border-collapse: collapse; margin-bottom: 30px;">
        <thead>
            <tr>
                <th rowspan="2">TYPE DE CLÉ</th>
                <th colspan="2">NOMBRE</th>
                 <th rowspan="2">OBSERVATION(S)</th>
            </tr>
            <tr>
                <th>ENTRÉE</th>
                <th>SORTIE</th> 
            </tr>
        </thead>
        <tbody>  
            <tr>
                <td style="width: 300px;">${cle.name ?? ""}  </td> 
                <td ${fortenant == "entrance" && `class="contitionstate"`} > ${fortenant == "entrance" ? `
                    <span>${cle.count ?? ""}</span>
                         ` :
                    `<span></span>`}
                </td>  
                <td ${fortenant == "exit" && `class="contitionstate"`} > ${fortenant == "exit" ? `
                    <span>${cle.count ?? ""}</span>
                         ` :
                    `<span></span>`}
                </td>
                 <td class="observationcol" colspan="2" style="width: 150px;">
                    <div class="observatiheberger">
                        <span class="section-label">${cle.comment ?? ''}</span>
                        ${cle.photos.map((p, i) => ` <span style="padding: 2px 2px;"><span class="photolabel" >Photo ${++photoCounter.compteurs}</span></span> `)}
                    </div>
                  </td>
            </tr>   
        </tbody>  
    </table> 
            `).join('<span style="font-weight: bold; margin-top: 10px; margin-bottom: 10px;"> </span>')
            }
   
   <div class="photo-container">
          ${(() => {
                photoCounter.compteurs = photoCounter.current + 1;
                return cledeportes.map(cle => `
                                  ${cle.photos.map((p, i) => {
                    photoCounter.current = photoCounter.compteurs;
                    return ` 
 <div class="photo-block"> 
            <p class="photo-title"> <span>PHOTO ${(++photoCounter.compteurs)} - </span> ${cle.name} </p>
            <p class="photo-desc">Photo prise lors de l'état des lieux <span>de sortie</span></p>

            <img src="${config.appUrl}/${p}" alt="Photo 1"
                style="width:100%; object-fit:cover; border-radius:6px;">
        </div> `}).join(' ')} `).join('<span style="font-weight: bold; margin-top: 10px; margin-bottom: 10px;"> </span>')


            })()} 
    </div>

        <!-- *************************************************************************************************************************************************************************************************** -->

    <div style="margin-bottom: 10px;" class="header-info-block property-address-block"> <strong class="section-title">ÉTAT DES PIÈCES DU BIEN</strong> </div> 
        ${pieces.map(piece => ` 
            <strong class="piece-name">${piece.name}</strong>
<div class="tr" >

    ${piece.photos.length > 0 ?
                    ` <span class="section-label">Ont été prises les photos suivantes concernant la pièce en général :</span><span> <div class="observatiheberger">
                        ${piece.photos.map((p, i) => ` <span style="padding: 2px 2px;"><span class="photolabel" >Photo ${++photoCounter.compteurs}</span></span> `)}
                    </div> </span>` : ''
                }
</div>
<table cellpadding="8" cellspacing="0"
        style="width:100%; border-collapse: collapse; margin-bottom: 30px;">
 <thead>
            <tr>
                <th rowspan="2">ÉLÉMENT / ÉQUIPEMENT</th>
                <th colspan="2">NOMBRE</th>
                <th colspan="2">ÉTAT D'USURE</th>
                <th rowspan="2">OBSERVATION(S)</th>
            </tr>
            <tr>
                <th>ENTRÉE</th>
                <th>SORTIE</th>
                <th>ENTRÉE</th>
                <th>SORTIE</th>
            </tr>
        </thead>

        <tbody>
        
        
                  ${piece.things.map((thing, i) => {

                    return `
   <tr>
                <td>${thing.name ?? ""}  </td>
                <td>${thing.entrycount ?? ""}</td> 
                <td>${thing.count ?? "0"}</td>

                <td ${fortenant != "entrance" && `class="contitionstate"`} > ${fortenant == "entrance" ? `
                    <span class="condition-value ${thing.condition}" >${thing.condition ? getState(thing.condition) : ""}</span>
                    
                        ` :
                            `<span></span>`}
                </td>
                <td ${fortenant != "entrance" && `class="contitionstate"`} > ${fortenant != "entrance" ? `
                    <span  class="condition-value ${thing.condition}" >${thing.condition ? getState(thing.condition) : ""}</span>
                     
                        ` : `<span></span>`}
                </td>
                </td> 
                <td class="observationcol" >  
                    <div class="observatiheberger">
                        <span class="section-label">${[thing.comment ?? ''].join(', ')}</span>
                        <span style="margin-right:10px;" >${thing.testingStage ? `, ${getTestingStates(thing.testingStage)}` : ""}</span>
                        ${thing.photos.map((p, i) => ` <span style="padding: 2px 2px;"><span class="photolabel" >Photo ${++photoCounter.compteurs}</span></span> `).join(' ')}
                    </div>
                </td>
            </tr>
            `})}
      
        </tbody>  
    </table> 
            `).join('<span style="font-weight: bold; margin-top: 10px; margin-bottom: 10px;"> </span>')
            }
  


   <div class="photo-container">
          ${(() => {
                photoCounter.compteurs = photoCounter.current + 1;
                return pieces.map(piece => `
                                  ${piece.photos.map((p, i) => {
                    return `<div class="photo-block">
            <p class="photo-title"> <span>PHOTO ${(++photoCounter.compteurs)} - </span> ${piece.name} </p>
            <p class="photo-desc">Photo prise lors de l'état des lieux <span>de sortie</span></p>
             <img src="${config.appUrl}/${p}" alt="Photo 1"
                style="width:100%; object-fit:cover; border-radius:6px;">
        </div> `}).join(' ')} `)
            })()}
          ${(() => {
                return pieces.map(piece => {
                    return `${piece.things.map((thing, i) => {
                        return `${thing.photos.map((p, i) => {
                            photoCounter.current = photoCounter.compteurs;
                            return `<div class="photo-block">
            <p class="photo-title"> <span>PHOTO ${(++photoCounter.compteurs)} - </span> ${thing.name} </p>
            <p class="photo-desc">Photo prise lors de l'état des lieux <span>de sortie</span></p>
             <img src="${config.appUrl}/${p}" alt="Photo 1"
                style="width:100%; object-fit:cover; border-radius:6px;">
        </div> `}).join(' ')} `
                    }).join(' ')} `
                })
            })()}
    </div>

 <!-- *************************************************************************************************************************************************************************************************** -->
    <div style="margin-bottom: 1px;" class="header-info-block property-address-block">
        <strong class="section-title"> Commentaires et observations</strong>
    </div>
    <div class="safety-device-card">
                 ${data.meta.comments ? `<div class="device-observations">
                     <div class="observation-content">
                         <p class="photo-desc">${data.meta.comments ?? ""} </p>
                     </div>
                </div>` : ""}
        
    </div> 
       
         <!-- *************************************************************************************************************************************************************************************************** -->

    <div id="legitime_block" class="header-info-block tenant-address-block">
        <strong class="section-title">CONDITIONS GÉNÉRALES</strong>
        <div class="tr legitimetext" >
            <span>
                Les parties reconnaissent l'exactitude des présentes constatations sur l'état du logement, sous réserve du bon fonctionnement des canalisations (sanitaires, électriques, chauffage). Tout dysfonctionnement devra être signalé dans les dix jours, et dans le premier mois de la période de chauffe pour le chauffage.
            </span>
        </div>
        <div class="tr legitimetext" >
            <span> 
                Le présent état des lieux ne préjuge en rien de la validité du congé. Il est dressé et accepté contradictoirement entre les parties, fait partie intégrante du contrat de location et ne peut en être dissocié.
            </span>
        </div>
        <div class="tr legitimetext" >
            <span>
                Le locataire :
            </br>
            - Reconnaît avoir été informé que la régularisation des charges locatives interviendra ultérieurement.</br>
        - S’engage à souscrire un contrat d'entretien pour les équipements au gaz et à en justifier la révision annuelle. Il en va de même pour la climatisation et devra justifier de la révision chaque année.</br>
    - Le cas échéant, il devra procéder à un ramonage annuel de la cheminée.</br >
        - Déclare sur l'honneur être à jour de ses impôts locaux.</br>
            - S’engage à rembourser au mandataire du bailleur les frais de remise en état, conformément aux présentes constatations.</br >

              </span >
      </div >
      <div class="tr legitimetext" >
              <span>
              Le présent document est établi en deux exemplaires, dont un remis au locataire. Ce dernier reconnaît avoir communiqué son adresse e-mail pour recevoir un exemplaire du constat. A défaut, il lui sera adressé par voie postale.
              </span>
      </div>
      
      <div class="tr legitimetext" >
              <span>
              Le locataire reconnaît avoir lu le constat et le reconnaît exact. Sa signature figure en dernière page et en paraphe sur chaque page du document.  Les signataires aux présentes ont convenu du caractère probant et indiscutable des signatures y figurant pour être recueillies selon procédé informatique sécurisé au contradictoire des parties.    

              </span>
      </div>
      
      <div class="tr legitimetext" >
              <span>
              Dressé le ${establishedDate} sur place, ${data.document_address || 'Paris'}
              </span>
               
        </div>
        </div >

 
    <script>
        window.onload = function () {
            var element = document.getElementById('legitime_block');
            var rect = element.getBoundingClientRect();

const absoluteTop = window.scrollY + rect.top;
    const occupedHeight = absoluteTop + rect.height;

    const a4height = 1122; // 1 page A4 à 96dpi ≈ 1122px
    const bottomPadding = 40;
    const totalPageHeight = a4height + bottomPadding;

    const factor = occupedHeight / totalPageHeight;

    const decimals = factor % 1;
    const partialHeight = parseInt(decimals * totalPageHeight);
    const restHeight = totalPageHeight - partialHeight;

            element.insertAdjacentHTML('afterend',  \`<!-- *************************************************************************************************************************************************************************************************** -->
 
         <span class="section-title" style="display: block; margin-top: 50px; font-weight: bold;">SIGNATURES</span>

         <div class="signature-block" style="page-break-inside: avoid; margin-top: 2rem;">

        <div class="signatures-container"> 

            ${data.procuration != null ?
                `<div class="signature-item">
                <div style="display: flex; flex-direction: column; margin-bottom: 10px;">
                    <strong>Mandataire</strong>
                    <span>${data.mandataire.type == "morale" ? `${data.mandataire.denomination} [représenté(e) par ${data.mandataire.representant.firstname} ${data.mandataire.representant.lastname}]` : `${data.mandataire.firstname} ${data.mandataire.lastname}`}</span>
                </div>
                ${(signatures && signatures?.signatures?.[data.mandataire._id]) ? `<img src="data:image/png;base64,${signatures?.signatures?.[data.mandataire._id]?.path}" />` : "<span></span>"}
            </div>  
                ` :
                owners.map((owner) => {
                    return `
            <div class="signature-item"> 
                 <div style="display: flex; flex-direction: column; margin-bottom: 10px;">
                    <strong>Bailleur</strong> 
                    <span>${owner.type == "morale" ? `${owner.denomination} [représenté(e) par ${owner.representant.firstname} ${owner.representant.lastname}]` : `${owner.firstname} ${owner.lastname}`}</span>
                </div>
                ${(signatures && signatures?.signatures?.[owner._id]) ? `<img src="data:image/png;base64,${signatures?.signatures?.[owner._id]?.path}" />` : "<span></span>"}
                 ${signatures?.signatures?.[owner._id] ? `<span class="signature-date">Signé le <strong>${owner ? new Date(signatures?.signatures?.[owner._id]?.timestamp).toLocaleDateString('fr-FR') : ''}</strong></span>` : ""}
                <div class="selfiephotos"> ${owner.meta?.[data._id]?.photos ? owner.meta?.[data._id]?.photos.map((p) => { return `<img src="${config.appUrl}/${p}" alt="Selfie photo"  class="selfie-photo" />` }) : ""} </div>
            </div>  
            `})
            } 

            ${exitenants.map((tenant) => {
                return `
            <div class="signature-item"> 
                 <div style="display: flex; flex-direction: column; margin-bottom: 10px;">
                    <strong>Locataire </strong>
                    <span>${tenant.type == "morale" ? `${tenant.denomination} [représenté(e) par ${tenant.representant.firstname} ${tenant.representant.lastname}]` : `${tenant.firstname} ${tenant.lastname}`}</span>
                </div>
                ${(signatures && signatures?.signatures?.[tenant._id]) ? `<img src="data:image/png;base64,${signatures?.signatures?.[tenant._id]?.path}" />` : "<span></span>"}
                <span class="signature-date">Signé le <strong>${tenant ? new Date(signatures?.signatures?.[tenant._id]?.timestamp).toLocaleDateString('fr-FR') : ''}</strong></span>
                <div class="selfiephotos"> ${tenant.meta?.[data._id]?.photos ? tenant.meta?.[data._id]?.photos.map((p) => { return `<img src="${config.appUrl}/${p}" alt="Selfie photo"  class="selfie-photo" />` }) : ""} </div>
            </div>
            `}).join('')}  
        
        </div>
    </div> \`  
        );


        }
    </script>


</body >
</html > `;
    }
};