import 'package:flutter/material.dart';

class PerfilLoja extends StatefulWidget {
  @override
  _PerfilLojaState createState() => _PerfilLojaState();
}

class _PerfilLojaState extends State<PerfilLoja> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            "Perfil da Loja",
            style: TextStyle(color: Colors.black87),
          )),
      body: Column(),
    );
  }
}
