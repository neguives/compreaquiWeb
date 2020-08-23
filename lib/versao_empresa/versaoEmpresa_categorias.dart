import 'package:compreaidelivery/versao_empresa/categorias/tabs/categoria_tab.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class VersaoEmpresaCategorias extends StatefulWidget {
  String nome, cidadeEstado;
  VersaoEmpresaCategorias(this.nome, this.cidadeEstado);
  @override
  _VersaoEmpresaCategoriasState createState() =>
      _VersaoEmpresaCategoriasState(nome, cidadeEstado);
}

class _VersaoEmpresaCategoriasState extends State<VersaoEmpresaCategorias> {
  String nome, cidadeEstado;

  _VersaoEmpresaCategoriasState(this.nome, this.cidadeEstado);
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
      body: CategoriaTab(nome, cidadeEstado),
    );
  }
}
