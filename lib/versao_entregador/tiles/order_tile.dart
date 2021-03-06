import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/versao_entregador/tiles/pedidos_recebidos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class OrderTile extends StatelessWidget {
  String orderId, nomeEmpresa, uid;
  String cidade, empresa, codigoPedido;

  OrderTile(this.orderId, this.uid);

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
                    child: StreamBuilder(
                        stream: Firestore.instance
                            .collection("Entregadores")
                            .document("PedidosRecebidos")
                            .collection("TempoReal")
                            .document(orderId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          else {
                            cidade =
                                snapshot.data["cidade"].toString().length <= 0
                                    ? "Catalão - GO"
                                    : snapshot.data["cidade"];
                            empresa = snapshot.data["empresa"];
                            codigoPedido = snapshot.data["codigoPedido"];
                            return Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      StreamBuilder(
                                        stream: Firestore.instance
                                            .collection(
                                                "catalaoGoias".toString())
                                            .document(snapshot.data["empresa"]
                                                .toString())
                                            .snapshots(),
                                        builder: (context, snapshot2) {
                                          if (!snapshot2.hasData) {
                                            return CircularProgressIndicator();
                                          } else {
                                            return Card(
                                              elevation: 40,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          100.0),
                                                  side: BorderSide(
                                                      color: Colors.white30)),
                                              child: Container(
                                                  width: 100.0,
                                                  height: 100.0,
                                                  decoration: new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image:
                                                          new DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: new NetworkImage(
                                                            snapshot2
                                                                .data["imagem"]
                                                                .toString()),
                                                      ))),
                                            );
                                          }
                                        },
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
                                            .collection("catalaoGoias")
                                            .document(empresa)
                                            .collection("ordensSolicitadas")
                                            .document(codigoPedido)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return CircularProgressIndicator();
                                          } else {
                                            final enderecoController =
                                                TextEditingController();
                                            enderecoController.text = snapshot
                                                .data["enderecoCliente"]
                                                .toString();
                                            return Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Card(
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Preço do frete: ",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "QuickSand",
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              Text(
                                                                "R\$" +
                                                                    snapshot
                                                                        .data[
                                                                            "precoDoFrete"]
                                                                        .toStringAsFixed(
                                                                            2),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
//            fontFamily: "QuickSand",
                                                                        fontSize:
                                                                            20),
                                                              ),
                                                            ],
                                                          )),
                                                      elevation: 10,
//                                Text(
//                                  "" + _buildProductsText(snapshot.data),
//                                  style: TextStyle(fontSize: 20),
//                                ),,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TextField(
                                                  maxLines: 4,
                                                  controller:
                                                      enderecoController,
                                                  enabled: false,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "WorkSansSemiBold",
                                                      fontSize: 16.0,
                                                      color: Colors.black),
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    hintText:
                                                        "Endereço de Entrega",
                                                    labelText:
                                                        "Endereço de Entrega",
                                                    hintStyle: TextStyle(
                                                        fontFamily: "QuickSand",
                                                        fontSize: 17.0,
                                                        color: Colors.black87),
                                                  ),
                                                ),
                                                StreamBuilder(
                                                  stream: Firestore.instance
                                                      .collection(
                                                          "ConsumidorFinal")
                                                      .document(snapshot
                                                          .data["clienteId"])
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
                                                          snapshot.data["nome"]
                                                              .toString();
                                                      emailController.text =
                                                          snapshot.data["email"]
                                                              .toString();
                                                      String telefone = snapshot
                                                          .data["telefone"]
                                                          .toString();
                                                      return ExpansionTile(
                                                        title: Text(
                                                            "Informações do Cliente"),
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            child: Column(
                                                              children: [
                                                                TextField(
                                                                  controller:
                                                                      nomeCliente,
                                                                  enabled:
                                                                      false,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "WorkSansSemiBold",
                                                                      fontSize:
                                                                          16.0,
                                                                      color: Colors
                                                                          .black),
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
                                                                        fontSize:
                                                                            17.0,
                                                                        color: Colors
                                                                            .black87),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextField(
                                                                  controller:
                                                                      emailController,
                                                                  enabled:
                                                                      false,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "WorkSansSemiBold",
                                                                      fontSize:
                                                                          16.0,
                                                                      color: Colors
                                                                          .black),
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(),
                                                                    hintText:
                                                                        "E-mail",
                                                                    labelText:
                                                                        "E-mail",
                                                                    hintStyle: TextStyle(
                                                                        fontFamily:
                                                                            "QuickSand",
                                                                        fontSize:
                                                                            17.0,
                                                                        color: Colors
                                                                            .black87),
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
                                                                      onPressed:
                                                                          () async {
                                                                        var whatsappUrl =
                                                                            "whatsapp://send?phone=+55$telefone&text=${"Olá, sou motorista e vim através do App CompreAqui!"}";
                                                                        await canLaunch(whatsappUrl)
                                                                            ? launch(whatsappUrl)
                                                                            : print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                                                                      },
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/icon_zap.png",
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            50,
                                                                      ),
                                                                    ),
                                                                    FlatButton(
                                                                      onPressed:
                                                                          () async {
                                                                        var mapsAppUrl =
                                                                            "https://www.google.com/maps/place/@${snapshot.data["latitude"]},${snapshot.data["longitude"]},17z";
                                                                        print(
                                                                            mapsAppUrl);
                                                                        await canLaunch(mapsAppUrl)
                                                                            ? launch(mapsAppUrl)
                                                                            : print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                                                                      },
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/maps_usuario.png",
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            50,
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
                                                )
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                      RaisedButton(
                                        color: Colors.black54,
                                        onPressed: () async {
                                          DocumentReference documentReference =
                                              Firestore.instance
                                                  .collection("catalaoGoias")
                                                  .document(empresa)
                                                  .collection(
                                                      "ordensSolicitadas")
                                                  .document(codigoPedido);

                                          DocumentReference documentReference2 =
                                              Firestore.instance
                                                  .collection("Entregadores")
                                                  .document("PedidosRecebidos")
                                                  .collection("TempoReal")
                                                  .document(codigoPedido);

                                          DocumentReference documentReference3 =
                                              Firestore.instance
                                                  .collection("Entregadores")
                                                  .document("PedidosRecebidos")
                                                  .collection("Motoristas")
                                                  .document(uid)
                                                  .collection("PedidosAceitos")
                                                  .document(codigoPedido);

                                          documentReference.updateData({
                                            "status": 4,
                                            "idEntregador": uid,
                                          });

                                          documentReference3.setData({
                                            "codigoPedido": codigoPedido,
                                            "cidade": cidade,
                                            "empresa": empresa,
                                          });
                                          documentReference2.delete();

                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PedidosRecebidos(uid)));
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

Column recuperarDados(String cidade, String codigoPedido, String empresa) {
  return new Column(
    children: [],
  );
}
