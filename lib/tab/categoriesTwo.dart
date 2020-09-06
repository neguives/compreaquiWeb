import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/ecoomerce/products_screen.dart';
import 'package:compreaidelivery/nuagetRefresh/baseDadosProdutos.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryTile extends StatelessWidget {
  final DocumentSnapshot snapshot;
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;
  List<BaseDadosProdutos> baseDadosProdutos;

  CategoryTile(
      this.snapshot,
      this.nomeEmpresa,
      this.imagemEmpresa,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.telefone,
      this.baseDadosProdutos);
  List<BaseDadosProdutos> baseProdutos = List<BaseDadosProdutos>();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          elevation: 5,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 255, 255, 190),
                  Color.fromARGB(255, 180, 255, 255)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(snapshot.data["icon"]),
                ),
                title: Text(
                  snapshot.data["title"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Products_Screen(
                          snapshot,
                          nomeEmpresa,
                          imagemEmpresa,
                          cidadeEstado,
                          endereco,
                          latitude,
                          longitude,
                          telefone,
                          snapshot.data["id_categoria"],
                          baseDadosProdutos)));
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}

Future<dynamic> refreshDataDio() async {
  double valor;
  var dataStr = jsonEncode({
    "command": "get_products",
  });
  var url = "https://nuage.net.br/lucas/controller.php?data=" + dataStr;

  Response response = await Dio().get(url);

//    print(response.data);

  List<BaseDadosProdutos> baseProdutos = List<BaseDadosProdutos>();

  for (Map<String, dynamic> item in response.data) {
    baseProdutos.add(BaseDadosProdutos.fromJson(item));
//      print(item);

  }
  List<BaseDadosProdutos> _searchResult = [];

  List<BaseDadosProdutos> _userDetails = [];

  return baseProdutos;
}
