
const { test, expect } = require('@jest/globals');
const superagent = require("superagent");
const { exec } = require('child_process');

function add(a, b) {
    return a + b;
}

test('additionne 1 + 2 pour obtenir 3', () => {
    expect(add(1, 2)).toBe(3);
});
const userlogging = async () => {
    const req = {
        email: 'medisadido@gmail.com',
        password: '123456'
    };
    const res = await superagent
        .post('http://localhost:5000/api/signin')
        .send(req)
        .set('Accept', 'application/json');

    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('token');
    expect(res.body).toHaveProperty('data.email');
    return res;
}
test("Connexion utilisateur", userlogging);

test("Obtention des informations utilisateur",
    async () => {
        const res = await userlogging();
        const token = res.body.token;
        const user = res.body.data.email;

        const response = await superagent
            .post('http://localhost:5000/api/getuser')
            .set('Authorization', `Bearer ${token}`)
            .set('Accept', 'application/json');

        expect(response.status).toBe(200);
        expect(response.body).toHaveProperty('data');
        expect(response.body.data.email).toBe(user);
    }
);

test("Recherche sur la carte",
    async () => {
        const res = await userlogging();
        const token = res.body.token;

        const response = await superagent
            .post('http://localhost:5000/api/map/search?city=Paris')
            .set('Authorization', `Bearer ${token}`)
            .set('Accept', 'application/json')
            .send({ city: 'Paris' });

        expect(response.status).toBe(200);
        expect(response.body).toHaveProperty('data');
    }
);
test("Obtentions des états des lieux",
    async () => {
        const res = await userlogging();
        const token = res.body.token;

        const response = await superagent
            .get('http://localhost:5000/api/getreviews')
            .set('Authorization', `Bearer ${token}`)
            .set('Accept', 'application/json');

        expect(response.status).toBe(200);
        expect(response.body).toHaveProperty('data');
        expect(Array.isArray(response.body.data)).toBe(true);
    }
);


// test("Vérification de l'authentification",
//     async () => {
//         const res = await userlogging();
//         const token = res.body.token;

//         const response = await superagent
//             .post('http://localhost:5000/api/isverifyaccount')
//             .set('Authorization', `Bearer ${token}`)
//             .set('Accept', 'application/json');

//         expect(response.status).toBe(200);
//         expect(response.body).toHaveProperty('data');
//         expect(response.body.data.isVerified).toBe(true);
//     }
// );
// test("Inscription utilisateur",
//     async () => {
//         const req = {
//             username: 'testuser',
//             email: 'angelleadido@gmail.com',
//             password: '123456',
//             firstName: 'Angelle',
//             lastName: 'Adido',
//             phone: '1234567890'
//         };
//         const response = await superagent
//             .post('http://localhost:5000/api/signup')
//             .send(req)
//             .set('Accept', 'application/json');
//         expect(response.status).toBe(200);
//         expect(response.body).toHaveProperty('token');
//         expect(response.body).toHaveProperty('data.email');
//         expect(response.body.data.email).toBe(req.email);
//         expect(response.body.data.firstName).toBe(req.firstName);
//         expect(response.body.data.lastName).toBe(req.lastName);
//         expect(response.body.data.phone).toBe(req.phone);
//     });



