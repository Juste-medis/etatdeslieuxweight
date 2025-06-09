const nodemailer = require('nodemailer');
const config = require("../config/config");

const sendMail = (data) => {
  return new Promise((resolve, reject) => {
    const transport = nodemailer.createTransport(config.nodemailerTransport);

    transport.verify((error) => {

      if (error) {
        console.log('error while connecting to smtp server');
        reject(error);
      } else {
        transport.sendMail(data, (err, info) => {
          if (err) {
            console.log(`error while sending email to ${data.to} with subject ${data.subject}`);
            reject(err);
          } else {
            console.log(`email sent to ${data.to} with subject ${data.subject}`);
            resolve(info);
          }
        });
      }
    });
  });
};

module.exports = sendMail;
