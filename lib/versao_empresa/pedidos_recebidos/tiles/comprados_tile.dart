import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/tab/listagemItens.dart';
import 'package:compreaidelivery/widgets/card_produtos_comprados.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CompradosTileEmpresa extends StatelessWidget {
  String orderId, nomeEmpresa, clienteId;
  String cidadeEstado = "Catalão - GO";

  CompradosTileEmpresa(this.orderId, this.nomeEmpresa, this.clienteId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        body: Center(
            child: Card(
                elevation: 20,
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: SingleChildScrollView(
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance
                                .collection(cidadeEstado)
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
                                var currentTime = new DateTime(now.year,
                                    now.month, now.day, now.hour, now.minute);
                                return Center(
                                    child: Column(
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
                                    Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "Frete: R\$ ${snapshot.data["precoDoFrete"].toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              fontSize: 10),
                                        ),
                                      ),
                                      elevation: 10,
//                                Text(
//                                  "" + _buildProductsText(snapshot.data),
//                                  style: TextStyle(fontSize: 20),
//                                ),,
                                    ),
                                    Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "Total: R\$ ${snapshot.data["precoTotal"].toStringAsFixed(2)}",
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
                                    StreamBuilder(
                                      stream: Firestore.instance
                                          .collection("ConsumidorFinal")
                                          .document(clienteId)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return CircularProgressIndicator();
                                        } else {
                                          final nomeCliente =
                                              TextEditingController();
                                          final emailController =
                                              TextEditingController();
                                          nomeCliente.text =
                                              snapshot.data["nome"].toString();
                                          emailController.text =
                                              snapshot.data["email"].toString();
                                          String telefone = snapshot
                                              .data["telefone"]
                                              .toString();
                                          return ExpansionTile(
                                            title:
                                                Text("Informações do Cliente"),
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                      controller: nomeCliente,
                                                      enabled: false,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "WorkSansSemiBold",
                                                          fontSize: 16.0,
                                                          color: Colors.black),
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            "Nome do Cliente",
                                                        labelText:
                                                            "Nome do Cliente",
                                                        hintStyle: TextStyle(
                                                            fontFamily:
                                                                "QuickSand",
                                                            fontSize: 17.0,
                                                            color:
                                                                Colors.black87),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextField(
                                                      controller:
                                                          emailController,
                                                      enabled: false,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "WorkSansSemiBold",
                                                          fontSize: 16.0,
                                                          color: Colors.black),
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText: "E-mail",
                                                        labelText: "E-mail",
                                                        hintStyle: TextStyle(
                                                            fontFamily:
                                                                "QuickSand",
                                                            fontSize: 17.0,
                                                            color:
                                                                Colors.black87),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        FlatButton(
                                                          onPressed: () async {
                                                            var whatsappUrl =
                                                                "whatsapp://send?phone=+55${telefone}&text=${"Olá, sou motorista e vim através do App CompreAqui!"}";
                                                            await canLaunch(
                                                                    whatsappUrl)
                                                                ? launch(
                                                                    whatsappUrl)
                                                                : print(
                                                                    "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                                                          },
                                                          child: Image.asset(
                                                            "assets/icon_zap.png",
                                                            height: 50,
                                                            width: 50,
                                                          ),
                                                        ),
                                                        FlatButton(
                                                          onPressed: () async {
                                                            var mapsAppUrl =
                                                                "https://www.google.com/maps/place/@${snapshot.data["latitude"]},${snapshot.data["longitude"]},17z";
                                                            print(mapsAppUrl);
                                                            await canLaunch(
                                                                    mapsAppUrl)
                                                                ? launch(
                                                                    mapsAppUrl)
                                                                : print(
                                                                    "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                                                          },
                                                          child: Image.asset(
                                                            "assets/maps_usuario.png",
                                                            height: 50,
                                                            width: 50,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                    SizedBox(height: 2),
                                    SizedBox(height: 3),
                                    Text(
                                      "\n\nItens Comprados:",
                                      style: TextStyle(fontFamily: "QuickSand"),
                                    ),
                                    _buildProductsText(snapshot.data)
                                  ],
                                ));
                              }
                            }),
                      )
                    ],
                  ),
                ))));
  }
}

Text _buildProductsText(DocumentSnapshot snapshot) {
  String text = "\n";
  for (LinkedHashMap p in snapshot.data["produtos"]) {
    text += "\n${p["quantidade"]} x ${p["product"]["title"]} "
        "(R\$ ${p["product"]["preco"].toStringAsFixed(2)})\n"
        "Preferência: ${p["variacao"]}\n____________________________________\n";
  }

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
