import 'package:cloud_firestore/cloud_firestore.dart';

class UserFinalData {
  String nome;
  String id;
  String email;
  String cidade;
  String latitude;
  String logintude;

  UserFinalData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    email = snapshot.data["email"];
    nome = snapshot.data["nome"];
    cidade = snapshot.data["cidade"];
    latitude = snapshot.data["latitude"];
    logintude = snapshot.data["logintude"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "nome": nome,
      "cidade": cidade,
      "email": email,
    };
  }
}
