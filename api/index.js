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
const fs = require("fs")
const http = require("http")
const https = require('https');
const httpPort = 80;
const httpsPort = 443;
const cors = require('cors');


// Configure dotenv
dotenv.config();

// Import database connection
require("./config/conn");

// Import flash middleware
const flashmiddleware = require('./config/flash');

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
    origin: ['https://jataietatdeslieu.adidome.com', 'http://localhost:37859'],
    methods: '*',
    credentials: true
}));

// Configure static files
app.use('/api/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Routes for the Admin section
const adminRoutes = require("./routes/adminRoutes");
app.use("/", adminRoutes);
app.use("/etat-des-lieux", adminRoutes);

// Routes for the API section
const apiRoutes = require("./routes/apiRoutes");

// Routes for the Admin Api section
// app.use('/admin/api', require('./routes/adminApiRoutes'));


app.use("/api", apiRoutes);
app.use(errorHandler);


//create server
const options = {
    key: fs.readFileSync(Config.opkey),
    cert: fs.readFileSync(Config.opcert),
};

const server = http.createServer(app);
// if (global.localmachine == "remote2") {
//     http.createServer((req, res) => {
//         res.writeHead(301, { "Location": "https://" + req.headers.host + req.url });
//         res.end();
//     }).listen(httpPort, () => {
//         console.log(`HTTP -> HTTPS redirection active sur le port ${httpPort}`);
//     });

// }

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

