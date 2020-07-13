import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditarProdutos extends StatefulWidget {
  String nomeEmpresa, categoria, codigoBarras;

  EditarProdutos(this.nomeEmpresa, this.categoria, this.codigoBarras);
  @override
  _EditarProdutosState createState() =>
      _EditarProdutosState(nomeEmpresa, categoria, codigoBarras);
}

class _EditarProdutosState extends State<EditarProdutos> {
  String nomeEmpresa, categoria, codigoBarras;

  _EditarProdutosState(this.nomeEmpresa, this.categoria, this.codigoBarras);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance
          .collection("Catalão - GO")
          .document(nomeEmpresa)
          .collection("Produtos e Servicos")
          .document(categoria)
          .collection("itens")
          .getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          return Scaffold(
            appBar: AppBar(
              title: Text(categoria),
            ),
          );
        }
      },
    );
    ;
  }
}
