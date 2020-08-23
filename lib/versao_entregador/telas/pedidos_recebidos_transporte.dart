import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/versao_entregador/tiles/order_tile_transporte.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PedidosRecebidosTransporte extends StatefulWidget {
  String uid;

  PedidosRecebidosTransporte(this.uid);
  @override
  _PedidosRecebidosTransporteState createState() =>
      _PedidosRecebidosTransporteState(uid);
}

class _PedidosRecebidosTransporteState
    extends State<PedidosRecebidosTransporte> {
  String uid;
  _PedidosRecebidosTransporteState(this.uid);
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
            .collection("PedidosAceitos")
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
                              (doc) => OrderTileTransporte(doc.documentID, uid))
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
