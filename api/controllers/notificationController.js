//  Importing models
const notificationModel = require("../models/notificationModel");
const currencyTimeZoneModel = require("../models/currencyTimezoneModel");
const userNotificationModel = require("../models/userNotificationModel");

// Import Firebase Admin SDK
const firebaseAdmin = require('../config/firebaseinit');
const config = require("../config/config");

// Load and render the view for notification
const loadNotification = async (req, res) => {

    try {

        // fetch all notification
        const notifications = await notificationModel.find({ recipient: "Admin" }).sort({ createdAt: -1 });

        // Update the notifications to mark them as read
        notifications.forEach(async (notification) => {
            notification.is_read = true;
            await notification.save();
        });

        // fetch timezone
        const timezones = await currencyTimeZoneModel.findOne({}, { timezone: 1 })

        return res.render("notification", { notifications, timezones });

    } catch (error) {
        console.log(error.message);
    }
}

// get all notification
const notification = async (req, res) => {

    try {

        // fetch all latest notification
        const notifications = await notificationModel.find({ recipient: "Admin" }).sort({ createdAt: -1 }).limit(10);

        // fetch store
        const timezones = await currencyTimeZoneModel.findOne({}, { timezone: 1 })

        const result = {
            notifications: notifications,
            timezones: timezones
        };

        return res.json(result);

    } catch (error) {
        console.log(error.message);
    }
}

// Stockage en mémoire (remplacez par une base de données en production)
const notificationHistory = [];

const registerToken = async (req, res) => {
    const user = req.user, userId = user?._id;

    try {
        const { fcmToken } = req.body;
        if (!userId || !fcmToken) { return res.status(400).json({ success: false, error: 'Paramètres manquants', required: ['userId', 'fcmToken'] }); }
        // Vérifier la validité du token (optionnel) 
        await userNotificationModel.findOneAndUpdate(
            { userId: userId },
            { registrationToken: fcmToken, deviceId: req.body.deviceId || 'unknown', userEmail: user?.email || '' },
            { upsert: true, new: true }
        );

        res.json({ status: true, message: 'Token enregistré avec succès', userId, tokenPreview: `${fcmToken.substring(0, 20)}...`, });

    } catch (error) {
        console.error('❌ Erreur enregistrement token:', error);
        res.status(500).json({
            success: false,
            error: 'Erreur interne du serveur',
            details: error.message
        });
    }
}
const getNotifications = async (req, res) => {
    const user = req.user, userId = user?._id, userEmail = user?.email;
    try {
        if (!userId) { return res.status(400).json({ success: false, error: 'Paramètres manquants', required: ['userId'] }); }

        // Pagination
        const page = Math.max(parseInt(req.query.page, 10) || 1, 1);
        const limit = Math.min(Math.max(parseInt(req.query.limit, 10) || 20, 1), 100);
        const skip = (page - 1) * limit;

        const query = { recipient: userEmail };

        const [total, notifications] = await Promise.all([
            notificationModel.countDocuments(query),
            notificationModel.find(query).sort({ createdAt: -1 }).skip(skip).limit(limit)
        ]);

        const totalPages = Math.max(Math.ceil(total / limit), 1);

        res.json({
            status: true,
            data: notifications,
            pagination: {
                total,
                page,
                limit,
                totalPages,
                hasNextPage: page < totalPages,
                hasPrevPage: page > 1
            }
        });
    } catch (error) {
        console.error('❌ Erreur récupération notifications:', error);
        res.status(500).json({
            success: false,
            error: 'Erreur interne du serveur',
            details: error.message
        });
    }
}

const unregisterToken = async (req, res) => {
    const user = req.user, userId = user?._id;

    try {
        const { fcmToken } = req.body;
        if (!userId || !fcmToken) { return res.status(400).json({ success: false, error: 'Paramètres manquants', required: ['userId', 'fcmToken'] }); }
        // Supprimer le token de la base de données
        await userNotificationModel.findOneAndDelete({ userId: userId, registrationToken: fcmToken });
        res.json({ status: true, message: 'Token supprimé avec succès', userId, tokenPreview: `${fcmToken.substring(0, 20)}...`, });

    } catch (error) {
        console.error('❌ Erreur suppression token:', error);
        res.status(500).json({
            success: false,
            error: 'Erreur interne du serveur',
            details: error.message
        });
    }

}

const sendNotification = async (req, res) => {
    try {
        const { userId, title, body, data = {}, imageUrl, clickAction } = req.body;

        console.log(`📤 Envoi notification - User: ${userId}, Titre: "${title}"`);

        // Validation
        if (!userId || !title || !body) { return res.status(400).json({ success: false, error: 'Paramètres manquants', required: ['userId', 'title', 'body'] }); }

        // Récupérer le token de l'utilisateur
        const userCredentials = await userNotificationModel.findOne({ userId: userId });
        if (!userCredentials) { return res.status(404).json({ success: false, error: 'Utilisateur non trouvé', userId, }); }

        const fcmToken = userCredentials.registrationToken;

        if (!fcmToken) { return res.status(404).json({ success: false, error: 'Utilisateur non trouvé', }); }

        // Construction du message
        const message = {
            token: fcmToken,
            notification: {
                title: title,
                body: body,
                ...(imageUrl && { image: imageUrl })
            },
            data: {
                ...data,
                timestamp: new Date().toISOString(),
                userId: userId.toString()
            },
            android: {
                priority: 'high',
                notification: {
                    sound: 'default',
                    channelId: 'high_importance_channel',
                    icon: 'ic_notification',
                    color: '#f45342',
                }
            },
            apns: {
                payload: {
                    aps: {
                        alert: {
                            title: title,
                            body: body
                        },
                        sound: 'default',
                        badge: 1
                    }
                }
            },
            ...(clickAction && { fcmOptions: { link: clickAction } })
        };

        console.log('📨 Message FCM construit:', {
            token: `${fcmToken.substring(0, 20)}...`,
            title,
            body,
            data: Object.keys(data)
        });

        // Envoi de la notification
        const response = await firebaseAdmin.messaging().send(message);

        // Historique
        notificationHistory.push({
            type: 'notification_sent',
            userId,
            messageId: response,
            title,
            body,
            timestamp: new Date().toISOString(),
            success: true
        });

        console.log('✅ Notification envoyée avec succès:', response);

        res.json({
            status: true,
            messageId: response,
            message: 'Notification envoyée avec succès',
            details: {
                userId,
                title,
                body,
                timestamp: new Date().toISOString()
            }
        });

    } catch (error) {
        console.error('❌ Erreur envoi notification:', error);

        // Historique d'erreur
        notificationHistory.push({
            type: 'notification_error',
            userId: req.body.userId,
            error: error.message,
            timestamp: new Date().toISOString(),
            success: false
        });

        // Gestion des erreurs spécifiques FCM
        let errorMessage = 'Erreur lors de l\'envoi de la notification';
        let statusCode = 500;

        if (error.code === 'messaging/registration-token-not-registered') {
            errorMessage = 'Token FCM non enregistré ou invalide';
            statusCode = 400;
        }

        res.status(statusCode).json({
            success: false,
            error: errorMessage,
            details: error.message,
            code: error.code
        });
    }
}

// app.post('/api/send-bulk-notifications', async (req, res) => {
//     try {
//         const { userIds, title, body, data = {} } = req.body;

//         console.log(`📨 Envoi multiple - ${userIds.length} utilisateurs, Titre: "${title}"`);

//         if (!userIds || !Array.isArray(userIds) || userIds.length === 0) {
//             return res.status(400).json({
//                 success: false,
//                 error: 'Liste d\'utilisateurs requise'
//             });
//         }

//         // Récupérer les tokens valides
//         const validTokens = [];
//         const invalidUsers = [];

//         userIds.forEach(userId => {
//             const token = userTokens.get(userId);
//             if (token) {
//                 validTokens.push(token);
//             } else {
//                 invalidUsers.push(userId);
//             }
//         });

//         if (validTokens.length === 0) {
//             return res.status(404).json({
//                 success: false,
//                 error: 'Aucun token valide trouvé',
//                 invalidUsers
//             });
//         }

//         const message = {
//             notification: { title, body },
//             data: {
//                 ...data,
//                 timestamp: new Date().toISOString(),
//                 type: 'bulk'
//             },
//             tokens: validTokens,
//         };

//         const response = await admin.messaging().sendEachForMulticast(message);

//         // Historique
//         notificationHistory.push({
//             type: 'bulk_notification',
//             userCount: validTokens.length,
//             successCount: response.successCount,
//             failureCount: response.failureCount,
//             title,
//             timestamp: new Date().toISOString()
//         });

//         console.log(`📊 Résultat envoi multiple:`);
//         console.log(`   - Succès: ${response.successCount}`);
//         console.log(`   - Échecs: ${response.failureCount}`);
//         console.log(`   - Utilisateurs invalides: ${invalidUsers.length}`);

//         res.json({
//             success: true,
//             sentCount: response.successCount,
//             failedCount: response.failureCount,
//             invalidUsers,
//             results: response.responses.map((resp, index) => ({
//                 userId: userIds[index],
//                 success: resp.success,
//                 error: resp.error ? resp.error.message : null
//             }))
//         });

//     } catch (error) {
//         console.error('❌ Erreur envoi multiple:', error);
//         res.status(500).json({
//             success: false,
//             error: 'Erreur lors de l\'envoi des notifications',
//             details: error.message
//         });
//     }
// });
// app.post('/api/subscribe-to-topic', async (req, res) => {
//     try {
//         const { tokens, topic } = req.body;

//         if (!tokens || !topic) {
//             return res.status(400).json({
//                 success: false,
//                 error: 'Tokens et topic requis'
//             });
//         }

//         const response = await admin.messaging().subscribeToTopic(tokens, topic);

//         console.log(`📢 Souscription au topic "${topic}":`);
//         console.log(`   - Succès: ${response.successCount}`);
//         console.log(`   - Échecs: ${response.failureCount}`);

//         res.json({
//             success: true,
//             topic,
//             successCount: response.successCount,
//             failureCount: response.failureCount,
//             errors: response.errors
//         });

//     } catch (error) {
//         console.error('❌ Erreur souscription topic:', error);
//         res.status(500).json({
//             success: false,
//             error: error.message
//         }); 
//     }
// });
// app.post('/api/send-to-topic', async (req, res) => {
//     try {
//         const { topic, title, body, data = {} } = req.body;

//         const message = {
//             topic: topic,
//             notification: { title, body },
//             data: data,
//         };

//         const response = await admin.messaging().send(message);

//         res.json({
//             success: true,
//             messageId: response,
//             topic,
//             message: 'Notification envoyée au topic'
//         });

//     } catch (error) {
//         res.status(500).json({
//             success: false,
//             error: error.message
//         });
//     }
// });
// app.get('/api/stats', (req, res) => {
//     res.json({
//         usersCount: userTokens.size,
//         notificationsCount: notificationHistory.length,
//         recentNotifications: notificationHistory.slice(-10).reverse(),
//         serverUptime: process.uptime(),
//         memoryUsage: process.memoryUsage()
//     });
// });
// app.post('/api/test', async (req, res) => {
//     try {
//         const { userId } = req.body;

//         if (!userId) {
//             return res.status(400).json({ error: 'userId requis' });
//         }

//         const token = userTokens.get(userId);
//         if (!token) {
//             return res.status(404).json({ error: 'Utilisateur non trouvé' });
//         }

//         const testMessage = {
//             token: token,
//             notification: {
//                 title: '🔔 Test Réussi!',
//                 body: 'Votre configuration FCM fonctionne parfaitement! 🎉'
//             },
//             data: {
//                 type: 'test',
//                 message: 'Ceci est une notification de test',
//                 timestamp: new Date().toISOString()
//             }
//         };

//         const response = await admin.messaging().send(testMessage);

//         res.json({
//             success: true,
//             message: 'Notification de test envoyée avec succès',
//             messageId: response,
//             userId,
//             timestamp: new Date().toISOString()
//         });

//     } catch (error) {
//         res.status(500).json({
//             success: false,
//             error: error.message
//         });
//     }
// });


module.exports = {
    loadNotification,
    notification,
    sendNotification,
    registerToken,
    unregisterToken,
    getNotifications,
    getNewNotifications: async (req, res) => {
        const user = req.user, userId = user?._id, userEmail = user?.email;
        try {
            const { lastDate } = req.query;
            if (!lastDate) {
                return res.status(400).json({ success: false, error: 'Paramètre lastDate requis' });
            }
            const lastDateDate = new Date(lastDate);
            if (isNaN(lastDateDate.getTime())) {
                return res.status(400).json({ success: false, error: 'Paramètre lastDate invalide' });
            }
            const newNotifications = await notificationModel.find({
                recipient: userEmail,
                createdAt: { $gt: lastDateDate }
            }).sort({ createdAt: -1 });
            res.json({ status: true, data: newNotifications });
        } catch (error) {
            console.error('❌ Erreur récupération nouvelles notifications:', error);
            res.status(500).json({
                success: false,
                error: 'Erreur interne du serveur',
                details: error.message
            });
        }
    },
    updateNotification: async (req, res) => {
        const user = req.user, userId = user?._id, userEmail = user?.email;
        try {

            const { id, isRead } = req.body;
            if (!id || id.length === 0) {
                return res.status(400).json({ success: false, error: 'Paramètre id requis' });
            }
            if (isRead && typeof isRead !== 'boolean') {
                return res.status(400).json({ success: false, error: 'Paramètre isRead doit être un booléen' });
            }
            const result = await notificationModel.updateMany(
                { _id: { $in: id }, recipient: userEmail },
                { $set: { is_read: isRead } }
            );

            res.json({
                status: true,
                message: 'Statut de lecture mis à jour',
            });
        } catch (error) {
            console.error('❌ Erreur mise à jour statut lecture:', error);
            res.status(500).json({
                success: false,
                error: 'Erreur interne du serveur',
                details: error.message
            });
        }
    },
    sendandGetResponse: async (userEmail, title, body, data) => {
        let response = null;
        const userCredentials = await userNotificationModel.findOne({ userEmail });
        if (userCredentials) {
            const fcmToken = userCredentials.registrationToken;
            if (!fcmToken) { return; }
            const fmessage = {
                token: fcmToken,
                notification: { title, body, },
                data,
                android: config.pushNotification.android,
                apns: config.pushNotification.apns(title, body),
            };
            try {
                response = await firebaseAdmin.messaging().send(fmessage);
            } catch (error) {
                if (error.code !== 'messaging/registration-token-not-registered')
                    console.error('Erreur lors de l\'envoi de la notification:', error);
            }
        }
        return response;
    }

}