process.env.TZ = 'Europe/Paris';

global.localmachine = process.env?.SSH_CLIENT ? (process.env?.USER.includes("appnode") ? "remote2" : "remote") : process.cwd().includes("/home/juste") ? "home" : false;

// Importing required modules 
const express = require("express");
const session = require("express-session");
const dotenv = require("dotenv");
const bodyParser = require("body-parser");
const flash = require("connect-flash");
const path = require("path");
const MongoStore = require('connect-mongo');
const terminate = require("./config/terminate")
const errorHandler = require('./utils/error-handler');
let Config = require('./config/config')
const http = require("http")
const cors = require('cors');
const adminRoutes = require("./routes/adminRoutes");
const stripeapp = require("./routes/stripeRoutes");
const apiRoutes = require("./routes/apiRoutes");

// Configure dotenv
dotenv.config();

// Import database connection
require("./config/conn");

// Import flash middleware
const flashmiddleware = require('./config/flash');
const { backupWithMongodump, keepServeron } = require("./utils/backupdbs");
const { getUserDeviceInfo } = require("./utils/utils");
backupWithMongodump();
keepServeron();

// Create an instance of an Express application
const app = express();

// Configure session
app.use(session({
    secret: process.env.SESSION_SECRET_KEY,
    resave: false,
    saveUninitialized: false,
    store: MongoStore.create({
        mongoUrl: process.env.DB_CONNECTION,
        ttl: 3600
    })
}));

// Use flash middleware
app.use(flash());
app.use(flashmiddleware.setflash);

// Configure body-parser for handling form data
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
// Enable CORS for all routes
app.use(cors({
    origin: ['https://etatdeslieux.jatai.fr', "https://jatadmin.adidome.com", 'http://localhost:38803', 'http://localhost:5000'],
    methods: '*',
    credentials: true
}));

// Configure static files
app.use('/api/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/.well-known', express.static(path.join(__dirname, '.well-known')));

// Routes for the Admin secti
app.use("/", adminRoutes);
app.use("/etat-des-lieux", adminRoutes);

// Routes for the API section

// Routes for the Admin Api section  
// app.use('/admin/api', require('./routes/adminApiRoutes'));

app.use("/api/stripe", stripeapp);
app.use("/api", apiRoutes);

app.use((req, res) => {
    let deviceInfo = getUserDeviceInfo(req);
    global.logfile({
        content: `${req.path}-${req.method}-${req.originalUrl}`,
        deviceInfo
    });
    if (req.path == "/resetpassword") {
        let thenewUrl = `${Config.appUrl}/#/resetpassword?email=${encodeURIComponent(req.query.email)}&otp=${encodeURIComponent(req.query.otp)}`;
        return res.redirect(thenewUrl);
    }
    return res.status(404).json({
        message: `Route ${req.method} ${req.originalUrl} introuvable`,
        code: 404
    });
});
app.use(errorHandler);

const server = http.createServer(app);

server.on("error", (e) => errorHandler(e, server, Config.port));

const exitHandler = terminate(server, {
    coredump: false,
    timeout: 500,
});

process.on("uncaughtException", exitHandler(1, "Unexpected Error"));
process.on("unhandledRejection", exitHandler(1, "Unhandled Promise"));
process.on("SIGTERM", exitHandler(0, "SIGTERM"));
process.on("SIGINT", exitHandler(0, "SIGINT"));



server.listen(Config.port, () => {
    console.log("server is started :", process.env.SERVER_PORT);
})

