import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/drawer/custom_drawer.dart';
import 'package:compreaidelivery/drawer/custom_drawer_entregador.dart';
import 'package:compreaidelivery/drawer/custom_drawer_visitante.dart';
import 'package:compreaidelivery/nuagetRefresh/atualizar_produtos.dart';
import 'package:compreaidelivery/versao_empresa/demonstrativos/demonstrativos.dart';
import 'package:compreaidelivery/versao_empresa/pedidos_recebidos/telas/pedidos_recebidos.dart';
import 'package:compreaidelivery/versao_empresa/perfil_da_loja.dart';
import 'package:compreaidelivery/versao_empresa/produtos.dart';
import 'package:compreaidelivery/versao_empresa/versaoEmpresa_categorias.dart';
import 'package:compreaidelivery/versao_entregador/tiles/order_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class TelaSelecaoCategoria extends StatelessWidget {
  String cidadeEstado, endereco, imagem, uid;
  double latitude, longitude;
  final enderecoController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool enderecoConfirmado = false;

  TelaSelecaoCategoria(this.cidadeEstado, this.endereco, this.uid);

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to exit an App'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }

    verificarCidadeCatalao();
    return new WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          print("");
        },
        child: Scaffold(
            drawer: CustomDrawer(uid),
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    child: Image.asset(
                      'assets/logo.png',
                      width: 50,
                      height: 50,
                    ),
                    padding: EdgeInsets.only(right: 50),
                  )
                ],
              ),
              iconTheme: new IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
            body: StreamBuilder(
              stream: Firestore.instance
                  .collection("ConsumidorFinal")
                  .document(uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return LinearProgressIndicator();
                } else {
                  if (snapshot.data["tipoPerfil"].toString() == "Empresa") {
                    if (snapshot.data["nome"] == "Supermecado Newton") {
                      _firebaseMessaging.subscribeToTopic("supermecadonewton");
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 1.0),
                          child: new Padding(
                              padding: EdgeInsets.only(
                                  left: 30, right: 30, top: 30, bottom: 20),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/logo.png',
                                    width: 150,
                                    height: 150,
                                  ),
                                  Text("Versão Parceiro",
                                      style: TextStyle(fontFamily: "QuickSand"))
                                ],
                              )),
                        ),
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PedidosRecebidos(
                                          snapshot.data["nome"].toString(),
                                          cidadeEstado)));
                                },
                                child: FlatButton(
                                  child: Image.asset(
                                    "assets/btn_pedidos_recebidos.png",
                                    height: 140,
                                    width: 140,
                                  ),
                                )),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          VersaoEmpresaCategorias(
                                              snapshot.data["nome"].toString(),
                                              cidadeEstado)));
                                },
                                child: FlatButton(
                                  child: Image.asset(
                                    "assets/btn_produtos.png",
                                    height: 140,
                                    width: 140,
                                  ),
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Demonstrativos(
                                            snapshot.data["nome"].toString(),
                                            snapshot.data["cidade"].toString(),
                                          )));
                                },
                                child: FlatButton(
                                  child: Image.asset(
                                    "assets/btn_demonstrativos.png",
                                    height: 140,
                                    width: 140,
                                  ),
                                )),
                            InkWell(
                                onTap: () async {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AtualizarProdutos(
                                            snapshot.data["nome"].toString(),
                                          )));
                                },
                                child: FlatButton(
                                  child: Image.asset(
                                    "assets/btn_demonstrativos.png",
                                    height: 140,
                                    width: 140,
                                  ),
                                )),
                          ],
                        )
                      ],
                    );
                  } else if (snapshot.data["tipoPerfil"].toString() ==
                      "Entregador") {
                    _firebaseMessaging.subscribeToTopic("Entregador");
                    return FutureBuilder<QuerySnapshot>(
                      future: Firestore.instance
                          .collection("Entregadores")
                          .document("PedidosRecebidos")
                          .collection("TempoReal")
                          .getDocuments(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: (Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: ListView(
                                    children: snapshot.data.documents
                                        .map((doc) =>
                                            OrderTile(doc.documentID, uid))
                                        .toList(),
                                  ),
                                )),
                              )
                            ],
                          );
                        }
                      },
                    );
                  }
                }
              },
            )));
  }

  verificarCidadeCatalao() {
    if (cidadeEstado == "Catalão - Goias" ||
        cidadeEstado == "Catalão - Goías" ||
        cidadeEstado == "Catalão-Goias" ||
        cidadeEstado == "Catalão-Goías" ||
        cidadeEstado == "Catalão-Goiás" ||
        cidadeEstado == "Catalão-Goiás" ||
        cidadeEstado == "Catalao - Goiás" ||
        cidadeEstado == "Catalao -Goiás" ||
        cidadeEstado == "Catalão - Go" ||
        cidadeEstado == "Catalão-Go" ||
        cidadeEstado == "Catalao - Goias" ||
        cidadeEstado == "Catalao - Go" ||
        cidadeEstado == "Catalao-Go" ||
        cidadeEstado == "Alagoinhas-Bahia" ||
        cidadeEstado == "Catalao-Goias") {
      //Corrigir essa linha
      cidadeEstado = "catalaoGoias";
    }
  }
}
