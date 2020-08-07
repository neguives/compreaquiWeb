import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript
admin.initializeApp(functions.config().firebase);

export const helloWorld = functions.https.onCall((data, context) => {
    return {data: "Hellow from cloud functions !!!"}
});

// export const onNovoPedido = functions.firestore.document("/Alagoinhas-Bahia/{teste}").onCreate((snapshot, context) =>
// {
//     const pedidoId = context.params.teste;
//     console.log(pedidoId);
// });
export const getUserData = functions.https.onCall( async (data, context)  =>{
    if(!context.auth){
        return {
            "data": "Nenhum usuario logado"
        };
    }
    console.log(context.auth.uid);
   const snapshot = await admin.firestore().collection("ConsumidorFinal").doc(context.auth.uid).get();
    console.log(snapshot.data());
   return {
       "data": snapshot.data()
   };
});



export const onNewOrder = functions.firestore.document("Alagoinhas-Bahia/Supermecado Gbarbosa/ordensSolicitadas/{orderId}").onCreate (async(snapshot, context) =>
{

    const orderId = context.params.orderId;

    const querySnapshot = await admin.firestore().collection("ConsumidorFinal").get();

    const admins = querySnapshot.docs.map(doc => doc.id);

    let adminsTokens: string[] = [];
    for(let i = 0 ; i < admins.length; i++){
        const tokensAdmin: string[] = await getDeviceTokens(admins[i]);
        adminsTokens.concat(tokensAdmin);

    }

    console.log(orderId, adminsTokens);




});

 async function getDeviceTokens(uid: string){

    const querySnapshot = await admin.firestore().collection("ConsumidorFinal").doc(uid).collection("tokens").get();

    const tokens = querySnapshot.docs.map(doc => doc.id);
    return tokens;
 }