import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/versao_empresa/categorias/tiles/categoria_tile.dart';
import 'package:flutter/material.dart';

class Demonstrativos extends StatefulWidget {
  String nomeEmpresa;

  Demonstrativos(this.nomeEmpresa);
  @override
  _DemonstrativosState createState() => _DemonstrativosState(nomeEmpresa);
}

class _DemonstrativosState extends State<Demonstrativos> {
  String nomeEmpresa;

  _DemonstrativosState(this.nomeEmpresa);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            "Demonstrativos",
            style: TextStyle(color: Colors.black87),
          )),
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("Catalão - GO")
            .document(nomeEmpresa)
            .collection("Produtos e Servicos")
            .orderBy("pos")
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return LinearProgressIndicator();
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
                      return CategoriaTile(doc, nomeEmpresa);
                    }).toList())
              ],
            );
          }
        },
      )
    );
  }
}
