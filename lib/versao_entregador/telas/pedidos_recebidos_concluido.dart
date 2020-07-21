import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/versao_entregador/tiles/order_tile.dart';
import 'package:compreaidelivery/versao_entregador/tiles/order_tile_concluido.dart';
import 'package:compreaidelivery/versao_entregador/tiles/order_tile_transporte.dart';
import 'package:flutter/material.dart';


class PedidosRecebidosConcluido extends StatefulWidget {
  String uid;

  PedidosRecebidosConcluido(this.uid);
  @override
  _PedidosRecebidosConcluidoState createState() =>
      _PedidosRecebidosConcluidoState(uid);
}

class _PedidosRecebidosConcluidoState
    extends State<PedidosRecebidosConcluido> {
  String uid;
  _PedidosRecebidosConcluidoState(this.uid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      )),
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("Entregadores")
            .document("PedidosRecebidos")
            .collection("Motoristas")
            .document(uid)
            .collection("PedidosConcluidos")
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
                  alignment: Alignment.center,
                  child: (Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: ListView(
                      children: snapshot.data.documents
                          .map(
                              (doc) => OrderTileConcluido(doc.documentID, uid))
                          .toList(),
                    ),
                  )),
                )
              ],
            ));
          }
        },
      ),
    );
  }
}
