import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/models/user_model.dart';
import 'package:compreaidelivery/tiles/order_tile.dart';
import 'package:flutter/material.dart';

class OrdersTab extends StatelessWidget {
  String nomeEmpresa, imagemEmpresa;
  OrdersTab(this.nomeEmpresa, this.imagemEmpresa);
  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser.uid;
      print(uid);

      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("ConsumidorFinal")
            .document(uid)
            .collection("ordemPedidos")
            .document("realizados")
            .collection(nomeEmpresa)
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
                      image: new AssetImage("assets/bg_meuspedidos.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  /* add child content content here */
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Column(
                        children: <Widget>[
                          Card(
                            elevation: 40,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(100.0),
                                side: BorderSide(color: Colors.white30)),
                            child: Container(
                                width: 150.0,
                                height: 150.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(imagemEmpresa),
                                    ))),
                          ),
                          Text("Solicitações Realizadas",
                              style: TextStyle(
                                  fontFamily: "QuickSand", fontSize: 25))
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 220, 16, 1),
                  child: ListView(
                    children: snapshot.data.documents
                        .map((doc) => OrderTile(doc.documentID, nomeEmpresa))
                        .toList(),
                  ),
                )
              ],
            ));
          }
        },
      );
    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.remove_shopping_cart,
              size: 80,
              color: Colors.purple,
            ),
            SizedBox(height: 16),
            Text(
              "Faça o login para adicionar produtos!",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            RaisedButton(
              color: Colors.purple,
              onPressed: () {},
              child: Text(
                "Entrar",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          ],
        ),
      );
    }
  }
}
