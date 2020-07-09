import 'package:compreaidelivery/tab/products_tabTwo.dart';
import 'package:compreaidelivery/versao_empresa/categorias/tabs/categoria_tab.dart';
import 'package:flutter/material.dart';

class NomeCategoriasExistentes extends StatelessWidget {
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Categorias Existentes",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        centerTitle: true,
      ),
      body: CategoriaTab(),
    );
  }
}
