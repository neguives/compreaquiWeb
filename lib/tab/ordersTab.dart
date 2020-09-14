import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/models/user_model.dart';
import 'package:compreaidelivery/tiles/order_tile.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OrdersTab extends StatelessWidget {
  int status;
  String nomeEmpresa, imagemEmpresa, cidadeEstado;
  OrdersTab(this.nomeEmpresa, this.cidadeEstado, this.status);
  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser.uid;

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
                appBar: AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),
                  iconTheme: new IconThemeData(color: Colors.black),
                  backgroundColor: Colors.white,
                ),
                body: Stack(
                  children: <Widget>[
                    Container(
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image:
                              new AssetImage("assets/bg_selecaocategoria.webp"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      /* add child content content here */
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 1),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data.documents
                            .map((doc) => OrderTile(
                                doc.documentID, nomeEmpresa, "catalaoGoias"))
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
