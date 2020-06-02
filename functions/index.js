const functions = require('firebase-functions');
const admin = require('firebase-admin');

const serviceAccount = require("D:/FlutProjects/FitnessTracker/atraxs-firebase-adminsdk-o91k4-0d977a08e3.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://atraxs.firebaseio.com"
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions

// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });