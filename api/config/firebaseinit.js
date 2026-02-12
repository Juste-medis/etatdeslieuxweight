// server/firebase-admin.js
const admin = require('firebase-admin');

// Téléchargez le fichier de configuration depuis Firebase Console
// Project Settings → Service Accounts → Generate New Private Key
const serviceAccount = require('../firebase-service-account.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

module.exports = admin;