import * as functions from 'firebase-functions';

let admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

export const helloWorld = functions.https.onRequest((request, response) => {
    console.log("Hi");
    response.send("Hello from Firebase!");
});

export const onMessageCreate = functions.firestore.document('messages/{chatId}/{chatIdC}/{messageId}')
    .onCreate((snapshot, context) => {
        const message = snapshot.data();
        if (message !== undefined) {
            const idTo = message.idTo;
            const idFrom = message.idFrom;
            return snapshot.ref.firestore.collection('users').doc(idTo).get().then((recipientSnapshot) => {
                const recipient = recipientSnapshot.data();
                if (recipient !== undefined) {
                    return snapshot.ref.firestore.collection('users').doc(idFrom).get().then((userSnapshot) => {
                        const user = userSnapshot.data();
                        if (user !== undefined && user.partner === recipient.id) {
                            var messageObject = {
                                notification: {
                                    title: user.name,
                                    body: message.content
                                },
                                apns: {
                                    headers: {
                                        'apns-priority': '10',
                                    },
                                    payload: {
                                        aps: {
                                            sound: 'default',
                                        }
                                    },
                                },
                                token: recipient.token
                            };
                            return admin.messaging().send(messageObject)
                                .then((response: any) => {
                                    console.log('Successfully sent message:', response);
                                })
                                .catch((error: any) => {
                                    console.log('Error sending message:', error);
                                });
                        }
                    });
                } else {
                    return "OK";
                }
            });
        }

        return "OK";
    });