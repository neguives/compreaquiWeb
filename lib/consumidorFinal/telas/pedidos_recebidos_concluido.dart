import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/versao_empresa/pedidos_recebidos/tiles/order_tile_concluido.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PedidosRecebidosConcluido extends StatefulWidget {
  String nomeEmpresa, cidadeEstado;

  PedidosRecebidosConcluido(this.nomeEmpresa, this.cidadeEstado);
  @override
  _PedidosRecebidosConcluidoState createState() =>
      _PedidosRecebidosConcluidoState(nomeEmpresa, cidadeEstado);
}

class _PedidosRecebidosConcluidoState extends State<PedidosRecebidosConcluido> {
  String nomeEmpresa, cidadeEstado;
  _PedidosRecebidosConcluidoState(this.nomeEmpresa, this.cidadeEstado);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      )),
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("catalaoGoias")
            .document(nomeEmpresa)
            .collection("ordensSolicitadas")
            .where("status", isEqualTo: 5)
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
                        .map((doc) =>
                            OrderTileConcluido(doc.documentID, nomeEmpresa))
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
