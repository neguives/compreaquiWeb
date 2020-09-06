import 'package:compreaidelivery/nuagetRefresh/baseDadosProdutos.dart';
import 'package:compreaidelivery/tab/products_tabTwo.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SelecaoCategoria extends StatelessWidget {
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;
  List<BaseDadosProdutos> baseDadosProdutos;

  SelecaoCategoria(
      this.nomeEmpresa,
      this.imagemEmpresa,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.telefone,
      this.baseDadosProdutos);
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
      body: ProductTab(nomeEmpresa, imagemEmpresa, cidadeEstado, endereco,
          latitude, longitude, telefone, baseDadosProdutos),
    );
  }
}
