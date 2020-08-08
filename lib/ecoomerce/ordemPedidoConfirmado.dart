import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrdemPedidoConfirmado extends StatelessWidget {
  final String orderId;
  final String serverToken =
      '175139261417-6onlqdmdtiso6ccavn2efptrr88apvdo.apps.googleusercontent.com';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  OrdemPedidoConfirmado(this.orderId);

  @override
  Widget build(BuildContext context) {
//    sendAndRetrieveMessage();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        title: Text("Pedido Realizado"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: Container(
                width: 100,
                height: 100,
                child: Center(
                    child: FlareActor("assets/success_check.flr",
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        animation: "Untitled")),
              ),
            ),
            Text(
              "O seu pedido foi realizado com sucesso",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Verifique o Status no menu \"Minhas Solicitações\".",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'this is a body',
            'title': 'this is a title'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': await firebaseMessaging.getToken(),
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }
}
