import 'package:compreaidelivery/versao_empresa/categorias/tabs/categoria_tab.dart';
import 'package:flutter/material.dart';

class VersaoEmpresaCategorias extends StatefulWidget {
  String nome;
  VersaoEmpresaCategorias(this.nome);
  @override
  _VersaoEmpresaCategoriasState createState() =>
      _VersaoEmpresaCategoriasState(nome);
}

class _VersaoEmpresaCategoriasState extends State<VersaoEmpresaCategorias> {
  String nome;

  _VersaoEmpresaCategoriasState(this.nome);
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
      body: CategoriaTab(this.nome),
    );
  }
}
