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

module.exports = {
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
        type: stringSchema.min(1, "Spécifiez le type"),
        firstName: stringSchema.min(1, "Le prénom est requis"),
        lastName: stringSchema.min(1, "Le nom de famille est requis"),
        email: emailSchema,
        password: stringSchema.min(6, "Le mot de passe doit contenir au moins 6 caractères"),
        country_code: stringSchema.min(1, "Le code du pays est requis"),
        phone: stringSchema.min(1, "Le numéro de téléphone est requis"),
        country: stringSchema.min(1, "Le pays est requis"),
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
        user_newPassword: stringSchema.optional(),
        user_confirmPassword: stringSchema.optional()



    }),
    signinShema: z.object({
        email: emailSchema,
        password: stringSchema.min(6, "Le mot de passe doit contenir au moins 6 caractères"),
    }),

    tenantShema: z.object({
        lastname: stringSchema.min(1, "Le nom de famille est requis"),
        firstname: stringSchema.min(1, "Le prénom est requis"),
        denomination: stringSchema.optional(),
        order: numberSchema.default(1),
        email: emailSchema,
        avatar: urlSchema.optional(),
        dob: stringSchema.min(1, "la date de naissance est requise").transform((val) => new Date(val)),
        placeofbirth: stringSchema.optional(),
        address: stringSchema.min(1, "L'adresse est requise"),
        phone: stringSchema.optional(),
        gender: z.enum(["Female", "Male"]).default("Male"),
        comment: stringSchema.optional(),
        is_active: booleanSchema.default(true),
        meta: z.record(z.any()).default({}),
    }),

    emeailuniqunesscheck: z.array(this.tenantShema).refine((people) => {
        const emails = people.map(p => p.email);
        return new Set(emails).size === emails.length;
    }, {
        message: "Les emails doivent être uniques.",
        path: ["email"]
    })
};