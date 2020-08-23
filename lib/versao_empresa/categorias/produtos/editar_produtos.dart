import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/versao_empresa/categorias/produtos/product_tile.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditarProdutos extends StatefulWidget {
  String nomeEmpresa, categoria;
  double codigoBarras;

  EditarProdutos(this.nomeEmpresa, this.categoria, this.codigoBarras);
  @override
  _EditarProdutosState createState() =>
      _EditarProdutosState(nomeEmpresa, categoria, codigoBarras);
}

class _EditarProdutosState extends State<EditarProdutos> {
  String nomeEmpresa, categoria;
  double codigoBarras;

  _EditarProdutosState(this.nomeEmpresa, this.categoria, this.codigoBarras);

  @override
  Widget build(BuildContext context) {
    print(nomeEmpresa);
    print(codigoBarras);
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance
          .collection("catalaoGoias")
          .document(nomeEmpresa)
          .collection("produtos")
          .document(categoria)
          .collection("itens")
          .where("codigoBarras", isEqualTo: codigoBarras)
          .getDocuments(),
      builder: (context, snapshot1) {
        if (!snapshot1.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          return Scaffold(
              appBar: AppBar(),
              body: ListView(
                  children: snapshot1.data.documents.map((doc) {
                return ProductTile("list", nomeEmpresa, doc,
                    doc.documentID.toString(), categoria);
              }).toList()));
        }
      },
    );
  }
}
