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


export const onNewUserAdm = functions.firestore.document("/ConsumidorFinal/{consumidor}").onCreate(async (snapshot, context) => {
    
    const nome = snapshot.get('nome');
    
    await sendPushFCM(
        
        "TtpINYnuWrhf0uacumAzLUtcAcC3",
        'Novo Usuário Cadastrado',
        'Nome: '+ nome
    );
});
export const onNewUserAdm2 = functions.firestore.document("/ConsumidorFinal/{consumidor}").onCreate(async (snapshot, context) => {
    
    const nome = snapshot.get('nome');
    
    await sendPushFCM(
        
        "nSB0ERDJwQciO6lEZAUA4H9fA2f2",
        'Novo Usuário Cadastrado',
        'Nome: '+ nome
    );
});
export const onNewUserAdm3 = functions.firestore.document("/ConsumidorFinal/{consumidor}").onCreate(async (snapshot, context) => {
    
    const nome = snapshot.get('nome');
    
    await sendPushFCM(
        
        "Njs1sVyfEUQbka0OGETfIJzRI8Q2",
        'Novo Usuário Cadastrado',
        'Nome: '+ nome
    );
});export const onNewUserAdm4 = functions.firestore.document("/ConsumidorFinal/{consumidor}").onCreate(async (snapshot, context) => {
    
    const nome = snapshot.get('nome');
    
    await sendPushFCM(
        
        "W6Akeyf1oLdJGCyVC5Tx6ZQhKzG3",
        'Novo Usuário Cadastrado',
        'Nome: '+ nome
    );
});
export const onNewPedidoEntregador = functions.firestore.document("/Entregadores/PedidosRecebidos/TempoReal/{empresa}").onCreate(async (snapshot, context) => {
    
    const empresa = snapshot.get('empresa');
    
    await sendPushFCM(
        
        "Entregador",
        'Nova solicitação de coleta e entrega.',
        'Empresa: '+ empresa
    );
});
export const novoPedido = functions.firestore.document("/catalaoGoias/Supermecado Newton/ordensSolicitadas/{consumidor}").onCreate(async (snapshot, context) => {
    
    const valor = snapshot.get('precoTotal');
    const tipoFrete = snapshot.get('tipoFrete');
    const enderecoCliente = snapshot.get('enderecoCliente');
    
    await sendPushFCM(
        
        "supermecadonewton",
        'Você recebeu um novo pedido',
        'Valor total: R$: '+ valor+"\nTipo de Frete: " + tipoFrete + "\nEndereço do Cliente: "+  enderecoCliente
    );
});
export const novoPedidoAdm = functions.firestore.document("/catalaoGoias/Supermecado Newton/ordensSolicitadas/{consumidor}").onCreate(async (snapshot, context) => {
    
    const valor = snapshot.get('precoTotal');
    const tipoFrete = snapshot.get('tipoFrete');
    const enderecoCliente = snapshot.get('enderecoCliente');
    
    await sendPushFCM(
        
        "TtpINYnuWrhf0uacumAzLUtcAcC3",
        'O Supermecado Newton recebeu um novo pedido',
        'Valor total: R$: '+ valor+"\nTipo de Frete: " + tipoFrete + "\nEndereço do Cliente: "+  enderecoCliente
    );
});
export const novoPedidoAdm1 = functions.firestore.document("/catalaoGoias/Supermecado Newton/ordensSolicitadas/{consumidor}").onCreate(async (snapshot, context) => {
    
    const valor = snapshot.get('precoTotal');
    const tipoFrete = snapshot.get('tipoFrete');
    const enderecoCliente = snapshot.get('enderecoCliente');
    
    await sendPushFCM(
        
        "W6Akeyf1oLdJGCyVC5Tx6ZQhKzG3",
        'O Supermecado Newton recebeu um novo pedido',
        'Valor total: R$: '+ valor+"\nTipo de Frete: " + tipoFrete + "\nEndereço do Cliente: "+  enderecoCliente
    );
});
export const novoPedidoAtualizado = functions.firestore.document("/catalaoGoias/Supermecado Newton/ordensSolicitadas/{numeroPedido}").onCreate(async (snapshot, context) => {
    
    const status = snapshot.get('status');
    
    if(status == 5){
        await sendPushFCM(
        
            "supermecadonewton",
            'Atualização do pedido',
            "O pedido foi entregue",
        );
    }
   
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