// Importing required modules 
const express = require("express");
const errorHandler = require('../utils/error-handler');
const Stripe = require('stripe');
const { generateResponse, ApplyCodeToPrice, getPaymentMethodDisplayName, getPlanName } = require('../utils/utils');
const bodyParser = require("body-parser");
const { checkAuthentication } = require("../middleware/checkAuthentication");
const TransactionSchema = require('../models/transactionModel');
const { planSchema } = require("../utils/shemas");
const planModel = require("../models/planModel");
const User = require('../models/userModel'); // Adjust import path if needed
const couponModel = require("../models/couponModel");
const { sendPaymentEmail } = require("../services/sendmail");
const FileModel = require('../models/File');
const randomstring = require('randomstring');
const puppeteer = require('puppeteer');
const fs = require('fs');
const { generateInvoicePdfHtml } = require("../utils/pdfs/pdfkitinvoice");
const config = require("../config/config");
const headerhtml = fs.readFileSync('./uploads/header.html', 'utf8');
const FileAccessSchema = require("../models/fileaccessModel");

const footerinvoice = fs.readFileSync('./uploads/footerinvoice.html', 'utf8');

//4242424242424242 12/34 123 CVC
// Create an instance of the express router
const stripeapp = express.Router();

const stripePublishableKey = process.env.STRIPE_PUBLISHABLE_KEY || '';
const stripeSecretKey = process.env.STRIPE_SECRET_KEY || '';
const stripeWebhookSecret = process.env.STRIPE_WEBHOOK_SECRET || '';

const itemIdToPrice = {
    "id-1": 1400,
    "id-2": 2000,
    "id-3": 3000,
    "id-4": 4000,
    "id-5": 5000
}

const calculateOrderAmount = (itemIds = ["id-1"]) => {
    const total = itemIds
        .map(id => itemIdToPrice[id])
        .reduce((prev, curr) => prev + curr, 0)

    return total
}

function getKeys(payment_method) {
    let secret_key = stripeSecretKey
    let publishable_key = stripePublishableKey

    switch (payment_method) {
        case "grabpay":
        case "fpx":
            publishable_key = process.env.STRIPE_PUBLISHABLE_KEY_MY
            secret_key = process.env.STRIPE_SECRET_KEY_MY
            break
        case "au_becs_debit":
            publishable_key = process.env.STRIPE_PUBLISHABLE_KEY_AU
            secret_key = process.env.STRIPE_SECRET_KEY_AU
            break
        case "oxxo":
            publishable_key = process.env.STRIPE_PUBLISHABLE_KEY_MX
            secret_key = process.env.STRIPE_SECRET_KEY_MX
            break
        case "wechat_pay":
            publishable_key = process.env.STRIPE_PUBLISHABLE_KEY_WECHAT
            secret_key = process.env.STRIPE_SECRET_KEY_WECHAT
            break
        case "paypal":
            publishable_key = process.env.STRIPE_PUBLISHABLE_KEY_UK
            secret_key = process.env.STRIPE_SECRET_KEY_UK
            break
        default:
            publishable_key = process.env.STRIPE_PUBLISHABLE_KEY
            secret_key = process.env.STRIPE_SECRET_KEY
    }

    return { secret_key, publishable_key }
}

async function createdTransaction(req, paymentIntent, amount, dispersions, payment_method = 'stripe', coupons = []) {

    try {
        const transaction = new TransactionSchema({
            userId: req.user._id,
            dispersion: dispersions,
            total_amount: amount,
            price: amount / 100,
            payment_method,
            payment_status: 'pending',
            transaction_id: paymentIntent.id,
            meta: {
                paymentIntent,
                couponData: coupons
            },
            coupon_code: coupons?.[0].code,
        });

        // Add optional fields if provided
        // if (req.body.coupon_code) transaction.coupon_code = req.body.coupon_code;
        if (req.body.coupon_amount) transaction.coupon_amount = req.body.coupon_amount;
        if (req.body.tax) transaction.tax = req.body.tax;
        if (req.body.tax_amount) transaction.tax_amount = req.body.tax_amount;

        await transaction.save();
    } catch (error) {
        console.error('Failed to save transaction:', error);
        // Continue processing even if transaction save fails
    }
}

stripeapp.get("/stripe-key", (req, res) => {
    const { publishable_key } = getKeys(req.query.paymentMethod)

    return res.send({ publishableKey: publishable_key })
})




const stripe = new Stripe(process.env.STRIPE_SECRET_KEY, {
    apiVersion: "2023-08-16",
    typescript: true,
});

// 🧾 Get a specific invoice by ID
const getInvoiceById = async (invoiceId) => {
    try {
        const session = await stripe.checkout.sessions.retrieve(invoiceId);
        let invoice = null;

        let receiptUrl = null;
        if (session.payment_intent) {
            const paymentIntent = await stripe.paymentIntents.retrieve(session.payment_intent);
            if (paymentIntent.invoice) {
                invoice = await stripe.invoices.retrieve(paymentIntent.invoice);
            }
            const charge = await stripe.charges.retrieve(paymentIntent.latest_charge);
            receiptUrl = charge.receipt_url;
        }
        // console.log(
        //     {
        //         session,
        //         invoiceUrl: invoice?.invoice_pdf || session.invoice_creation?.invoice_data?.invoice_pdf || null,
        //         receiptUrl,
        //     }
        // );

        return {
            session,
            invoiceUrl: invoice?.invoice_pdf || session.invoice_creation?.invoice_data?.invoice_pdf || null,
            receiptUrl,
        };
    } catch (error) {
        console.error("Error fetching invoice:", error.message);
        throw error;
    }
};
const generateInvoicePDF = async (transaction, entrantPdfPath) => {
    try {
        const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox', '--disable-setuid-sandbox'] });
        const page = await browser.newPage();
        // Generate the HTML content
        const htmlContent = generateInvoicePdfHtml(transaction);
        //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
        fs.writeFileSync(`./uploads/previewt.html`, `${htmlContent}`, 'utf-8');
        //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

        await page.setContent(htmlContent, {
            waitUntil: 'networkidle0'
        });

        await page.pdf({
            path: entrantPdfPath,
            format: 'A4',
            margin: {
                top: '20px',
                right: '20px',
                bottom: '20px',
                left: '20px'
            },
            printBackground: true,
            waitForFonts: true,
            footerTemplate: `${footerinvoice}`,
            displayHeaderFooter: true,
        });

        await browser.close();
        return { entrant_pdfPath: entrantPdfPath };
    } catch (error) {
        throw error;
    }
};
stripeapp.get("/transaction/invoice/:transactionId", checkAuthentication, async (req, res) => {
    const isAdmin = req.casper === true;
    const { transactionId } = req.params;
    const userId = req.user._id;

    let query = isAdmin ? { transaction_id: transactionId } : { transaction_id: transactionId, userId: req.user._id }
    const transaction = await TransactionSchema.findOne(query);

    if (!transaction) {
        return res.status(404).json({ message: "Transaction not found", status: false });
    }

    let infoiceFile = await FileModel.findOne({ name: `facture_${transaction._id}` });
    if (!infoiceFile) {
        let pdfPath = `./public/documents/facture_${transaction._id}.pdf`;
        const shield = randomstring.generate({ length: 120, charset: 'alphanumeric', capitalization: 'lowercase', });
        infoiceFile = await FileModel.create({ name: `facture_${transaction._id}`, author: userId, location: pdfPath, shield, type: "application/pdf" });
        await FileAccessSchema.create({ userId: userId, fileId: infoiceFile._id, accessType: ['read', 'write', 'delete', 'update'], email: req.user.email });

    }

    if (transaction.dispersion && transaction.dispersion.length > 0) {
        transaction.dispersion = transaction.dispersion.map(item => {
            return {
                ...item,
                name: getPlanName(item["id"]),
                quantity: item.dis_quantity,
                price: item.dis_price.toFixed(2),
            }
        }
        )
    }

    let theData = {
        userName: `${req.user.firstName || ''} ${req.user.lastName || ''}`.trim() || req.user.email,
        userAddress: req.user.address || '',
        transactionId: `#${transaction._id}`,
        transactionDate: new Date(transaction.updatedAt).toLocaleDateString('fr-FR', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit', }),
        completedAt: new Date(transaction.completedAt).toLocaleDateString('fr-FR', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit', }),
        paymentMethod: `${getPaymentMethodDisplayName(transaction.payment_method)}`,
        isCreditPurchase: true,
        creditAmount: transaction.dispersion && transaction.dispersion.length > 0 ? transaction.dispersion.reduce((total, item) => total + (item.dis_quantity || 0), 0) : 0,
        hasCoupon: transaction.coupon_code ? true : false,
        couponCode: transaction.meta && transaction.meta.couponData && transaction.meta.couponData.length > 0 ? transaction.meta.couponData.map(c => c.code).join(', ') : '',
        couponAmount: transaction.meta && transaction.meta.couponData && transaction.meta.couponData.length > 0 ? ((transaction.meta.couponData.reduce((total, c) => total + ((c.savedAmount / 100).toFixed(2) || 0), 0))) : '0.00',
        totalAmount: transaction.price.toFixed(2),
        amountUnit: "€",
        isReviewPurchase: false,
        computedDispersion: transaction.dispersion,
    };
    await generateInvoicePDF(theData, infoiceFile.location);


    global.writeToFile(JSON.stringify(theData, null, 2))
    // invoice
    // invoice_pdf

    res.json({
        status: true, data: {
            invoice_pdf: infoiceFile._id
        }
    });


})

stripeapp.post("/create-payment-intent", checkAuthentication, async (req, res) => {
    const {
        email,
        currency,
        request_three_d_secure,
        payment_method_types = [],
        client = "ios",
        amount
    } = req.body

    const { secret_key } = getKeys(payment_method_types[0])

    const stripe = new Stripe(secret_key, {
        apiVersion: "2023-08-16",
        typescript: true
    })
    const customers = await stripe.customers.list()

    var customer = customers.data.find(c => c.email === email)

    customer = customer ? customer : await stripe.customers.create({ email })


    // Create a PaymentIntent with the order amount and currency.
    const params = {
        amount,
        currency: currency || "eur",
        customer: customer.id,
        payment_method_options: {
            card: {
                request_three_d_secure: request_three_d_secure || "automatic"
            },
            // sofort: {
            //     preferred_language: "en"
            // },
            // wechat_pay: {
            //     app_id: "wx65907d6307c3827d",
            //     client: client
            // }
        },
        payment_method_types: payment_method_types
    }

    try {
        const paymentIntent = await stripe.paymentIntents.create(params)

        // Send publishable key and PaymentIntent client_secret to client.
        return res.json({
            status: true,

            data: {
                clientSecret: paymentIntent.client_secret
            }

        })
    } catch (error) {
        return res.json({
            error: error.raw.message
        })
    }
})



stripeapp.post("/create-payment-intent-with-payment-method", async (req, res) => {
    const { items, currency, request_three_d_secure, email } = req.body
    const { secret_key } = getKeys()

    const stripe = new Stripe(secret_key, {
        apiVersion: "2023-08-16",
        typescript: true
    })
    const customers = await stripe.customers.list({
        email
    })

    // The list all Customers endpoint can return multiple customers that share the same email address.
    // For this example we're taking the first returned customer but in a production integration
    // you should make sure that you have the right Customer.
    if (!customers.data[0]) {
        return res.send({
            error: "There is no associated customer object to the provided e-mail"
        })
    }
    // List the customer's payment methods to find one to charge
    const paymentMethods = await stripe.paymentMethods.list({
        customer: customers.data[0].id,
        type: "card"
    })

    if (!paymentMethods.data[0]) {
        return res.send({
            error: `There is no associated payment method to the provided customer's e-mail`
        })
    }

    const params = {
        amount: calculateOrderAmount(items),
        currency,
        payment_method_options: {
            card: {
                request_three_d_secure: request_three_d_secure || "automatic"
            }
        },
        payment_method: paymentMethods.data[0].id,
        customer: customers.data[0].id
    }

    const paymentIntent = await stripe.paymentIntents.create(params)

    // Send publishable key and PaymentIntent client_secret to client.
    return res.send({
        clientSecret: paymentIntent.client_secret,
        paymentMethodId: paymentMethods.data[0].id
    })
})

stripeapp.post("/pay-without-webhooks", async (req, res) => {
    const {
        paymentMethodId,
        paymentIntentId,
        items,
        currency,
        useStripeSdk,
        cvcToken,
        email
    } = req.body

    const orderAmount = calculateOrderAmount(items)
    const { secret_key } = getKeys()

    const stripe = new Stripe(secret_key, {
        apiVersion: "2023-08-16",
        typescript: true
    })

    try {
        if (cvcToken && email) {
            const customers = await stripe.customers.list({
                email
            })

            // The list all Customers endpoint can return multiple customers that share the same email address.
            // For this example we're taking the first returned customer but in a production integration
            // you should make sure that you have the right Customer.
            if (!customers.data[0]) {
                return res.send({
                    error: "There is no associated customer object to the provided e-mail"
                })
            }

            const paymentMethods = await stripe.paymentMethods.list({
                customer: customers.data[0].id,
                type: "card"
            })

            if (!paymentMethods.data[0]) {
                return res.send({
                    error: `There is no associated payment method to the provided customer's e-mail`
                })
            }

            const params = {
                amount: orderAmount,
                confirm: true,
                confirmation_method: "manual",
                currency,
                payment_method: paymentMethods.data[0].id,
                payment_method_options: {
                    card: {
                        cvc_token: cvcToken
                    }
                },
                use_stripe_sdk: useStripeSdk,
                customer: customers.data[0].id,
                return_url: "stripe-example://stripe-redirect"
            }
            const intent = await stripe.paymentIntents.create(params)
            return res.send(generateResponse(intent))
        } else if (paymentMethodId) {
            // Create new PaymentIntent with a PaymentMethod ID from the client.
            const params = {
                amount: orderAmount,
                confirm: true,
                confirmation_method: "manual",
                currency,
                payment_method: paymentMethodId,
                // If a mobile client passes `useStripeSdk`, set `use_stripe_sdk=true`
                // to take advantage of new authentication features in mobile SDKs.
                use_stripe_sdk: useStripeSdk,
                return_url: "stripe-example://stripe-redirect"
            }
            const intent = await stripe.paymentIntents.create(params)
            // After create, if the PaymentIntent's status is succeeded, fulfill the order.
            return res.send(generateResponse(intent))
        } else if (paymentIntentId) {
            // Confirm the PaymentIntent to finalize payment after handling a required action
            // on the client.
            const intent = await stripe.paymentIntents.confirm(paymentIntentId)
            // After confirm, if the PaymentIntent's status is succeeded, fulfill the order.
            return res.send(generateResponse(intent))
        }

        return res.sendStatus(400)
    } catch (e) {
        // Handle "hard declines" e.g. insufficient funds, expired card, etc
        // See https://stripe.com/docs/declines/codes for more.
        return res.send({ error: e.message })
    }
})

stripeapp.post("/create-setup-intent", async (req, res) => {
    const { email, payment_method_types = [] } = req.body
    const { secret_key } = getKeys(payment_method_types[0])

    const stripe = new Stripe(secret_key, {
        apiVersion: "2023-08-16",
        typescript: true
    })
    const customer = await stripe.customers.create({ email })

    const payPalIntentPayload = {
        return_url: "https://example.com/setup/complete",
        payment_method_options: { paypal: { currency: "eur" } },
        payment_method_data: { type: "paypal" },
        mandate_data: {
            customer_acceptance: {
                type: "online",
                online: {
                    ip_address: "1.1.1.1",
                    user_agent: "test-user-agent"
                }
            }
        },
        confirm: true
    }

    //@ts-ignore
    const setupIntent = await stripe.setupIntents.create({
        ...{ customer: customer.id, payment_method_types },
        ...(payment_method_types?.includes("paypal") ? payPalIntentPayload : {})
    })

    // Send publishable key and SetupIntent details to client
    return res.send({
        publishableKey: process.env.STRIPE_PUBLISHABLE_KEY,
        clientSecret: setupIntent.client_secret,
        customerId: customer.id
    })
})

// Expose a endpoint as a webhook handler for asynchronous events.
// Configure your webhook in the stripe developer dashboard:
// https://dashboard.stripe.com/test/webhooks
stripeapp.post(
    "/webhook", // Use body-parser to retrieve the raw body as a buffer.
    /* @ts-ignore */
    bodyParser.raw({ type: "application/json" }),
    (req, res) => {
        // Retrieve the event by verifying the signature using the raw body and secret.
        let event
        const { secret_key } = getKeys()

        const stripe = new Stripe(secret_key, {
            apiVersion: "2023-08-16",
            typescript: true
        })
        // console.log('webhook!', req);
        try {
            event = stripe.webhooks.constructEvent(
                req.body,
                req.headers["stripe-signature"] || [],
                stripeWebhookSecret
            )
        } catch (err) {
            console.log(`⚠️  Webhook signature verification failed.`)
            return res.sendStatus(400)
        }

        // Extract the data from the event.
        const data = event.data
        const eventType = event.type

        if (eventType === "payment_intent.succeeded") {
            // Cast the event into a PaymentIntent to make use of the types.
            const pi = data.object

            // Funds have been captured
            // Fulfill any orders, e-mail receipts, etc
            // To cancel the payment after capture you will need to issue a Refund (https://stripe.com/docs/api/refunds).
            console.log(`🔔  Webhook received: ${pi.object} ${pi.status}!`)
            console.log("💰 Payment captured!")
        }
        if (eventType === "payment_intent.payment_failed") {
            // Cast the event into a PaymentIntent to make use of the types.
            const pi = data.object
            console.log(`🔔  Webhook received: ${pi.object} ${pi.status}!`)
            console.log("❌ Payment failed.")
        }

        if (eventType === "setup_intent.setup_failed") {
            console.log(`🔔  A SetupIntent has failed the to setup a PaymentMethod.`)
        }

        if (eventType === "setup_intent.succeeded") {
            console.log(
                `🔔  A SetupIntent has successfully setup a PaymentMethod for future use.`
            )
        }

        if (eventType === "setup_intent.created") {
            const setupIntent = data.object
            console.log(`🔔  A new SetupIntent is created. ${setupIntent.id}`)
        }

        return res.sendStatus(200)
    }
)

// An endpoint to charge a saved card
// In your application you may want a cron job / other internal process
stripeapp.post("/charge-card-off-session", async (req, res) => {
    let paymentIntent, customer

    const { secret_key } = getKeys()

    const stripe = new Stripe(secret_key, {
        apiVersion: "2023-08-16",
        typescript: true
    })

    try {
        // You need to attach the PaymentMethod to a Customer in order to reuse
        // Since we are using test cards, create a new Customer here
        // You would do this in your payment flow that saves cards
        customer = await stripe.customers.list({
            email: req.body.email
        })

        // List the customer's payment methods to find one to charge
        const paymentMethods = await stripe.paymentMethods.list({
            customer: customer.data[0].id,
            type: "card"
        })

        // Create and confirm a PaymentIntent with the order amount, currency,
        // Customer and PaymentMethod ID
        paymentIntent = await stripe.paymentIntents.create({
            amount: calculateOrderAmount(),
            currency: "usd",
            payment_method: paymentMethods.data[0].id,
            customer: customer.data[0].id,
            off_session: true,
            confirm: true
        })

        return res.send({
            succeeded: true,
            clientSecret: paymentIntent.client_secret,
            publicKey: stripePublishableKey
        })
    } catch (err) {
        if (err.code === "authentication_required") {
            // Bring the customer back on-session to authenticate the purchase
            // You can do this by sending an email or app notification to let them know
            // the off-session purchase failed
            // Use the PM ID and client_secret to authenticate the purchase
            // without asking your customers to re-enter their details
            return res.send({
                error: "authentication_required",
                paymentMethod: err.raw.payment_method.id,
                clientSecret: err.raw.payment_intent.client_secret,
                publicKey: stripePublishableKey,
                amount: calculateOrderAmount(),
                card: {
                    brand: err.raw.payment_method.card.brand,
                    last4: err.raw.payment_method.card.last4
                }
            })
        } else if (err.code) {
            // The card was declined for other reasons (e.g. insufficient funds)
            // Bring the customer back on-session to ask them for a new payment method
            return res.send({
                error: err.code,
                clientSecret: err.raw.payment_intent.client_secret,
                publicKey: stripePublishableKey
            })
        } else {
            console.log("Unknown error occurred", err)
            return res.sendStatus(500)
        }
    }
})

// This example sets up an endpoint using the Express framework.
// Watch this video to get started: https://youtu.be/rPR2aJ6XnAc.

stripeapp.post("/payment-sheet", checkAuthentication, async (req, res) => {

    const { email, amount, dispersions, hasCoupon, coupons } = req.body

    let newAmount = amount;
    let dataCoupons;
    if (hasCoupon && coupons) {
        dataCoupons = await couponModel.find({ code: { $in: coupons }, isActive: true, isDeleted: false, expiryDate: { $gt: new Date() } })
        if (!dataCoupons) {
            return res.status(400).json({ message: "Pas de coupon applicable", status: false });
        }
        // usageunique
        if (dataCoupons.some(coupon => coupon.usageunique)) {
            const usedCoupons = await TransactionSchema.find({ coupon_code: { $in: coupons } });
            if (usedCoupons.length > 0) {
                return res.status(400).json({ message: "Certains coupons ont déjà été utilisés", status: false });
            }
        }

        if (dataCoupons.length !== coupons.length) {
            return res.status(400).json({ message: "Certains coupons sont invalides", status: false });
        }
        newAmount = ApplyCodeToPrice(amount, dataCoupons);
        //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
        dataCoupons[0] = Object.assign({}, dataCoupons[0]._doc,
            {
                newAmount: newAmount,
                savedAmount: ((amount - newAmount) / 100).toFixed(2)
            });
        //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
    }

    const { secret_key } = getKeys()

    const stripe = new Stripe(secret_key)

    const customers = await stripe.customers.list()


    var customer = customers.data.find(c => c.email === email)

    customer = customer ? customer : await stripe.customers.create({ email })


    const ephemeralKey = await stripe.ephemeralKeys.create(
        { customer: customer.id },
        { apiVersion: "2023-08-16" }
    )
    const paymentIntent = await stripe.paymentIntents.create({
        amount: newAmount,
        currency: "eur",
        customer: customer.id,
        // Edit the following to support different payment methods in your PaymentSheet
        // Note: some payment methods have different requirements: https://stripe.com/docs/payments/payment-methods/integration-options
        payment_method_types: [
            "card",

        ]
    })
    // Save transaction in the database

    createdTransaction(req, paymentIntent, newAmount, dispersions, "stripe", (hasCoupon && coupons) ? dataCoupons : null);

    return res.json({

        status: true,
        data: {

            paymentIntent: paymentIntent.client_secret,
            ephemeralKey: ephemeralKey.secret,
            intentId: paymentIntent.id,
            customer: customer.id,

        }
    })
})
stripeapp.post('/create-payment-link', checkAuthentication, async (req, res, next) => {
    const pilot = req.user;
    const stripe = new Stripe(stripeSecretKey, {
        apiVersion: "2023-08-16",
        typescript: true
    })

    const body = Object.assign({}, req.body, {
        'pilot-type': "undefined",
    });
    const {
        productName,
        productDescription,
        amount,
        productTax,
        curency,
        dispersions
        , hasCoupon, coupons
    } = body;

    let newAmount = amount;
    let dataCoupons;

    if (hasCoupon && coupons) {
        dataCoupons = await couponModel.find({ code: { $in: coupons }, isActive: true, isDeleted: false, expiryDate: { $gt: new Date() } })
        if (!dataCoupons) {
            return res.status(400).json({ message: "Pas de coupon applicable", status: false });
        }

        if (dataCoupons.length !== coupons.length) {
            return res.status(400).json({ message: "Certains coupons sont invalides", status: false });
        }
        let newAmountc = ApplyCodeToPrice(amount, dataCoupons);

        //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
        dataCoupons[0] = Object.assign({}, dataCoupons[0]._doc, { newAmount: newAmountc, savedAmount: (amount - newAmountc) });
        //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
        newAmount = newAmountc;
    }


    try {
        const session = await stripe.checkout.sessions.create({
            payment_method_types: ['card'],
            line_items: [
                {
                    price_data: {
                        currency: curency || 'eur',
                        product_data: {
                            name: productName || 'review',
                            description: productDescription || 'review description',
                        },
                        unit_amount: newAmount,
                    },
                    quantity: 1,
                },
            ],
            mode: 'payment',
            customer_email: req.user?.email,
            invoice_creation: {
                enabled: true,
                invoice_data: {
                    metadata: {
                        userId: req.user?._id?.toString() || '',
                        source: 'stripe-link',
                    },
                },
            },
            success_url: `https://jatai.fr`,
            cancel_url: `https://jatai.fr`,
        });
        createdTransaction(req, session, newAmount, dispersions, "stripe-link", (hasCoupon && coupons) ? dataCoupons : null);


        res.json({
            status: true,
            data: {
                url: session.url,
                paymentId: session.id
            }
        });
    } catch (err) {
        next(err);
    }
});


stripeapp.post("/check-payment", checkAuthentication, async (req, res) => {

    const { intentId, paymentId } = req.body;

    if (!intentId && !paymentId) {
        return res.status(400).json({
            status: false,
            message: "Payment intent ID is required"
        });
    }
    const { secret_key } = getKeys();
    const stripe = new Stripe(secret_key);
    var paymentIntent;
    try {

        if (paymentId) {
            paymentIntent = await stripe.checkout.sessions.retrieve(paymentId);
        } else {
            paymentIntent = await stripe.paymentIntents.retrieve(intentId);
        }

        let newBalance = req.user.balances;
        // Check the payment intent status
        if (paymentIntent.status === 'succeeded' || paymentIntent.payment_status === 'paid') {

            const transaction = await TransactionSchema.findOneAndUpdate(
                { transaction_id: intentId ?? paymentId },
                { payment_status: 'completed', completedAt: new Date() },
                { new: true }
            );





            if (!transaction) { return res.json({ status: false, message: "Transaction non trouvée" }); }

            if (transaction.dispersion && transaction.dispersion.length > 0) {
                try {
                    // Map dispersion items to promises that fetch plan details
                    const dispersionPromises = transaction.dispersion.map(async (item) => {
                        try {
                            const planDetails = await planModel.findById(item.id);
                            if (!planDetails) { console.warn(`Plan introuvable pour l'ID: ${item.id}`); return item; }

                            if (planDetails._id?.toString() === "68abb489ac5240298a887669" && (item.dis_quantity || 0) > 0) {
                                try {
                                    const amountToAdd = item.dis_quantity || 0;
                                    newBalance = (await User.findByIdAndUpdate(req.user._id, { $inc: { 'balances.procurement': amountToAdd } }, { new: true })).balances;
                                } catch (err) {
                                    console.error('Failed to update user balance:', err);
                                }
                            }
                            if (planDetails._id?.toString() === "68abb80942d054383a78498e" && (item.dis_quantity || 0) > 0) {
                                try {
                                    const amountToAdd = item.dis_quantity || 0;
                                    newBalance = (await User.findByIdAndUpdate(req.user._id, { $inc: { 'balances.simple': amountToAdd } }, { new: true })).balances;
                                } catch (err) {
                                    console.error('Failed to update user balance:', err);
                                }
                            }
                            return {
                                ...item,
                                planDetails: planDetails.toObject(),
                                name: planDetails.name || item.name, description: planDetails.description,
                            };
                        } catch (err) {
                            console.error(`Error fetching plan details for ID ${item.id}:`, err);
                            return item; // Return original item on error
                        }
                    });

                    // Wait for all plan details to be fetched
                    transaction.dispersion = await Promise.all(dispersionPromises);
                } catch (err) {
                    console.error('Failed to process dispersion data:', err);
                }
            }

            //send emails 

            const invoice = await getInvoiceById(intentId ?? paymentId);

            if (transaction.dispersion && transaction.dispersion.length > 0) {
                transaction.dispersion = transaction.dispersion.map(item => {
                    return {
                        ...item,
                        name: getPlanName(item["id"]),
                        quantity: item.dis_quantity,
                        price: item.dis_price.toFixed(2),
                    }
                }
                )
            }


            sendPaymentEmail
                (req.user.email, transaction,
                    {
                        userName: `${req.user.firstName || ''} ${req.user.lastName || ''}`.trim() || req.user.email,
                        transactionLabel: "Achats de crédits JATAI",
                        transactionId: `#${transaction._id}`,
                        transactionDate: new Date(transaction.updatedAt).toLocaleDateString('fr-FR', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit', }),
                        paymentMethodLogoUrl: `https://jatai.fr/payment-methods/${transaction.payment_method}.png`,
                        paymentMethod: `${getPaymentMethodDisplayName(transaction.payment_method)} - ${paymentIntent.payment_method_types ? getPaymentMethodDisplayName(paymentIntent.payment_method_types[0]) : 'N/A'}`,
                        paymentStatus: paymentIntent.status,
                        statusBadgeClass: paymentIntent.status === 'complete' || paymentIntent.status === 'paid' ? 'success-badge' : 'badge-warning',
                        isCreditPurchase: true,
                        creditAmount: transaction.dispersion && transaction.dispersion.length > 0 ? transaction.dispersion.reduce((total, item) => total + (item.dis_quantity || 0), 0) : 0,
                        repartitions: transaction.dispersion || [],
                        basePrice: (transaction.price - (transaction.coupon_amount || 0) - (transaction.tax_amount || 0)).toFixed(2),
                        hasCoupon: transaction.coupon_code ? true : false,
                        couponCode: transaction.meta && transaction.meta.couponData && transaction.meta.couponData.length > 0 ? transaction.meta.couponData.map(c => c.code).join(', ') : '',
                        couponAmount: transaction.meta && transaction.meta.couponData && transaction.meta.couponData.length > 0 ? ((transaction.meta.couponData.reduce((total, c) => total + ((c.savedAmount / 100).toFixed(2) || 0), 0))) : '0.00',
                        hasTax: transaction.tax_amount ? true : false,
                        taxRate: transaction.tax ? transaction.tax.toFixed(2) : '0.00',
                        taxAmount: transaction.tax_amount ? transaction.tax_amount.toFixed(2) : '0.00',
                        totalAmount: transaction.price.toFixed(2),
                        amountUnit: "€",
                        transactionDetails: "Merci pour votre achat de crédits sur JATAI. Vous pouvez maintenant utiliser vos crédits pour accéder à nos services.",
                        invoiceUrl: invoice.invoiceUrl,
                        receiptUrl: invoice.receiptUrl,
                        isReviewPurchase: false,
                        computedDispersion: transaction.dispersion,
                    }
                ).catch(err => {
                    console.error('Failed to send payment email:', err);
                });






            return res.json({
                status: true,
                message: "Payment successful",
                data: {
                    // computedDispersion: transaction.dispersion,
                    newBalance,
                    paymentStatus: "succeeded"
                }
            });
        } else {
            if (paymentId) {
                return res.status(200).json({
                    status: true,
                    data: {
                        paymentStatus: paymentIntent.payment_status,
                        sessionStatus: paymentIntent.status

                    }
                });
            }
            return res.json({
                status: false,
                message: `Payment not successful. Status: ${paymentIntent.status}`,
                data: {
                    payment_status: paymentIntent.status
                }
            });
        }
    } catch (error) {
        console.error("Error checking payment:", error);
        return res.status(500).json({
            status: false,
            message: "Error checking payment",
            error: error.message
        });
    }
})

stripeapp.post("/payment-sheet-subscription", async (_, res) => {
    const { secret_key } = getKeys()

    const stripe = new Stripe(secret_key, {
        apiVersion: "2023-08-16",
        typescript: true
    })

    const customers = await stripe.customers.list()

    // Here, we're getting latest customer only for example purposes.
    const customer = customers.data[0]

    if (!customer) {
        return res.send({
            error: "You have no customer created"
        })
    }

    const ephemeralKey = await stripe.ephemeralKeys.create(
        { customer: customer.id },
        { apiVersion: "2023-08-16" }
    )
    const subscription = await stripe.subscriptions.create({
        customer: customer.id,
        items: [{ price: "price_1L3hcFLu5o3P18Zp9GDQEnqe" }],
        trial_period_days: 3
    })

    if (typeof subscription.pending_setup_intent === "string") {
        const setupIntent = await stripe.setupIntents.retrieve(
            subscription.pending_setup_intent
        )

        return res.json({
            setupIntent: setupIntent.client_secret,
            ephemeralKey: ephemeralKey.secret,
            customer: customer.id
        })
    } else {
        throw new Error(
            "Expected response type string, but received: " +
            typeof subscription.pending_setup_intent
        )
    }
})

stripeapp.post("/ephemeral-key", async (req, res) => {
    const { secret_key } = getKeys()

    const stripe = new Stripe(secret_key, {
        apiVersion: req.body.apiVersion,
        typescript: true
    })

    try {
        let key = await stripe.ephemeralKeys.create(
            { issuing_card: req.body.issuingCardId },
            { apiVersion: req.body.apiVersion }
        )
        return res.send(key)
    } catch (e) {
        console.log(e)
        return res.send({ error: e })
    }
})

stripeapp.post("/issuing-card-details", async (req, res) => {
    const { secret_key } = getKeys()

    const stripe = new Stripe(secret_key, {
        apiVersion: "2023-08-16",
        typescript: true
    })

    try {
        let card = await stripe.issuing.cards.retrieve(req.body.id)

        if (!card) {
            console.log("No card with that ID exists.")
            return res.send({ error: "No card with that ID exists." })
        } else {
            return res.send(card)
        }
    } catch (e) {
        console.log(e)
        return res.send({ error: e })
    }
})

stripeapp.post("/financial-connections-sheet", async (_, res) => {
    const { secret_key } = getKeys()

    const stripe = new Stripe(secret_key, {
        apiVersion: "2023-08-16",
        typescript: true
    })

    const account = await stripe.accounts.create({
        country: "US",
        type: "custom",
        capabilities: {
            card_payments: { requested: true },
            transfers: { requested: true }
        }
    })

    const session = await stripe.financialConnections.sessions.create({
        account_holder: { type: "account", account: account.id },
        filters: { countries: ["US"] },
        permissions: ["ownership", "payment_method"]
    })

    return res.send({ clientSecret: session.client_secret })
})

stripeapp.post("/payment-intent-for-payment-sheet", async (req, res) => {
    const { secret_key } = getKeys()

    const stripe = new Stripe(secret_key, {
        apiVersion: "2023-08-16",
        typescript: true
    })

    try {
        const paymentIntent = await stripe.paymentIntents.create({
            amount: 5099,
            currency: "usd",
            payment_method: req.body.paymentMethodId,
            customer: req.body.customerId
        })

        return res.send({ clientSecret: paymentIntent.client_secret })
    } catch (e) {
        return res.send({ error: e })
    }
})

stripeapp.post("/create-checkout-session", async (req, res) => {
    console.log(`Called /create-checkout-session`)
    const { port } = req.body

    const { secret_key } = getKeys()

    const stripe = new Stripe(secret_key, {
        apiVersion: "2023-08-16",
        typescript: true
    })

    var effectivePort = port ?? 8080
    // Use an existing Customer ID if this is a returning customer.
    const customer = await stripe.customers.create()

    // Use the same version as the SDK
    const ephemeralKey = await stripe.ephemeralKeys.create(
        { customer: customer.id },
        { apiVersion: "2020-08-27" }
    )

    const setupIntent = await stripe.setupIntents.create({
        customer: customer.id
    })

    res.json({
        customer: customer.id,
        ephemeralKeySecret: ephemeralKey.secret,
        setupIntent: setupIntent.client_secret
    })
})

stripeapp.post("/customer-sheet", async (_, res) => {
    const { secret_key } = getKeys()

    const stripe = new Stripe(secret_key, {
        apiVersion: "2023-08-16",
        typescript: true
    })

    // Use an existing Customer ID if this is a returning customer.
    const customer = await stripe.customers.create()

    // Use the same version as the SDK
    const ephemeralKey = await stripe.ephemeralKeys.create(
        { customer: customer.id },
        { apiVersion: "2020-08-27" }
    )

    const setupIntent = await stripe.setupIntents.create({
        customer: customer.id
    })

    res.json({
        customer: customer.id,
        ephemeralKeySecret: ephemeralKey.secret,
        setupIntent: setupIntent.client_secret
    })
})

stripeapp.post("/fetch-payment-methods", async (req, res) => {
    const { secret_key } = getKeys()

    const stripe = new Stripe(secret_key, {
        apiVersion: "2023-08-16",
        typescript: true
    })

    const paymentMethods = await stripe.customers.listPaymentMethods(
        req.body.customerId
    )

    res.json({
        paymentMethods: paymentMethods.data
    })
})

stripeapp.post("/attach-payment-method", async (req, res) => {
    const { secret_key } = getKeys()

    const stripe = new Stripe(secret_key, {
        apiVersion: "2023-08-16",
        typescript: true
    })
    console.log({ customer: req.body.customerId })
    const paymentMethod = await stripe.paymentMethods.attach(
        req.body.paymentMethodId,
        { customer: req.body.customerId }
    )
    console.log("got here")
    res.json({
        paymentMethod
    })
})

stripeapp.post("/detach-payment-method", async (req, res) => {
    const { secret_key } = getKeys()

    const stripe = new Stripe(secret_key, {
        apiVersion: "2023-08-16",
        typescript: true
    })

    const paymentMethod = await stripe.paymentMethods.detach(
        req.body.paymentMethodId
    )

    res.json({
        paymentMethod
    })
})

// Mocks a Database. In your code, you should use a persistent database.
let savedPaymentOptions = new Map()

stripeapp.post("/set-payment-option", async (req, res) => {
    savedPaymentOptions.set(req.body.customerId, req.body.paymentOption)
    res.json({})
})

stripeapp.post("/get-payment-option", async (req, res) => {
    const { secret_key } = getKeys()

    const stripe = new Stripe(secret_key, {
        apiVersion: "2023-08-16",
        typescript: true
    })

    const customerPaymentOption = savedPaymentOptions.get(req.body.customerId)
    res.json({
        savedPaymentOption: customerPaymentOption ?? null
    })
    const session = await stripe.checkout.sessions.create({
        payment_method_types: ["card"],
        line_items: [
            {
                price_data: {
                    currency: "usd",
                    product_data: {
                        name: "Stubborn Attachments",
                        images: ["https://i.imgur.com/EHyR2nP.png"]
                    },
                    unit_amount: 2000
                },
                quantity: 1
            }
        ],
        mode: "payment",
        success_url: `https://checkout.stripe.dev/success`,
        cancel_url: `https://checkout.stripe.dev/cancel`
    })
    return res.json({ id: session.id })
})

stripeapp.use((req, res, next) => {
    res.status(404).send("<h1>Not-Found :-)</h1>");
});
stripeapp.use(errorHandler);

module.exports = stripeapp;