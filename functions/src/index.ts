import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

//sending topics subscribe
export const sendToTopic = functions.firestore
    .document('puppies/{puppyId}')
    .onCreate(async snapshot => {
        const puppy = snapshot.data();

        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: 'New Puppy!',
                body: puppy.name + ' is ready for adoption',
                icon: 'default',
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        }

        return fcm.sendToTopic('puppies', payload);
    });

export const sendToDevice = functions.firestore
    .document('notifications/{userId}/noti/{notificationId}')
    .onCreate(async snapshot => {
        const notificationData = snapshot.data();

        const notiTo = notificationData.to;

        console.log("We have a notification to send to ", notiTo);

        const notiFrom = notificationData.from;
        const notiTitle = notificationData.title;
        const notiMsg = notificationData.msg;
        const notiType = notificationData.type;
        const notiScreen = notificationData.screen;

        await db
            .collection('tokens')
            .doc(notiTo)
            .get()
            // tslint:disable-next-line: no-shadowed-variable
            .then(snapshot => {
                console.log(snapshot.data());
                const token = snapshot.get("token");

                console.log(token);

                const payload: admin.messaging.MessagingPayload = {
                    notification: {
                        title: notiTitle,
                        body: notiMsg,
                        sound: "test.mp3",
                        icon: 'default',
                        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                    },

                    data: {
                        "body": notiMsg,
                        "title": notiTitle,
                        "click_action": "FLUTTER_NOTIFICATION_CLICK",
                        "from_sender": notiFrom,
                        "type": notiType,
                        "screen": notiScreen,
                    }
                }

                return fcm.sendToDevice(token, payload);
            })
            .catch(error => {
                console.log("Error occured " + error);
            });
    });