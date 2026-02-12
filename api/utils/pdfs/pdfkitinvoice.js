const config = require("../../config/config");

module.exports = {
    generateInvoicePdfHtml: (transaction, fortenant) => {
        let tauxRate = 0.2;
        const getHtPrice = (price) => {
            return (price / (1 + tauxRate)).toFixed(5);
        }
        let totalHt = 0;
        const hasCoupon = transaction.hasCoupon || false;
        //couponAmount without "0" leading
        const couponAmount = hasCoupon ? parseFloat(transaction.couponAmount).toFixed(2) : '0.00';

        const remiseHt = hasCoupon ? getHtPrice(couponAmount) : 0.00;

        global.writeToFile(JSON.stringify(transaction, null, 2));

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

        .medium-title,
        .tableheader {
            color: #1B1B1C;
            font-family: Verdana, sans-serif;
            font-style: normal;
            font-weight: bold;
            text-decoration: none;
            font-size: 10pt;
            margin-top: 16px;
            margin-bottom: 4px;
            display: block;
        }
            .d-column {
            display: flex;
            flex-direction: column;
        .document-label {
  text-align: left;
  font-weight: bold;
}

.document-value {
  text-align: right;
}
     </style>
</head>
<body>
    <div class="header-block">
        <div class="titleblock"> </div>
        <img src="${config.appUrl}/assets/media/logos/rocketdeliveries.png" class="logo" alt="Logo">
    </div>


    <div class="owner-address-block">
                <strong style="font-size: 18px;" >Facture</strong>
                <span>Facture numéro : ${transaction.transactionId}</span>
                <span>Date: ${transaction.transactionDate}</span>
            </div>
    <div class="header-block" style="margin-top: 35px;">

        <div class="titleblock">
            <span class="maintitle"> JATAI </span>
            <span>58 RUE DE MONCEAU</span>
            <span>75008 PARIS</span>
            <span>France</span>
        </div>

        <div class="titleblock">
            <span class="maintitle"> Facturé à </span>
            <span> ${transaction.userName || 'Nom du client'}</span>
            <span>${transaction.userAddress || 'France'}</span>
         </div>
     </div>
    
    <table style="border-collapse:collapse; margin-top: 24px; width: 100%;" cellspacing="0">
        <tr style="height:19pt">
            <td style="width:178pt">
                <p class="tableheader" style="padding-left: 2pt;text-indent: 0pt;text-align: left;">Description</p>
            </td>
            <td style="width:76pt">
                <p class="tableheader" style="padding-right: 25pt;text-indent: 0pt;text-align: right;">Quantité</p>
            </td>
            <td style="width:123pt">
                <p class="tableheader" style="padding-right: 22pt;text-indent: 0pt;text-align: right;">Prix unitaire HT
                </p>
            </td>
            <td style="width:65pt">
                <p class="tableheader" style="padding-right: 2pt;text-indent: 0pt;text-align: right;">Total HT</p>
            </td>
        </tr>
        ${transaction.computedDispersion.map(item => {
            totalHt += parseFloat(getHtPrice(item.price));
            return `
                    <tr style="height:36pt">
            <td style="width:178pt">
                <p class="s2" style="padding-left: 2pt;padding-right: 9pt;text-indent: 0pt;line-height: 17pt;text-align: left;">
                    ${item.name}</p>
            </td>
            <td style="width:76pt">
                <p class="s2" style="padding-top: 9pt;padding-right: 25pt;text-indent: 0pt;text-align: right;">${item.quantity}</p>
            </td>
            <td style="width:123pt">
                <p class="s2" style="padding-top: 9pt;padding-right: 22pt;text-indent: 0pt;text-align: right;">${item.price > 0 ? getHtPrice((item.price / item.quantity)) : "0"} €</p>
            </td>
            <td style="width:65pt">
                <p class="s2" style="padding-top: 9pt;padding-right: 2pt;text-indent: 0pt;text-align: right;"> ${getHtPrice((item.price))} €</p>
            </td>
        </tr> 
                           `}).join('')
            }

    </table>
    <div style="display: flex; justify-content: space-between; margin-top: 16px;">
        <span></span>
      <table style="border-collapse:collapse; margin-left:auto; font-family: Verdana, sans-serif; font-size:10pt; color:#040C28;">
  <tr><td style="padding:2pt 20pt 2pt 0;"><strong>Sous Total HT:</strong></td><td style="text-align:right;">${totalHt.toFixed(2)} €</td></tr>
  <tr><td style="padding:2pt 20pt 2pt 0;"><strong>Remise HT:</strong></td><td style="text-align:right;">- ${parseFloat(remiseHt).toFixed(2)} €</td></tr>
  <tr><td style="padding:2pt 20pt 2pt 0;"><strong>Total HT:</strong></td><td style="text-align:right;">${(totalHt - parseFloat(remiseHt)).toFixed(2)} €</td></tr>
  <tr><td style="padding:2pt 20pt 2pt 0;"><strong>TVA 20%:</strong></td><td style="text-align:right;">${(transaction.totalAmount - (totalHt - remiseHt)).toFixed(2)} €</td></tr>
  <tr><td style="padding:4pt 20pt 2pt 0; font-weight:700;"><strong>Total TTC:</strong></td><td style="text-align:right; font-weight:700;">${transaction.totalAmount} €</td></tr>
</table>
    </div>

    <div class="d-column" style="margin-top: 32px;">
        <span class="document-identifier">Facture réglée le ${transaction.completedAt ?? transaction.transactionDate} </span>
        <span class="document-identifier">Par carte bancaire</span>
    </div>
    
</body>
</html>`;
    }
};