import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/versao_empresa/pedidos_recebidos/tiles/order_tile_abertos.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PedidosRecebidosAbertos extends StatefulWidget {
  String nomeEmpresa, cidadeEstado;

  PedidosRecebidosAbertos(this.nomeEmpresa, this.cidadeEstado);
  @override
  _PedidosRecebidosAbertosState createState() =>
      _PedidosRecebidosAbertosState(nomeEmpresa, cidadeEstado);
}

DocumentReference docRef;
Firestore firestore;
DateTime currentPhoneDate = DateTime.now(); //DateTime
Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate); //To TimeStamp
DateTime myDateTime = myTimeStamp.toDate(); // TimeStamp to DateTime

Timestamp timestamp;

class _PedidosRecebidosAbertosState extends State<PedidosRecebidosAbertos> {
  String nomeEmpresa, cidadeEstado;
  _PedidosRecebidosAbertosState(this.nomeEmpresa, this.cidadeEstado);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        title: Text(
          "Solicitações Recebidas",
          style: TextStyle(fontFamily: "QuickSand", color: Colors.black),
        ),
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      )),
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("catalaoGoias")
            .document(nomeEmpresa)
            .collection("ordensSolicitadas")
            .where("status", isEqualTo: 3)
            .orderBy("data_query")
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
                              child: Text("Pedidos Não Separados",
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
                            OrderTileAbertos(doc.documentID, nomeEmpresa))
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
