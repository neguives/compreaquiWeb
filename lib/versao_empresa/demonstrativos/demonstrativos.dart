import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/versao_empresa/categorias/tiles/categoria_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Demonstrativos extends StatefulWidget {
  String nomeEmpresa, cidadeEstado;

  Demonstrativos(this.nomeEmpresa, this.cidadeEstado);
  @override
  _DemonstrativosState createState() =>
      _DemonstrativosState(nomeEmpresa, cidadeEstado);
}

class _DemonstrativosState extends State<Demonstrativos> {
  String nomeEmpresa, cidadeEstado;
  double counterTotal = 0;
  double comissao;

  _DemonstrativosState(this.nomeEmpresa, this.cidadeEstado);

  @override
  void initState() {
    // TODO: implement initState
    getTotalProdutos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: new IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            title: Text(
              "Demonstrativos",
              style: TextStyle(color: Colors.black87),
            )),
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance
              .collection("catalaoGoias")
              .document(nomeEmpresa)
              .collection("ordensSolicitadas")
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return LinearProgressIndicator();
            else {
              return Column(
                children: [
                  StreamBuilder(
                    stream: Firestore.instance
                        .collection("catalaoGoias")
                        .document(nomeEmpresa)
                        .snapshots(),
                    builder: (context, snapshot2) {
                      if (!snapshot2.hasData) {
                        return LinearProgressIndicator();
                      } else {
                        return Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                width: 150.0,
                                height: 150.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: new NetworkImage(
                                          snapshot2.data["photo"].toString()),
                                    ))),
                            Text(
                              snapshot2.data["nomeEmpresa"],
                              style: TextStyle(
                                  fontFamily: "QuickSand", fontSize: 26),
                            ),
                            Card(
                                child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Stack(
                                      alignment: Alignment.topCenter,
                                      children: [
                                        Align(
                                            alignment: Alignment.topCenter,
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Todo o Período",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontFamily: "QuickSand"),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Card(
                                                      elevation: 10,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              snapshot
                                                                  .data
                                                                  .documents
                                                                  .length
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 30,
                                                                  fontFamily:
                                                                      "QuickSand"),
                                                            ),
                                                            Text(
                                                              "Pedidos Recebidos",
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontFamily:
                                                                      "QuickSand"),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    FutureBuilder(
                                                      future: Firestore.instance
                                                          .collection(
                                                              "catalaoGoias")
                                                          .document(nomeEmpresa)
                                                          .collection(
                                                              "ordensSolicitadas")
                                                          .where("status",
                                                              isEqualTo: 3)
                                                          .getDocuments(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (!snapshot.hasData)
                                                          return LinearProgressIndicator();
                                                        else {
                                                          return Card(
                                                            elevation: 10,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    snapshot
                                                                        .data
                                                                        .documents
                                                                        .length
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            30,
                                                                        fontFamily:
                                                                            "QuickSand"),
                                                                  ),
                                                                  Text(
                                                                    "Entregas Realizadas",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontFamily:
                                                                            "QuickSand"),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    )
                                                  ],
                                                )
                                              ],
                                            )),
                                      ],
                                    ))),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                      child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: Column(
                                    children: [
                                      Text(
                                        "À receber (periodo atual)",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: "QuickSand"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "R\$ " +
                                                    counterTotal
                                                        .toStringAsFixed(2),
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 30,
                                                    fontFamily: "QuickSand"),
                                              ),
                                              Text(
                                                "Pagamento retido",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontFamily: "QuickSand"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                            ],
                          ))),
                  StreamBuilder(
                    stream: Firestore.instance
                        .collection("catalaoGoias")
                        .document(nomeEmpresa)
                        .snapshots(),
                    builder: (context, snapshot3) {
                      if (!snapshot3.hasData) {
                        return LinearProgressIndicator();
                      } else {
                        final double valorComissao =
                            (counterTotal / 100) * snapshot3.data["comissao"];
                        return Card(
                            child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Align(
                                        alignment: Alignment.topCenter,
                                        child: Column(
                                          children: [
                                            Text(
                                              "Custo de comissão da plataforma",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: "QuickSand",
                                                  color: Colors.green),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              valorComissao.toStringAsFixed(2),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: "QuickSand",
                                                  color: Colors.red),
                                            ),
                                          ],
                                        )),
                                  ],
                                )));
                      }
                    },
                  ),
                ],
              );
            }
          },
        ));
  }

  getTotalProdutos() async {
    Firestore.instance
        .collection("catalaoGoias")
        .document(nomeEmpresa)
        .collection("ordensSolicitadas")
        .snapshots()
        .listen((data) => {
              data.documents
                  .forEach((doc) => counterTotal += (doc["precoDosProdutos"])),
              print("Valor Total $counterTotal")
            });
  }
}
