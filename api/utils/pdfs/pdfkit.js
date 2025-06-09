module.exports = {
    generateEntrantProcurationHTML: (data, fortenant, signature) => {
        const owners = data.owners;
        let { meta: signatures } = data;


        const tenants = [fortenant == "entrant" ? data.entrantenants[0] : data.exitenants[0]];
        const property = data.propertyDetails;
        const date = new Date(data.estimatedDateOfReview).toLocaleDateString('fr-FR');
        const today = new Date().toLocaleDateString('fr-FR');

        const ownerText = owners.length > 1 ?
            `Nous soussignés: ${owners.map((owner, i) => `<strong>${owner.denomination ? `${owner.denomination} [représenté(e) par ${owner.representant.firstname} ${owner.representant.lastname}]` : `${owner.firstname} ${owner.lastname}`}</strong> <span>Né(e) le <strong>${new Date(owner.dob).toLocaleDateString('fr-FR')}</strong> à <strong>${owner.placeofbirth ?? owner.representant.placeofbirth}</strong> <span>Domicilié(e) à <strong>${owner.address}</strong></span>`).join('<br /><br />et ')} ` :
            `Je soussigné(e) ${owners[0].denomination ? `${owners[0].denomination} [représenté(e) par ${owners[0].representant.firstname} ${owners[0].representant.lastname}]` : `${owners[0].firstname} ${owners[0].lastname}`}  <span>Né(e) le <strong>${new Date(owners[0].dob).toLocaleDateString('fr-FR')}</strong> à <strong>${owners[0].placeofbirth ?? owners[0].representant.placeofbirth}</strong> <span>Domicilié(e) à <strong>${owners[0].address}</strong></span>`;

        // Gestion du singulier/pluriel pour les locataires
        const tenantText = tenants.length > 1 ?
            `${tenants.map(t => `${t.firstname} ${t.lastname}`).join(' et ')}` :
            `${tenants[0].firstname} ${tenants[0].lastname}`;

        // Gestion du "mon/notre" logement 
        const propertyPossessive = owners.length > 1 ? 'notre' : 'mon';

        // Construction des blocs Bailleurs
        const ownersHTML = owners.map(owner => `
            <div class="owner-address-block">
                <strong>${owners.length > 1 ? 'Mandant' : 'Mandant'}: ${owner.denomination ? `${owner.denomination} [représenté(e) par ${owner.representant.firstname} ${owner.representant.lastname}]` : `${owner.firstname} ${owner.lastname}`}</strong>
                 <span>${owner.address}</span>
                <span>${owner.phone ? `${owner.phone} | ` : ''}${owner.email}</span>
            </div>
        `).join('');

        // Construction des blocs locataires
        const tenantsHTML = tenants.map(tenant => `
            <div class="tenant-address-block">
                <strong>${tenant.firstname} ${tenant.lastname}</strong>
                 <span>Né(e) le ${new Date(tenant.dob).toLocaleDateString('fr-FR')} à ${tenant.placeofbirth}</span>
                <span>Domicilié(e) à ${tenant.address}</span>
            </div>
        `).join('');

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
            width: ${owners.length > 1 ? '45%' : '45%'};
            height: 230px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;                 
        }
    </style>
</head>
<body>
    <div class="header-block">
        <div class="titleblock">
            <span class="maintitle">PROCURATION POUR ÉTAT DES LIEUX</span>
            <span>Procuration contradictoire à annexer au contrat de location dont il ne peut être dissocié.</span>
        </div>
        <img src="https://jatai.fr/wp-content/uploads/2024/09/cropped-Copy-of-Jatai.png" class="logo" alt="Logo">
    </div>
     ${ownersHTML} 
     <div style="display:flex;justify-content: space-between; ">
        <div style="min-width: 250px;"> </div>

         <div>${tenantsHTML} </div>
     </div>
    
    <p>Madame, Monsieur,</p>

    <p>Ne pouvant ${owners.length > 1 ? 'nous' : 'me'} présenter le <span class="text-underline">${date}</span> à l'état des lieux ${fortenant != "entrant" ? "d'entrée" : "de sortie"} concernant ${propertyPossessive} logement situé au :</p>

    <p><strong>${property.address}</strong><br>
    ${property.complement || ''}<br>
    ${property.floor} - ${property.surface}m² (${property.roomCount} pièces)</p>

            <p class="body-text">${ownerText} <br /><br />${owners.length > 1 ? 'donnons' : 'donne'} par la présente, pouvoir à
                    :</p>

                <p class="body-text"><strong>${tenantText}</strong>, ${tenants.length > 1 ? 'nés' : 'né(e)'} à
                    ${tenants.map(t => t.placeofbirth).join('<strong> et </strong>')}, le${tenants.length > 1 ? 's' :
                ''} ${tenants.map(t => new Date(t.dob).toLocaleDateString('fr-FR')).join('<strong> et </strong>')},
                    demeurant à ${tenants.map(t => t.address).join('<strong> et </strong>')}, pour ${owners.length > 1 ?
                'nous' : 'me'} représenter lors de cet état des lieux.</p>


    <p>À cet effet, cette${tenants.length > 1 ? 's personne' : ' personne'} pourra${tenants.length > 1 ? 'ont' : ''} signer, pour ${owners.length > 1 ? 'notre' : 'mon'} compte et en ${owners.length > 1 ? 'notre' : 'mon'} nom, tout formulaire et/ou document nécessaire à la bonne exécution de cet état des lieux.</p>

    <div class="signature-block">
        <span>Fait à ${data.document_address || 'Paris'}, le ${today}</span>

        <div class="signatures-container">
            ${owners.map((owner) => {
                    return `
            <div class="signature-item">
                ${(signatures && signatures?.signatures?.[owner._id]) ? `<img src="data:image/png;base64,${signatures?.signatures?.[owner._id]?.path}" />` : "<span></span>"}
                <div>
                    <div class="signature-line"></div>
                    <p>Signature du${owners.length > 1 ? ' mandant' : ' mandant'}<br>
                    ${owner.denomination ? `${owner.denomination} [représenté(e) par ${owner.representant.firstname} ${owner.representant.lastname}]` : `${owner.firstname} ${owner.lastname}`}</p>
                </div>  
            </div>
            `}).join('')} 
        </div>
    </div> 
</body>
</html>`;
    }
};