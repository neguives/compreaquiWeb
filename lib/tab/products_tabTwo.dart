import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/nuagetRefresh/baseDadosProdutos.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import 'categoriesTwo.dart';

// ignore: must_be_immutable
class ProductTab extends StatelessWidget {
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;
  List<BaseDadosProdutos> baseDadosProdutos;

  ProductTab(
      this.nomeEmpresa,
      this.imagemEmpresa,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.telefone,
      this.baseDadosProdutos);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance
          .collection(cidadeEstado)
          .document(nomeEmpresa)
          .collection("categorias")
          .orderBy("pos")
          .getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: Container(
            height: 200,
            width: 200,
            child: FlareActor(
              "assets/fruit_loading.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "move",
            ),
          ));
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
                return CategoryTile(
                    doc,
                    nomeEmpresa,
                    imagemEmpresa,
                    cidadeEstado,
                    endereco,
                    latitude,
                    longitude,
                    telefone,
                    baseDadosProdutos);
              }).toList())
            ],
          );
        }
      },
    );
  }
}
