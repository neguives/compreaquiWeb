import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:qr_flutter/qr_flutter.dart';

// ignore: must_be_immutable
class CompradosTile extends StatelessWidget {
  String orderId, nomeEmpresa, cidadeEstado;

  CompradosTile(this.orderId, this.nomeEmpresa, this.cidadeEstado);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        body: Center(
            child: Card(
                elevation: 20,
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: SingleChildScrollView(
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance
                                .collection("catalaoGoias")
                                .document(nomeEmpresa)
                                .collection("ordensSolicitadas")
                                .document(orderId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              else {
                                return Center(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Card(
                                      elevation: 10,
                                      child: QrImage(
                                        data: "${snapshot.data.documentID}",
                                        version: QrVersions.auto,
                                        size: 100.0,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "Frete: R\$ ${snapshot.data["precoDoFrete"].toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              fontSize: 10),
                                        ),
                                      ),
                                      elevation: 10,
//                                Text(
//                                  "" + _buildProductsText(snapshot.data),
//                                  style: TextStyle(fontSize: 20),
//                                ),,
                                    ),
                                    Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "Total: R\$ ${snapshot.data["precoTotal"].toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontFamily: "QuickSand"),
                                        ),
                                      ),
                                      elevation: 10,
//                                Text(
//                                  "" + _buildProductsText(snapshot.data),
//                                  style: TextStyle(fontSize: 20),
//                                ),,
                                    ),
                                    SizedBox(height: 4),
                                    SizedBox(height: 2),
                                    SizedBox(height: 3),
                                    Text(
                                      "\n\nItens Comprados:",
                                      style: TextStyle(fontFamily: "QuickSand"),
                                    ),
                                    _buildProductsText(snapshot.data)
                                  ],
                                ));
                              }
                            }),
                      )
                    ],
                  ),
                ))));
  }
}

Widget _buildProductsText(DocumentSnapshot snapshot) {
  String text = "\n";
  for (LinkedHashMap p in snapshot.data["produtos"]) {
    text += "\n${p["quantidade"]} x ${p["product"]["title"]} "
        "(R\$ ${p["product"]["preco"].toStringAsFixed(2)})\n"
        "Preferência: ${p["variacao"]}\nCódigo de Barras: ${p["product"]["codigoBarras"]}\n ________________________________________________\n";
  }
  return Text(text);
}
