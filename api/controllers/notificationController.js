//  Importing models
const notificationModel = require("../models/notificationModel");
const currencyTimeZoneModel = require("../models/currencyTimezoneModel");

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

module.exports = {
    loadNotification,
    notification
}