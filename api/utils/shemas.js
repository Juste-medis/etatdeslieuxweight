const { z } = require('zod');

// Common schemas
const stringSchema = z.string();
const numberSchema = z.number();
const booleanSchema = z.boolean();
const dateSchema = z.date();
const emailSchema = z.string().email();
const urlSchema = z.string().url();
const uuidSchema = z.string().uuid();

// Example of a user schema




const priceSchema = z.object({
    name: z.string().max(2000).optional().default('').nullable(),
    description: z.string().max(1000).optional().default('').nullable(),
    price: z.number().min(0, "Le prix doit être supérieur ou égal à 0").default(0),
    currency: z.string().length(3).toUpperCase().default('EUR'),
    isInterval: z.boolean().default(false),
    status: z.enum(['active', 'inactive']).default('active'),
    inf: z.number().positive().optional().nullable(),
    sup: z.number().positive().optional().nullable(),
    qty: z.number().positive().optional().nullable().default(1),
},).superRefine((data, ctx) => {
    if (!data.isInterval && !data.qty) {
        ctx.addIssue({
            code: z.ZodIssueCode.custom,
            message: "La quantité est requise pour les prix à intervalle.",
            path: ["qty"]
        });
    }
    if (data.isInterval && (data.inf === null || data.sup === null)) {
        ctx.addIssue({
            code: z.ZodIssueCode.custom,
            message: "Les valeurs inférieure et supérieure sont requises pour les prix à intervalle.",
        });
    }
    if (data.isInterval && data.inf && data.sup && data.inf >= data.sup) {
        ctx.addIssue({
            code: z.ZodIssueCode.custom,
            message: "La valeur inférieure doit être inférieure à la valeur supérieure.",
        });
    }
});

const planSchema = z.object({
    name: z.string().min(3,
        "Le nom du plan doit contenir au moins 3 caractères"
    ).max(1000, "Le nom du plan ne doit pas dépasser 50 caractères"),
    icon: z.string().optional().nullable(),
    description: z.string().max(1000).default(''),
    features: z.array(z.string().max(1000)).min(1, "Veuillez ajouter au moins une fonctionnalité"),
    prices: z.array(priceSchema).min(1, "Veuillez ajouter au moins un prix"),
    status: z.enum(['active', 'inactive', 'archived']).default('active'),

});








module.exports = {
    // Exporting  
    planSchema,
    priceSchema,
    stringSchema,
    numberSchema,
    booleanSchema,
    dateSchema,
    emailSchema,
    urlSchema,
    uuidSchema,
    userSchema: z.object({
        id: uuidSchema,
        name: stringSchema.min(1, "Name is required"),
        email: emailSchema,
        age: numberSchema.optional(),
        isActive: booleanSchema.default(true),
        createdAt: dateSchema.default(() => new Date()),
    }),
    signupShema: z.object({
        type: stringSchema.min(0, "Spécifiez le type").default("tenant"),
        firstName: stringSchema.min(1, "Le prénom est requis"),
        lastName: stringSchema.min(1, "Le nom de famille est requis"),
        email: emailSchema,
        password: stringSchema.min(6, "Le mot de passe doit contenir au moins 6 caractères"),
        country_code: stringSchema.min(1, "Le code du pays est requis"),
        phone: stringSchema.min(1, "Le numéro de téléphone est requis"),
        country: stringSchema.min(1, "Le pays est requis"),
        address: stringSchema.optional(),
        dob: stringSchema.optional(),
        placeOfBirth: stringSchema.optional(),
        about: stringSchema.optional()
    }),
    edituserShema: z.object({
        firstName: stringSchema.min(1, "Le prénom est requis"),
        lastName: stringSchema.min(1, "Le nom de famille est requis"),
        email: emailSchema,
        phoneNumber: stringSchema.optional(),
        address: stringSchema.optional(),
        dob: stringSchema.optional(),
        imageUrl: stringSchema.optional(),
        placeOfBirth: stringSchema.optional(),
        password: stringSchema.optional(),
    }),
    signinShema: z.object({
        email: emailSchema,
        password: stringSchema.min(6, "Le mot de passe doit contenir au moins 6 caractères"),
    }),

    tenantShema: z.object({
        lastname: stringSchema.min(1, "Le nom de famille est requis"),
        firstname: stringSchema.min(1, "Le prénom est requis"),
        denomination: stringSchema.optional(),
        type: z.enum(["morale", "physique"]).default("physique"),
        order: numberSchema.default(1),
        email: emailSchema,
        avatar: urlSchema.optional(),
        // dob: stringSchema.min(1, "la date de naissance est requise").transform((val) => new Date(val)),
        placeofbirth: stringSchema.optional(),
        // address: stringSchema.min(1, "L'adresse est requise"),
        // phone: stringSchema.optional(),
        gender: z.enum(["Female", "Male"]).default("Male"),
        comment: stringSchema.optional(),
        is_active: booleanSchema.default(true),
        meta: z.record(z.any()).default({}),
    }),

    moraltenantShema: z.object({
        denomination: stringSchema.optional(),
        type: z.enum(["morale", "physique"]).default("physique"),
        order: numberSchema.default(1),
        email: emailSchema,
        avatar: urlSchema.optional(),
        phone: stringSchema.optional(),
        comment: stringSchema.optional(),
        meta: z.record(z.any()).default({}),
    }),

    emeailuniqunesscheck: z.array(this.tenantShema).refine((people) => {
        const emails = people.map(p => p.email);
        return new Set(emails).size === emails.length;
    }, {
        message: "Les emails doivent être uniques.",
        path: ["email"]
    }),
    couponShema: z.object({
        code: z.string().trim().min(1, "Le code est requis"),
        discount: z.number().min(0.1, "La remise doit être positive"),
        type: z.enum(['percentage', 'fixed', 'free']).default('percentage'),
        expiryDate: z.preprocess(v => v instanceof Date ? v : new Date(v), z.date({
            required_error: "La date d'expiration est requise"
        })),
        minimumAmount: z.number().min(0).optional().nullable(),
        isActive: z.boolean().default(true),
        comments: z.string().trim().optional().nullable(),
        createdBy: z.string().regex(/^[0-9a-fA-F]{24}$/, "Identifiant utilisateur invalide")
    })
};

