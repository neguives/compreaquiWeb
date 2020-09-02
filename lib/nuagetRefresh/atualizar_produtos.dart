import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/datas/product_data.dart';
import 'package:compreaidelivery/tiles/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AtualizarProdutos extends StatefulWidget {
  String nomeEmpresa;

  AtualizarProdutos(this.nomeEmpresa);
  @override
  _AtualizarProdutosState createState() => _AtualizarProdutosState(nomeEmpresa);
}

class _AtualizarProdutosState extends State<AtualizarProdutos> {
  String nomeEmpresa;

  _AtualizarProdutosState(this.nomeEmpresa);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atualizar Produtos"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("catalaoGoias")
            .document("Supermecado Newton")
            .collection("baseProdutos")
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Card(
                        elevation: 20,
                        child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Text(
                                  snapshot.data.documents.length.toString(),
                                  style: TextStyle(
                                      fontFamily: "QuickSand", fontSize: 30),
                                ),
                                Text(
                                  "produtos atualizados",
                                  style: TextStyle(
                                      fontFamily: "QuickSand",
                                      fontSize: 20,
                                      color: Colors.black45),
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    child: Text("Atualizar Produtos"),
                    onPressed: () async {
                      int quantidade = snapshot.data.documents.length;

                      for (int i = 0; i < quantidade; i++) {
                        ProductData data = ProductData.fromDocument(
                            snapshot.data.documents[i]);
                        var codigoBarra = data.codigoBarras;
                        var preco = data.price;
                        refreshData(codigoBarra, preco);
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  refreshData(String codigoBarra, preco) {
    print("Brazil -- > $codigoBarra Argentina $preco");

    var dataStr = jsonEncode({});
  }
}
