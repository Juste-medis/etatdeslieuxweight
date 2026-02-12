const mongoose = require('mongoose');
const fs = require('fs');
const path = require('path');
const connectUrl = process.env.DB_CONNECTION
const cron = require('node-cron');

const { exec } = require('child_process');
// Connect to MongoDB

mongoose.set('strictQuery', false);
mongoose
    .connect(connectUrl, {
        ssl: global?.localmachine == "remote2" ? true : false,
        family: 4,
        dbName: "etatdeslieux",
        authSource: "etatdeslieux",
    })

// Define a function to backup a collection
async function backupCollection(collectionName) {
    const data = await mongoose.connection.db.collection(collectionName).find({}).toArray();
    const backupDir = path.join(__dirname, 'backups', new Date().toISOString().slice(0, 19).replace('T', '_'));
    if (!fs.existsSync(backupDir)) {
        fs.mkdirSync(backupDir, { recursive: true });
    }
    const backupPath = path.join(backupDir, `${collectionName}.json`);
    fs.writeFileSync(backupPath, JSON.stringify(data));
    console.log(`Backup completed for ${collectionName}: ${backupPath}`);
}

// Backup all collections
async function backupAllCollections() {
    const collections = await mongoose.connection.db.listCollections().toArray();
    for (const collection of collections) {
        await backupCollection(collection.name);
    }
}

// second otion 

// Backup directory
const backupWithMongodump = (force = false) => {

    const backupDir = path.join(__dirname, 'backups2', new Date().toISOString().slice(0, 10));
    // Create backup directory if it doesn't exist
    if (!fs.existsSync(backupDir)) {
        fs.mkdirSync(backupDir, { recursive: true });
    }

    const backupTask = () => {
        // Run mongodump
        exec(`mongodump --uri="${connectUrl}" --out="${backupDir}"`, (error, stdout, stderr) => {
            if (error) {
                console.error(`Backup error: ${error.message}`);
                return;
            }
        });
    }
    cron.schedule('0 2 * * *', backupTask);

    // Initial backup on startup if today 's backup doesn't exist
    if (!fs.existsSync(backupDir) || force) {
        backupTask();
    }

}

// Backup directory
const keepServeron = (force = false) => {

    const backupTask = async () => {
        try {
            const superagent = require("superagent");
            setTimeout(async () => {
                let url = `https://visionrec.adidome.com/health`;
                try {
                    infos = superagent
                        .get(url)
                        .query({
                            "reviewId": "683baed4583391769a085a0d",
                            "section": "preview",
                        })
                        .set("accept", "*/*")
                        .set("Content-Type", "application/json")
                        .set("User-Agent", "yambro").then(res => {
                            global.logfile({
                                keeper: `Keep server on success ping to ${url}`,
                                content: res.text
                            });
                        });
                } catch (error) {
                    console.log(error);
                    throw "search_failed";
                }
            }, 3000);
        } catch (error) {
            console.error(`Keep server on error: ${error.message}`);
            return;
        }
    }
    cron.schedule('*/15 * * * *', backupTask);

}

const restoreFromBackup = async (backupPath) => {

    exec(`mongorestore --uri="${connectUrl}" --drop "${backupPath}"`, (error, stdout, stderr) => {
        if (error) {
            console.error(`Restore error: ${error.message}`);
            return;
        }
        console.log('Database restored successfully from backup.');
    });
}
// restoreFromBackup(path.join(__dirname, 'backups2', '2025-10-17'));
module.exports = {
    backupCollection,
    backupAllCollections,
    backupWithMongodump,
    restoreFromBackup,
    keepServeron
};