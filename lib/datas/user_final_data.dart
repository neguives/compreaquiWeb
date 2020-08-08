import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserFinalData {
  String nome;
  String id;
  String email;
  String cidade;
  String latitude;
  String logintude;
  DocumentReference get firestoreRef => Firestore.instance.document('users/');

  CollectionReference get cartReference => firestoreRef.collection('cart');

  CollectionReference get tokensReference => firestoreRef.collection('tokens');
  UserFinalData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    email = snapshot.data["email"];
    nome = snapshot.data["nome"];
    cidade = snapshot.data["cidade"];
    latitude = snapshot.data["latitude"];
    logintude = snapshot.data["logintude"];
  }
  Future<void> saveToken() async {
    final token = await FirebaseMessaging().getToken();
    await tokensReference.document(token).setData({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
    });
    print("token com Deus no comando $token");
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "nome": nome,
      "cidade": cidade,
      "email": email,
    };
  }
}
