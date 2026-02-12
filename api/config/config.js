require('dotenv').config();
const { normalizePort } = require('./init');

let port = normalizePort(443)

if (global.localmachine != "remote2") {
  port = normalizePort(process.env.SERVER_PORT);
}

module.exports = {
  port,
  dbName: process.env.DB_NAME,
  secret: process.env.JWT_SECRET_KEY || '',
  supportEmail: '',
  nodemailer: {
    from: ``,
  },
  nodemailerTransport: {
    service: undefined,
    host: '',
    port: 587,
    secure: false,
    auth: {
      user: '',
      pass: '',
    },
  },
  rootUser: {
    username: process.env.ROOT_USER_USERNAME,
    email: process.env.ROOT_USER_EMAIL,
    password: process.env.ROOT_USER_PASSWORD,
    firstName: process.env.ROOT_USER_FIRST_NAME,
    lastName: process.env.ROOT_USER_LAST_NAME,
    phone: process.env.PHONE,
  },
  defaultPiece: {
    "name": "Salon",
    "type": "livingRoom",
    "area": 1,
    "count": 1,
    "order": 2,
    "meta": {
      "icon": "assets/images/static_images/icons/sofa.png"
    },
    "things": [
      // {
      //   "name": "Mur",
      //   "type": "wall",
      //   "condition": "good",
      //   "photos": [],
      //   "order": 0
      // },
      // {
      //   "name": "Plafond",
      //   "type": "ceiling",
      //   "condition": "good",
      //   "photos": [],
      //   "order": 1
      // }
    ],
    "photos": [],
    "comment": ""
  },
  nominatim: {
    api_url: "nominatim.openstreetmap.org",
    tolerable_request_second: 1050,
  },
  appUrl: process.env.APP_URL || "https://etatdeslieux.jatai.fr",
  appName: process.env.APP_NAME || "JATAI ÉTAT DES LIEUX",
  tempFilePath: './public/documents/temp/',
  token: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2ODIxNDU3OTQ1MjQ1ZDgyMWY1YWMxNGQiLCJlbWFpbCI6Im1lZGlzYWRpZG9AZ21haWwuY29tIiwibGV2ZWwiOiJzdGFuZGFyZCIsImZpcnN0TmFtZSI6IlBhbWVsYSIsImxhc3ROYW1lIjoiQVNJU08iLCJmdWxsTmFtZSI6IlBhbWVsYSBBU0lTTyIsInBob25lIjoiODg4ODg4ODg4OCIsImNvdW50cnlfY29kZSI6IiszMyIsImlzQmxvY2tlZCI6dHJ1ZSwibGFzdE9ubGluZSI6bnVsbCwidXNlcl9ET0IiOm51bGwsImZhdm9yaXRlcyI6W10sImltYWdlVXJsIjpbXSwiYWRkcmVzcyI6IiIsImdlbmRlciI6IkZlbWFsZSIsIm1ldGEiOnt9LCJhYm91dCI6bnVsbCwidHlwZSI6Im93bmVyIiwiaXRlbWFjY2VzcyI6bnVsbCwidmVyaWZpZWRBdCI6IjIwMjUtMDUtMTJUMDA6NTc6NTQuNTQ1WiIsImlhdCI6MTc0NzI0MzI5MiwiZXhwIjoxNzUyNDI3MjkyfQ.v2dJtbPXc3K8WoxVghp_G83plgkOJLz9lUYBJIPm5xg`,
  heatingTypes: {
    "gas": "Gaz",
    "electric": "Électrique",
    "oil": "Fioul",
    "other": "Autre"
  },
  heatingModes: {
    "individual": "Individuel",
    "collective": "Collectif",
    "not_applicable": "Pas de chauffage"
  },
  heatingWaterModes: {
    "individual": "Individuel",
    "collective": "Collectif",
    "not_applicable": "Pas d'eau chaude"
  },
  hotWaterTypes: {
    "gas": "Gaz",
    "electric": "Électrique",
    "oil": "Fioul",
    "other": "Autre"
  },
  defaultStates: {
    "good": "Bon Etat",
    "average": "Etat Moyen",
    "bad": "Mauvais Etat",
    "new": "Neuf",
    "not_applicable": "Non Applicable",
    "not_applicable": "Non Applicable",
  },
  defaultTestingStates: {
    "ok": "Fonctionne",
    "not_working": "Ne fonctionne pas",
    "not_testes": "Non testé",
    "unknown": "N/A",
  },
  compteurs: {
    "electricity": "Électricité",
    "gas": "Gaz",
    "cold_water": "Eau froide",
    "hot_water": "Eau chaude",
    "thermal_energy": "Énergie thermique",
    "other": "Autre"
  },
  paymentMethods: {
    "card": "Carte Bancaire",
    "paypal": "PayPal",
    "stripe-link": "Stripe Web",
    "stripe": "Stripe",
    "bank_transfer": "Virement Bancaire",
    "cash": "Espèces"
  },
  roles: {
    "auteur": "Auteur",
    "owner": "Bailleur",
    "tenant": "Locataire",
    "admin": "Administrateur",
    "super_admin": "Super Administrateur",
    "root": "Root",
    "owner_representative": "Représentant du Bailleur",
    "tenant_representative": "Représentant du Locataire",
    "mandataire": "Mandataire",
  },
  pushNotification: {
    android: {
      priority: 'high',
      notification: {
        sound: 'default',
        channelId: 'high_importance_channel',
        icon: 'ic_notification',
        color: '#f45342',
      }
    },
    apns: (title, body) => {
      return {
        payload: {
          aps: {
            alert: {
              title,
              body
            },
            sound: 'default',
            badge: 1
          }
        }
      }
    }
  }
};
