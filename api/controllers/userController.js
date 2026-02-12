// Importing required modules 

// Importing models
const loginModel = require("../models/adminLoginModel");
const userModel = require("../models/userModel");
const bcrypt = require("bcryptjs");
const { signupShema, edituserShema } = require("../utils/shemas");
const { validateDatabyScheme, AllvaluesNullorEmpyObject, getPlanName } = require("../utils/utils");
const trashModel = require("../models/trashModel");
const TransactionSchema = require("../models/transactionModel");
const moment = require('moment');
const loginhistorymodel = require("../models/loginHistory");
const reviewModel = require("../models/reviewModel");
const procurationmodel = require("../models/procurationModel");


module.exports = {
    getusers: async (req, res) => {
        // await userModel.updateMany({}, { isDeleted: false });
        //wait 5 seconds
        try {
            const page = parseInt(req.query.page ?? 0) + 1;
            const limit = parseInt(req.query.limit) || 10;
            let filter = req.query.filter ? JSON.parse(req.query.filter) : {};
            if (AllvaluesNullorEmpyObject(filter)) {
                filter = null
            }

            if (filter) {
                if (filter.q) {
                    filter.$or = [
                        { firstName: { $regex: filter.q, $options: 'i' } },
                        { lastName: { $regex: filter.q, $options: 'i' } },
                        { email: { $regex: filter.q, $options: 'i' } },
                        { phone: { $regex: filter.q, $options: 'i' } },
                        { country: { $regex: filter.q, $options: 'i' } },
                        { address: { $regex: filter.q, $options: 'i' } },
                        { dob: { $regex: filter.q, $options: 'i' } },
                        { placeOfBirth: { $regex: filter.q, $options: 'i' } },
                    ]
                    delete filter.q;
                }
            } else {
                filter = {}
            }

            const skip = (page - 1) * limit;
            const users = await userModel.find(
                filter,
                { password: 0, balances: 0, balences: 0, }
            )
                .skip(skip)
                .limit(limit);
            return res.json({
                success: true,
                data: users,
                pagination: {
                    currentPage: page,
                    totalPages: Math.ceil(await userModel.countDocuments(filter) / limit),
                    totalItems: await userModel.countDocuments(filter),
                    itemsPerPage: limit
                }
            });

        } catch (error) {
            console.log(error.message);
            return res.status(500).json({ error: 'Failed to fetch coupons' });
        }
    },
    getstatistics: async (req, res) => {
        const { filter } = req.query;

        const page = parseInt(req.query.page) || 1;
        //periods : monthly, 7d, 30d, dateRange
        let filtering = {
            period: '30d',
        };

        try {
            if (filter) {
                filtering = JSON.parse(filter);
            };
            const theDays = []
            // utiliser moment pour obtenir la liste des jours entre deux dates
            if (filtering.period && filtering.period === 'dateRange' && filtering.dateRange && filtering.dateRange.includes('-')) {
                const [startStr, endStr] = filtering.dateRange.split('-').map(s => s.trim());
                const [startDay, startMonth, startYear] = startStr.split('/').map(Number);
                const [endDay, endMonth, endYear] = endStr.split('/').map(Number);
                const startDate = moment(new Date(startYear, startMonth - 1, startDay));
                const endDate = moment(new Date(endYear, endMonth - 1, endDay));
                const diffDays = endDate.diff(startDate, 'days');
                for (let i = 0; i <= diffDays; i++) {
                    theDays.push(startDate.clone().add(i, 'days').format('DD/MM/YYYY'));
                }
            }
            else if (filtering.period && filtering.period === '7d') {
                for (let i = 6; i >= 0; i--) {
                    theDays.push(moment().subtract(i, 'days').format('DD/MM/YYYY'));
                }
            }
            else {
                for (let i = 29; i >= 0; i--) {
                    theDays.push(moment().subtract(i, 'days').format('DD/MM/YYYY'));
                }
            }


            let postMatch = {};

            if (filtering.period && filtering.period === 'dateRange' && filtering.dateRange && filtering.dateRange.includes('-')) {
                const [startStr, endStr] = filtering.dateRange.split('-').map(s => s.trim());
                const [startDay, startMonth, startYear] = startStr.split('/').map(Number);
                const [endDay, endMonth, endYear] = endStr.split('/').map(Number);
                const startDate = new Date(startYear, startMonth - 1, startDay);
                const endDate = new Date(endYear, endMonth - 1, endDay, 23, 59, 59, 999);
                postMatch.createdAt = { $gte: startDate, $lte: endDate };
            }

            const [transactions, total] = await Promise.all([
                TransactionSchema.find(
                    {
                        ...postMatch,
                        transaction_id: { $not: { $regex: '^DEBIT-' } }
                    }
                ).populate({
                    path: 'userId',
                    select: 'firstName lastName email',
                    model: 'user'
                })
                    .sort({ createdAt: -1 })
                    .lean(),
                TransactionSchema.countDocuments({ ...postMatch })
            ]);


            let overviewData = [];
            let xAxiss = []
            transactions.forEach(transaction => {
                const date = new Date(transaction.createdAt);
                const day = date.getDate();
                const month = date.getMonth() + 1;
                const year = date.getFullYear();
                const key = `${day}/${month}/${year}`;
                let dispersion = transaction.dispersion
                if (dispersion && dispersion.length > 0) {
                    dispersion = dispersion.map(item => {
                        return {
                            ...item,
                            date: key
                        }
                    });
                    overviewData = overviewData.concat(dispersion);
                }
            });
            //now group by date and sum dis_price and dis_quantity
            const groupedData = {};
            overviewData.forEach(item => {
                if (!groupedData[item.id]) {
                    groupedData[item.id] = [];
                }
                groupedData[item.id].push(item);
            });
            global.writeToFile(JSON.stringify(groupedData, null, 2))

            let dataListAgregated = {};

            for (const id in groupedData) {
                const items = groupedData[id];
                let computing = {}
                items.forEach(item => {
                    if (!computing[item.date]) { computing[item.date] = { date: item.date, dis_price: 0, dis_quantity: 0, id: item.id }; }
                    computing[item.date].dis_price += item.dis_price;
                    computing[item.date].dis_quantity += item.dis_quantity;
                });
                let finalValue = Object.values(computing)

                //maintenant completer avec les jours manquants
                theDays.forEach(day => {
                    if (!finalValue.find(v => v.date === day)) {
                        finalValue.push({ date: day, dis_price: 0, dis_quantity: 0, id: id });
                    }
                });

                //trier par date
                finalValue.sort((a, b) => {
                    const [dayA, monthA, yearA] = a.date.split('/').map(Number);
                    const [dayB, monthB, yearB] = b.date.split('/').map(Number);
                    const dateA = new Date(yearA, monthA - 1, dayA);
                    const dateB = new Date(yearB, monthB - 1, dayB);
                    return dateA - dateB;
                });

                dataListAgregated[id] = finalValue;
            }
            for (const id in dataListAgregated) {
                dataListAgregated[getPlanName(id)] = dataListAgregated[id];
                delete dataListAgregated[id];
            }




            //user login statistics conected within theDays range based on lastSeenAt

            const userLogins = await userModel.find({
                lastSeenAt: {
                    $gte: new Date(theDays[0].split('/').reverse().join('-') + 'T00:00:00.000Z'),
                    $lte: new Date(theDays[theDays.length - 1].split('/').reverse().join('-') + 'T23:59:59.999Z'),
                }
            }).lean();
            // const loginHistory = await loginhistorymodel.find(
            //     // {
            //     //     loginAt: {
            //     //         $gte: new Date(theDays[0].split('/').reverse().join('-') + 'T00:00:00.000Z'),
            //     //         $lte: new Date(theDays[theDays.length - 1].split('/').reverse().join('-') + 'T23:59:59.999Z'),
            //     //     }
            //     // }
            // ).lean();
            // //group them by platform : 

            //nombre de nouveau état des lieux simple commencé et le nombre de nouvelle procurations commencé 
            const simpleStarted = await reviewModel.countDocuments({
                createdAt: {
                    $gte: new Date(theDays[0].split('/').reverse().join('-') + 'T00:00:00.000Z'),
                    $lte: new Date(theDays[theDays.length - 1].split('/').reverse().join('-') + 'T23:59:59.999Z'),
                },
            });
            const procurementStarted = await procurationmodel.countDocuments({
                createdAt: {
                    $gte: new Date(theDays[0].split('/').reverse().join('-') + 'T00:00:00.000Z'),
                    $lte: new Date(theDays[theDays.length - 1].split('/').reverse().join('-') + 'T23:59:59.999Z'),
                },
            });



            let newLyReviews = {
                [Object.keys(dataListAgregated)[0]]: simpleStarted,
                [Object.keys(dataListAgregated)[1]]: procurementStarted
            }


            res.json({
                success: true,
                data: {
                    dataListAgregated,
                    theDays,
                    userLogins: userLogins.length,
                    newLyReviews
                }
            });
        } catch (err) {
            res.status(500).json({
                success: false,
                error: 'Server Error',
                details: err.message
            });
        }
    },
    addUser: async (req, res) => {
        try {
            const { email, password, firstName, lastName, country_code, phone, country, type, level, placeOfBirth, about, address, dob } = req.body;
            let userData = req.body

            const dataValidation = validateDatabyScheme(signupShema, {
                ...req.body
            }, res)

            if (!dataValidation) {
                console.log("Validation failed");
                return;
            }


            const existingUser = await userModel.findOne({ email });
            if (existingUser) {
                return res.status(409).json({ status: false, message: "Cette adresse e-mail est déjà liée à un compte" });
            }
            const existingPhone = await userModel.findOne({ phone });
            if (existingPhone) {
                return res.status(409).json({ status: false, message: "Numéro de téléphone déjà utilisé" });
            }
            const hashedPassword = await bcrypt.hash(password, 10);

            const newUser = new userModel({
                firstName,
                lastName,
                email,
                country_code,
                phone,
                country,
                type,
                verifiedAt: new Date(),
                password: hashedPassword,
                level: level ?? 'standard',
                placeOfBirth: placeOfBirth ?? '',
                about: about ?? '',
                address: address ?? '',
                dob: dob ?? ''
            });
            await newUser.save();

            return res.status(201).json({ status: true, message: "Utilisateur ajouté avec succès", data: newUser });

        } catch (error) {
            console.log(error.message);
        }
    },
    editUser: async (req, res) => {
        const dataValidation = validateDatabyScheme(edituserShema, {
            ...req.body
        }, res)
        if (!dataValidation) {
            console.log("Validation failed");
            return;
        }

        try {
            const id = req.params.id;
            const { email, firstName, lastName, country_code, phone, country, placeOfBirth, about, address, dob, password, is_active } = req.body;
            const user = await userModel.findById(id);
            if (!user) {
                return res.status(404).json({ status: false, message: "Utilisateur non trouvé" });
            }
            if (password) {
                const hashedNewPassword = await bcrypt.hash(password, 10);
                user.password = hashedNewPassword;
            }
            user.firstName = firstName;
            user.lastName = lastName;
            user.email = email;
            user.country_code = country_code;
            user.phone = phone;
            user.country = country;
            user.placeOfBirth = placeOfBirth ?? '';
            user.about = about ?? '';
            user.address = address ?? '';
            user.dob = dob ?? '';
            user.is_active = is_active ?? user.is_active;

            await user.save();

            return res.status(200).json({ status: true, message: "Utilisateur mis à jour avec succès", data: user });


        } catch (error) {
            console.log(error.message);
        }
    },
    deleteUser: async (req, res) => {

        try {
            const id = req.params.id;
            const user = await userModel.find({ _id: id });
            // 
            if (!user) {
                throw "Utilisateur non trouvé";
            }
            await trashModel.create({
                originalId: user._id,
                collectionName: 'user',
                data: user,
                deletedAt: new Date(),
                deletedBy: req.organizer._id.toString()
            });
            await userModel.findByIdAndDelete(id);

            return res.status(200).json({ message: "Utilisateur supprimé avec succès", status: true });
        } catch (error) {
            throw error;
        }
    },
    activeUser: async (req, res) => {

        try {

            // Extract data from the request
            const id = req.query.id;

            // Find current user
            const currentUser = await userModel.findById({ _id: id });

            const user = await userModel.findByIdAndUpdate({ _id: id }, { $set: { is_active: currentUser.is_active === false ? true : false } }, { new: true });

            return res.redirect('/user');

        } catch (error) {
            console.log(error.message);
        }
    }
}
