import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/versao_empresa/pedidos_recebidos/tiles/order_tile.dart';
import 'package:flutter/material.dart';

import '../blocs/orders_bloc.dart';

class PedidosRecebidosTransporte extends StatefulWidget {
  String nomeEmpresa;

  PedidosRecebidosTransporte(this.nomeEmpresa);
  @override
  _PedidosRecebidosTransporteState createState() =>
      _PedidosRecebidosTransporteState(nomeEmpresa);
}

class _PedidosRecebidosTransporteState
    extends State<PedidosRecebidosTransporte> {
  String nomeEmpresa;
  _PedidosRecebidosTransporteState(this.nomeEmpresa);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      )),
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("Catalão - GO")
            .document(nomeEmpresa)
            .collection("ordensSolicitadas")
            .where("status", isEqualTo: 2)
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            return Scaffold(
                body: Stack(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new AssetImage("assets/fundo_parceiros.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  /* add child content content here */
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: <Widget>[
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Text("Solicitações Recebidas",
                                  style: TextStyle(
                                      fontFamily: "QuickSand", fontSize: 20)),
                            ),
                            elevation: 5,
                          )
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 70, 16, 1),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data.documents
                        .map((doc) => OrderTile(doc.documentID, nomeEmpresa))
                        .toList(),
                  ),
                )
              ],
            ));
          }
        },
      ),
    );
  }
}