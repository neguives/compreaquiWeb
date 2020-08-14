import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';


admin.initializeApp(functions.config().firebase);

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript



export const getUserData = functions.https.onCall( async (data, context) => {
    if(!context.auth){
        return {
            "data": "Nenhum usuário logado"
        };
    }
   
    console.log(context.auth.uid);

    const snapshot = await admin.firestore().collection("users").doc(context.auth.uid).get();

    console.log(snapshot.data());

    return {
        "data": snapshot.data()
    };
});

export const addMessage = functions.https.onCall( async (data, context) => {
    console.log(data);

    const snapshot = await admin.firestore().collection("messages").add(data);

    return {"success": snapshot.id};
});

export const onNewUser = functions.firestore.document("/ConsumidorFinal/{consumidor}").onCreate(async (snapshot, context) => {
    
    const nome = snapshot.get('nome');
    
    await sendPushFCM(
        
        "Deus",
        'Novo Usuário Cadastrado',
        'Nome: '+ nome
    );
});


async function sendPushFCM(topic: string, title: string, message: string){
    if(1> 0){
        const payload = {
            notification: {
                title: title,
                body: message,
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };
        return admin.messaging().sendToTopic(topic, payload);
    }
    return;
}