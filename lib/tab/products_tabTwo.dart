import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'categoriesTwo.dart';

class ProductTab extends StatelessWidget {
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;
  ProductTab(
    @required this.nomeEmpresa,
    @required this.imagemEmpresa,
    @required this.cidadeEstado,
    @required this.endereco,
    @required this.latitude,
    @required this.longitude,
    @required this.telefone,
  );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance
          .collection(cidadeEstado)
          .document(nomeEmpresa)
          .collection("produtos")
          .orderBy("pos")
          .getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: Text(nomeEmpresa),
          );
        else {
          return Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.white,
                  Colors.white10,
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              ),
              ListView(
                  children: snapshot.data.documents.map((doc) {
                return CategoryTile(doc, nomeEmpresa, imagemEmpresa,
                    cidadeEstado, endereco, latitude, longitude, telefone);
              }).toList())
            ],
          );
        }
      },
    );
  }
}
