import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/datas/product_data.dart';
import 'package:compreaidelivery/tiles/product_tile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart' as dio;

import 'baseDadosProdutos.dart';

class AtualizarProdutos extends StatefulWidget {
  String nomeEmpresa;

  AtualizarProdutos(this.nomeEmpresa);
  @override
  _AtualizarProdutosState createState() => _AtualizarProdutosState(nomeEmpresa);
}

List<BaseDadosProdutos> _searchResult = [];

List<BaseDadosProdutos> _userDetails = [];

class _AtualizarProdutosState extends State<AtualizarProdutos> {
  String nomeEmpresa;
  List data;
  List<Map> filteredList;
  List<BaseDadosProdutos> _baseProdutos;

  refreshData() async {
    var dataStr = jsonEncode({
      "command": "get_products",
    });
    var url = "https://nuage.net.br/lucas/controller.php?data=" + dataStr;

    var result = await http.get(url, headers: {});

    if (result.statusCode == 200) {
      List<BaseDadosProdutos> data = List<BaseDadosProdutos>();
      data = json.decode(result.body);

      print(data[1]);
    }
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.cODIGO.contains("7898197540620"))
        _searchResult.add(userDetail);
      print("teste");
      print(userDetail.vLVARJ);
    });

    setState(() {});
  }

  refreshDataDio() async {
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
    baseProdutos.forEach((element) {
      if (element.cODIGO.contains("7898606723071")) {
        _searchResult.add(element);
        String valor = _searchResult[0].vLVARJ.toString();
        print(valor);
      }
    });
  }

  _AtualizarProdutosState(this.nomeEmpresa);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atualizar Produtos"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("catalaoGoias")
            .document("Supermecado Newton")
            .collection("baseProdutos")
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Card(
                        elevation: 20,
                        child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Text(
                                  snapshot.data.documents.length.toString(),
                                  style: TextStyle(
                                      fontFamily: "QuickSand", fontSize: 30),
                                ),
                                Text(
                                  "produtos atualizados",
                                  style: TextStyle(
                                      fontFamily: "QuickSand",
                                      fontSize: 20,
                                      color: Colors.black45),
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    child: Text("Atualizar Produtos"),
                    onPressed: () async {
                      refreshDataDio();
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

//  Future<String> theRequest() async {
//    var dataStr = jsonEncode({
//      "command": "get_products",
//    });
//    var url = "https://nuage.net.br/lucas/controller.php?data=" + dataStr;
//
//    var response = await http.get(Uri.encodeFull(url));
//
//    setState(() {
//      var getRequestedData = jsonDecode(response.body);
//      data = getRequestedData['parkingFacilities'];
//
//      filteredList = List();
//      for (item in data) {
//        if (item['locationForDisplay'] != null &&
//            item['locationForDisplay']['latitude'] != null &&
//            item['locationForDisplay']['longitude'] != null) {
//          filteredList.add(item);
//        }
//      }
//    });
//  }

}
