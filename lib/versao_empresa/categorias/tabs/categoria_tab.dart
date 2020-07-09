import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/versao_empresa/categorias/tiles/categoria_tile.dart';
import 'package:flutter/material.dart';

class CategoriaTab extends StatelessWidget {
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance
          .collection("Catalão - GO")
          .document("Supermecado Bretas")
          .collection("Produtos e Servicos")
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
                return CategoriaTile(doc);
              }).toList())
            ],
          );
        }
      },
    );
  }
}