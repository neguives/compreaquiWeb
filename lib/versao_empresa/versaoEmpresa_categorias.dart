import 'package:compreaidelivery/versao_empresa/categorias/tabs/categoria_tab.dart';
import 'package:flutter/material.dart';

class VersaoEmpresaCategorias extends StatefulWidget {
  @override
  _VersaoEmpresaCategoriasState createState() =>
      _VersaoEmpresaCategoriasState();
}

class _VersaoEmpresaCategoriasState extends State<VersaoEmpresaCategorias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            "Categorias",
            style: TextStyle(color: Colors.black87),
          )),
      body: CategoriaTab(),
    );
  }
}
