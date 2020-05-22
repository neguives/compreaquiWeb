import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:qr_flutter/qr_flutter.dart';

class OrderTile extends StatelessWidget {
  String orderId, nomeEmpresa;

  OrderTile(this.orderId, this.nomeEmpresa);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 20,
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance
                      .collection("EmpresasParceiras")
                      .document(nomeEmpresa)
                      .collection("ordensSolicitadas")
                      .document(orderId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    else {
                      int status = snapshot.data["status"];

                      DateTime now = DateTime.now();
                      var currentTime = new DateTime(
                          now.year, now.month, now.day, now.hour, now.minute);
                      return Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  image:
                                      new AssetImage("assets/fundocustom.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Card(
                                  elevation: 10,
                                  child: QrImage(
                                    data: "${snapshot.data.documentID}",
                                    version: QrVersions.auto,
                                    size: 100.0,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Descrição:",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "" + _buildProductsText(snapshot.data),
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Situação do Pedido:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 2),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    _buildCircle("1", "Analisando", status, 1),
                                    Container(
                                      height: 40,
                                      width: 1,
                                      color: Colors.grey[500],
                                    ),
                                    _buildCircle("2", "A caminho", status, 2),
                                    Container(
                                      height: 40,
                                      width: 1,
                                      color: Colors.grey[500],
                                    ),
                                    _buildCircle("3", "Feito", status, 3),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(_recuperarData(snapshot.data))
                              ],
                            )
                          ],
                        ),
                      );
                    }
                  }),
            )
          ],
        ));
  }
}

String _buildProductsText(DocumentSnapshot snapshot) {
  String text = "\n";
  for (LinkedHashMap p in snapshot.data["produtos"]) {
    text += "${p["quantidade"]} x ${p["product"]["title"]} "
        "(R\$ ${p["product"]["preco"].toStringAsFixed(2)})\n"
        "Preferência: ${p["variacao"]}\n";
  }
  text +=
      "\nFrete: R\$ ${snapshot.data["precoDoFrete"].toStringAsFixed(2)}\n\nTotal: R\$ ${snapshot.data["precoTotal"].toStringAsFixed(2)}";

  return text;
}

String _recuperarData(DocumentSnapshot snapshot) {
  String text = "\n";
  text += "\nSolicitação do dia ${snapshot.data["data"]}";

  return text;
}

Widget _buildCircle(String title, String subtitle, int status, int thisStatus) {
  Color backColor;
  Widget child;

  if (status < thisStatus) {
    backColor = Colors.grey[500];
    child = Text(
      title,
      style: TextStyle(color: Colors.white),
    );
  } else if (status == thisStatus) {
    backColor = Colors.blue;
    child = Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        )
      ],
    );
  } else {
    backColor = Colors.green;
    child = Icon(Icons.check);
  }
  return Column(
    children: <Widget>[
      CircleAvatar(
        radius: 20,
        backgroundColor: backColor,
        child: child,
      ),
      Text(subtitle)
    ],
  );
}
