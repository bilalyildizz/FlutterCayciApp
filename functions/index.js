const functions = require("firebase-functions");
const admin = require("firebase-admin");
// const {firestore} = require("firebase-admin");
admin.initializeApp(functions.config().firebase);
/* eslint no-var: off*/
var database = admin.database();


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
/* eslint no-var: off*/


exports.updateUser = functions.firestore
    .document("users/{userId}")
    .onWrite((change, context) => {
      const newValue = change.after.data();
      const name = newValue.username;
      const token = newValue.notificationToken;
      const notificationStatus= newValue.notification;
      const renk= newValue.renk;
      const id= context.params.userId;

      /* eslint no-var: off*/


      const payload = {
        notification: {
          body: name,
        },
        data: {
          id: id,
        },
      };
      if (notificationStatus==true) {
        if (renk==3) {
          admin.messaging()
          /* eslint-disable max-len*/
              .sendToDevice(token, payload)
              .then(function(response) {
                console.log("Successfully sent message: "+response);
                return;
              })
              .catch(function(error) {
                console.log("Error sending message:" + error);
              });
        }
      }


      // perform desired operations ...
    });


exports.newNodeDetected = functions.database.ref("users/{userId}/Name")
    .onWrite((change, context) => {
      /* eslint no-var: off*/
      var oldName = change.before.val();
      var newName = change.after.val();
      var userId = context.params.userId;
      database.ref("metadata/lastChange/")
          .set(userId + "changed  " + oldName + "to" + newName);

      /* eslint no-var: off*/


      const payload = {
        notification: {
          title: "expiryDate",
          body: "accessToken",
          sound: "default",
          badge: "1",
        },
        data: {
          deneme: "deneme",
        },
      };
      admin.messaging()
      /* eslint-disable max-len*/
          .sendToDevice("cbgkaHHwTbWsDLnA3Zv1no:APA91bHIJrlEJpwEY1aj5XhifJOB4zppIRZoHv2IwihGmEeQWk_uLF0YrhaZ-UcSATl4voW7v_1MwmeHsOi31ah5iOH9qZ9eFqOd5TyR7J3Z-AOeRHi7JP_QCbxXGML-bGKtM_9vF4qO", payload)
          .then(function(response) {
            console.log("Successfully sent message: "+response);
            return;
          })
          .catch(function(error) {
            console.log("Error sending message:" + error);
          });
    });
