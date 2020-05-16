import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String id;
  String category;
  String title;
  String description;
  double price, precoAnterior;
  bool promo;
  List images;
  List variacao;
  int quantidade;

  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    price = snapshot.data["price"] + 0.0;
    variacao = snapshot.data["variacao"];
    images = snapshot.data["images"];
    quantidade = snapshot.data["quantidade"];
    promo = snapshot.data["promo"];
    precoAnterior = snapshot.data["precoAnterior"] + 0.0;
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "title": title,
      "description": description,
      "preco": price,
      "quantidade": quantidade,
    };
  }
}
