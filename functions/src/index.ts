import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();
// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript






export const getUserData = functions.https.onCall( async (data, context) => {
    if(!context.auth){
        return {
            "data": "Nenhum usuário logado"
        };
    }

    console.log(context.auth.uid);

    const snapshot = await admin.firestore().collection("ConsumidorFinal").doc(context.auth.uid).get();

    console.log(snapshot.data());

    return {
        "data": snapshot.data()
    };
});


export const onNewOrder = functions.firestore.document("/Alagoinhas-Bahia/{empresaId}/ordensSolicitadas/{orderid}").onCreate(async (snapshot, context) => {
    const orderId = context.params.orderId;
    
    const querySnapshot = await admin.firestore().collection("admins").get();

    const admins = querySnapshot.docs.map(doc => doc.id);

    let adminsTokens: string[] = [];
    for(let i = 0; i < admins.length; i++){
        const tokensAdmin: string[] = await getDeviceTokens(admins[i]);
        adminsTokens = adminsTokens.concat(tokensAdmin);
    }

    await sendPushFCM(
        adminsTokens,
        'Novo Pedido',
        'Nova venda realizada. Pedido: ' + orderId
    );
});
async function getDeviceTokens(uid: string){
    const querySnapshot = await admin.firestore().collection("ConsumidorFinal").doc(uid).collection("tokens").get();

    const tokens = querySnapshot.docs.map(doc => doc.id);

    return tokens;
}



export const sendToDevice = functions.firestore
  .document('orders/{orderId}')
  .onCreate(async snapshot => {



    const querySnapshot = await db
      .collection('ConsumidorFinal')
      .doc("Njs1sVyfEUQbka0OGETfIJzRI8Q2")
      .collection('tokens')
      .get();

    const tokens = querySnapshot.docs.map(snap => snap.id);

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Order!',
        body: `you sold a `,
        icon: 'your-icon-url',
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    return fcm.sendToDevice(tokens, payload);
  });
async function sendPushFCM(tokens: string[], title: string, message: string){
    if(tokens.length > 0){
        const payload = {
            notification: {
                title: title,
                body: message,
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };
        return admin.messaging().sendToDevice(tokens, payload);
    }
    return;
}