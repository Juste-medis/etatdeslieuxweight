// Importing required modules 
const mongoose = require("mongoose");
let Config = require('./config')
const userModel = require("../models/userModel");
const settingModel = require("../models/settingModel");
const bcrypt = require("bcryptjs");
const { createLogger, format, transports } = require("winston");
const { MongoClient } = require('mongodb');
const PieceSchema = require("../models/pieceModel")

const connectUrl = process.env.DB_CONNECTION
const mongooseConnect = () => {
    let connecting = setTimeout(() => console.log('Connecting to DB...'), 1000);
    //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
    const mongoose = require('mongoose');

    mongoose.set('strictQuery', false);
    mongoose
        .connect(connectUrl, {
            ssl: global?.localmachine == "remote2" ? true : false,
            family: 4,
            dbName: "etatdeslieux",
            authSource: "etatdeslieux",
        })
        .then(async () => {
            clearTimeout(connecting);
            const { username, email, password, firstName, lastName, phone } = Config.rootUser;

            userModel.findOne({ email }).then((user) => {
                if (!user)
                    bcrypt
                        .hash(password, 10)
                        .then((hash) => new userModel({
                            name: username, email, phone, password: hash, firstName, lastName, level: 'superroot', verifiedAt: new Date()
                        }).save());
                else
                    bcrypt
                        .hash(password, 10)
                        .then((hash) =>
                            userModel.findOneAndUpdate(
                                { email },
                                { $set: { username, email, phone, password: hash, firstName, lastName, level: 'superroot', verifiedAt: new Date() } },
                            ),
                        );
            });
            // Check if default piece exists, if not create it
            const defaultPiece = Config.defaultPiece;
            // let defaultThingOne = defaultPiece.things[0];
            // let defaultThingTwo = defaultPiece.things[1];

            // let foundDefaultThingOne = await ThingSchema.findOne({ name: defaultThingOne.name, type: defaultThingOne.type, condition: defaultThingOne.condition });
            // let foundDefaultThingTwo = await ThingSchema.findOne({ name: defaultThingTwo.name, type: defaultThingTwo.type, condition: defaultThingTwo.condition });
            let foundedPiece = await PieceSchema.findOne({ name: defaultPiece.name, type: defaultPiece.type, area: defaultPiece.area, comment: defaultPiece.comment });

            settingModel.findOne({ name: 'defaultPiece' }).then(async (setting) => {
                if (!setting || !foundedPiece) {
                    // if (!foundDefaultThingOne) {
                    //     foundDefaultThingOne = await new ThingSchema(defaultThingOne).save();
                    // }
                    // if (!foundDefaultThingTwo) {
                    //     foundDefaultThingTwo = await new ThingSchema(defaultThingTwo).save();
                    // }
                    if (!foundedPiece) {
                        foundedPiece = await new PieceSchema({
                            ...defaultPiece,
                            things: []
                        }).save();
                    }
                    new settingModel({
                        key: 'defaultPiece', value: foundedPiece._id, name: 'defaultPiece', description: 'Default piece for new properties', isActive: true, options: [], meta: {}
                    }).save();
                }
            });
            const client = new MongoClient(connectUrl);
            client.connect().then(() => {
                global.dbo = client.db(Config.dbName);
            })
            console.log('Connected to DB');
        })
        .catch((err) => {
            console.log(err);
            clearTimeout(connecting);
            console.log('Unable to connect to DB');
            console.log('Retrying in 10 seconds');
            setTimeout(mongooseConnect, 10 * 1000);
        });
    //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
};
function attachlogger() {
    global.logger = createLogger({
        transports: [
            new transports.File({
                filename: "logs/server.log",
                format: format.combine(
                    format.timestamp({ format: "MMM-DD-YYYY HH:mm:ss" }),
                    format.align(),
                    format.printf(
                        (info) => `${info.level}: ${[info.timestamp]}: ${info.message}`
                    )
                ),
            }),
            // new transports.MongoDB({
            //   level: "error",
            //   db: uri,
            //   options: {
            //     useUnifiedTopology: true,
            //     authMechanism: "SCRAM-SHA-1",
            //     authSource: "admin",
            //   },
            //   collection: "server_logs",
            //   format: format.combine(format.timestamp(), format.json()),
            // }),
        ],
    });
}

mongooseConnect();
attachlogger();
require('./firebaseinit.js');