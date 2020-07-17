import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/tab/listagemItens.dart';
import 'package:compreaidelivery/tiles/comprados_tile.dart';
import 'package:compreaidelivery/versao_empresa/pedidos_recebidos/tiles/comprados_tile.dart';
import 'package:compreaidelivery/widgets/card_produtos_comprados.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:qr_flutter/qr_flutter.dart';

class OrderTile extends StatelessWidget {
  String orderId, nomeEmpresa;

  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    print(orderId);
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Card(
              elevation: 20,
              margin: EdgeInsets.all(50),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: Firestore.instance
                            .collection("Entregador")
                            .document(orderId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          else {
                            return Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
//                            Container(
//                              decoration: new BoxDecoration(
//                                image: new DecorationImage(
//                                  image:
//                                      new AssetImage("assets/fundocustom.png"),
//                                  fit: BoxFit.fill,
//                                ),
//                              ),
//                            ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                      Card(
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "Empresa: " +
                                                snapshot.data["empresa"],
                                            style: TextStyle(
                                                fontFamily: "QuickSand"),
                                          ),
                                        ),
                                        elevation: 10,
//                                Text(
//                                  "" + _buildProductsText(snapshot.data),
//                                  style: TextStyle(fontSize: 20),
//                                ),,
                                      ),
                                      SizedBox(height: 4),
                                      SizedBox(height: 2),
                                      SizedBox(height: 3),
                                      StreamBuilder(
                                        stream: Firestore.instance
                                            .collection(snapshot.data["cidade"]
                                                .toString())
                                            .document(snapshot.data["empresa"])
                                            .collection("ordensSolicitadas")
                                            .document(
                                                snapshot.data["codigoPedido"])
                                            .snapshots(),
                                        builder: (context, snapshot2) {
                                          if (!snapshot2.hasData) {
                                          } else {
                                            return Column(
                                              children: [
                                                Text(
                                                  "R\$" +
                                                      snapshot2
                                                          .data["precoDoFrete"]
                                                          .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: "QuickSand",
                                                      fontSize: 20),
                                                ),
                                                Text(
                                                  snapshot2
                                                      .data["enderecoCliente"]
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(),
                                                ),
                                                StreamBuilder(
                                                  stream: Firestore.instance
                                                      .collection(snapshot2
                                                          .data["clienteId"]
                                                          .toString())
                                                      .snapshots(),
                                                  builder:
                                                      (context, snapshot3) {
                                                    if (!snapshot3.hasData) {
                                                    } else {}
                                                  },
                                                )
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                      RaisedButton(
                                        color: Colors.black54,
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CompradosTileEmpresa(
                                                        orderId,
                                                        nomeEmpresa,
                                                      )));
                                        },
                                        child: Text(
                                          "Vou Entregar",
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }
                        }),
                  )
                ],
              )),
        )
      ],
    );
  }
}

Text _buildProductsText(DocumentSnapshot snapshot) {
  String text = "\n";
  for (LinkedHashMap p in snapshot.data["produtos"]) {
    text += "${p["quantidade"]} x ${p["product"]["title"]} "
        "(R\$ ${p["product"]["preco"].toStringAsFixed(2)})\n"
        "Preferência: ${p["variacao"]}\n";
  }
  text +=
      "\nFrete: R\$ ${snapshot.data["precoDoFrete"].toStringAsFixed(2)}\n\nTotal: R\$ ${snapshot.data["precoTotal"].toStringAsFixed(2)}";

  return Text(text);
}

String _recuperarData(DocumentSnapshot snapshot) {
  String text = "\n";
  text += "\nSolicitação do dia ${snapshot.data["data"]}";

  return text;
}

String _PrecoTotal(DocumentSnapshot snapshot) {
  String text = "\n";
  text += "\nTotal: ${snapshot.data["precoTotal"]}";

  return text;
}

Widget _buildCircle(String title, String subtitle, int status, int thisStatus) {
  Color backColor;
  Widget child;

  if (status < thisStatus) {
    backColor = Colors.grey[500];
    child = Text(
      title,
      style: TextStyle(color: Colors.white, fontSize: 8),
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
