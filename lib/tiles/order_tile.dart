import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/tiles/comprados_tile.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:qr_flutter/qr_flutter.dart';

// ignore: must_be_immutable
class OrderTile extends StatelessWidget {
  String orderId, nomeEmpresa, cidadeEstado;
  String cidadeCollection;

  OrderTile(this.orderId, this.nomeEmpresa, this.cidadeEstado);

  @override
  Widget build(BuildContext context) {
    verificarCidadeCatalao();
    return SingleChildScrollView(
      child: Card(
          elevation: 20,
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                          child: Container(
                            height: 200,
                            width: 200,
                            child: FlareActor(
                              "assets/loading_compreaqui.flr",
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                              animation: "effect",
                            ),
                          ),
                        );
                      else {
                        int status = snapshot.data["status"];

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
                                  Card(
                                      child: (Padding(
                                    padding: EdgeInsets.all(10),
                                    child: (Column(
                                      children: [
                                        Text(
                                          snapshot.data["tipoFrete"],
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          snapshot.data["formaPagamento"] !=
                                                  null
                                              ? snapshot.data["formaPagamento"]
                                              : "",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                                  ))),
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
                                        style:
                                            TextStyle(fontFamily: "QuickSand"),
                                      ),
                                    ),
                                    elevation: 10,
//                                Text(
//                                  "" + _buildProductsText(snapshot.data),
//                                  style: TextStyle(fontSize: 20),
//                                ),,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Situação do Pedido:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      _buildCircle("1", "Aprovado", status, 2),
                                      Container(
                                        height: 1,
                                        width: 20,
                                        color: Colors.transparent,
                                      ),
                                      _buildCircle(
                                          "2",
                                          snapshot.data["tipoFrete"] ==
                                                  "Retirar no estabelecimento"
                                              ? "A Retirar"
                                              : "A caminho",
                                          status,
                                          3),
                                      Container(
                                        height: 1,
                                        width: 20,
                                        color: Colors.transparent,
                                      ),
                                      _buildCircle("3", "Feito", status, 4),
                                      Container(
                                          height: 1,
                                          width: 20,
                                          color: Colors.transparent),
                                    ],
                                  ),
                                  SizedBox(height: 3),
                                  RaisedButton(
                                    color: Colors.black54,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CompradosTile(
                                                      orderId,
                                                      nomeEmpresa,
                                                      cidadeEstado)));
                                    },
                                    child: Text(
                                      "Vizualizar Itens",
                                      style: TextStyle(
                                          fontFamily: "QuickSand",
                                          color: Colors.white),
                                    ),
                                  ),
                                  StreamBuilder(
                                    stream: Firestore.instance
                                        .collection("ConsumidorFinal")
                                        .document(snapshot.data["idEntregador"])
                                        .snapshots(),
                                    builder: (context, snap) {
                                      if (!snap.hasData) {
                                        return Text("");
                                      } else {
                                        return RaisedButton(
                                          color: Colors.black54,
                                          onPressed: snapshot.data[
                                                          "solicitadoEntregador"] ==
                                                      true &&
                                                  snapshot.data["tipoFrete"] ==
                                                      "Entrega Expressa (Karona)"
                                              ? () {
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          InformacoesMotoristas(
                                                              snap.data["photo"]
                                                                  .toString(),
                                                              snap.data["nome"]
                                                                  .toString(),
                                                              snap.data[
                                                                      "placaCarro"]
                                                                  .toString())));
                                                }
                                              : null,
                                          child: Text(
                                            "Ver Entregador",
                                            style: TextStyle(
                                                fontFamily: "QuickSand",
                                                color: Colors.white),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  Text(_recuperarData(snapshot.data)),
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
    );
  }

  verificarCidadeCatalao() {
    if (cidadeEstado == "Catalão - Goias" ||
        cidadeEstado == "Catalão - Goías" ||
        cidadeEstado == "Catalão-Goias" ||
        cidadeEstado == "Catalão-Goías" ||
        cidadeEstado == "Catalão-Goiás" ||
        cidadeEstado == "Catalão-Goiás" ||
        cidadeEstado == "Catalão - Go" ||
        cidadeEstado == "Catalão-Go" ||
        cidadeEstado == "Catalao - Goias" ||
        cidadeEstado == "Catalao - Go" ||
        cidadeEstado == "Catalao-Go" ||
        cidadeEstado == "Catalao-Goias" ||
        cidadeEstado == "Alagoinhas - BA" ||
        cidadeEstado == "Alagoinhas-Bahia") {
      //Corrigir essa linha
      cidadeCollection = "catalaoGoias";
    }
  }
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

// ignore: must_be_immutable
class InformacoesMotoristas extends StatelessWidget {
  String fotoPerfil, nomeMotorista, placaCarro;

  InformacoesMotoristas(this.fotoPerfil, this.nomeMotorista, this.placaCarro);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text("Entregador"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 40,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(100.0),
                    side: BorderSide(color: Colors.white30)),
                child: Container(
                    width: 180.0,
                    height: 180.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(fotoPerfil),
                        ))),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            nomeMotorista,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontFamily: "QuickSand"),
          ),
          Text(
            placaCarro,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontFamily: "QuickSand"),
          )
        ],
      ),
    );
  }
}
