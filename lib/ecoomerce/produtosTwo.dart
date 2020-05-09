import 'package:compreaidelivery/tab/products_tabTwo.dart';
import 'package:flutter/material.dart';

class SelecaoCategoria extends StatelessWidget {
  String nomeEmpresa, imagemEmpresa;
  SelecaoCategoria(
    @required this.nomeEmpresa,
    @required this.imagemEmpresa,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Selecione uma Categoria",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        centerTitle: true,
      ),
      body: ProductTab(nomeEmpresa, imagemEmpresa),
    );
  }
}
