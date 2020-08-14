import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/drawer/custom_drawer.dart';
import 'package:compreaidelivery/drawer/custom_drawer_entregador.dart';
import 'package:compreaidelivery/tab/empresas_tab.dart';
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

class TelaSelecaoCategoria extends StatelessWidget {
  String cidadeEstado, endereco, imagem, uid;
  double latitude, longitude;
  final enderecoController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool enderecoConfirmado = false;
  TelaSelecaoCategoria(
      {this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.uid});

  @override
  Widget build(BuildContext context) {
    verificarCidadeCatalao();
    return Scaffold(
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
                _firebaseMessaging.subscribeToTopic(snapshot.data["nome"]);
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
                                      snapshot.data["cidade"].toString())));
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
                                  builder: (context) => VersaoEmpresaCategorias(
                                      snapshot.data["nome"].toString(),
                                      snapshot.data["cidade"].toString())));
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
                                    .map(
                                        (doc) => OrderTile(doc.documentID, uid))
                                    .toList(),
                              ),
                            )),
                          )
                        ],
                      );
                    }
                  },
                );
              } else {
                _firebaseMessaging.subscribeToTopic("Deus");
                return Stack(
                  children: <Widget>[
                    Container(
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image:
                              new AssetImage("assets/bg_selecaocategoria.webp"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: null /* add child content content here */,
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Container(
                            height: 320,
                            width: 400,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.white30),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 35),
                                      child: Text(
                                        "O que você está procurando ?",
                                        style: TextStyle(
                                            fontFamily: "QuickSand",
                                            color: Colors.black54),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: <Widget>[
                                          InkWell(
                                              onTap: () {
                                                _showDialogEndereco(context);
                                              },
                                              child: FlatButton(
                                                child: Image.asset(
                                                  "assets/btn_categoria_supermecados.png",
                                                  height: 240,
                                                  width: 150,
                                                ),
                                              )),
                                          InkWell(
                                              onTap: () {
                                                _showDialogEnderecoCat2(
                                                    context);
                                              },
                                              child: FlatButton(
                                                child: Image.asset(
                                                  "assets/btn_categoria_farmacia.png",
                                                  height: 240,
                                                  width: 150,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Transform.scale(
                            scale: 1.2,
                            child: Image.asset(
                              "assets/logo.png",
                              height: 150,
                              width: 150,
                            )),
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 70),
                          child: Container(
                            height: 60,
                            width: 250,
                            child: Card(
                                elevation: 20,
                                color: Colors.white70,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.white30),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: ListTile(
                                    title: Text(
                                      cidadeEstado,
                                      style: TextStyle(fontFamily: "QuickSand"),
                                      textAlign: TextAlign.center,
                                    ),
                                    trailing: Icon(Icons.location_on),
                                  ),
                                )),
                          ),
                        )),
                  ],
                );
              }
            }
          },
        ));
  }

  void _showDialogEndereco(BuildContext context) {
    enderecoController.text = endereco;
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Onde será a sua entrega ?"),
          content: new TextField(
            maxLines: 4,
            controller: enderecoController,
            enabled: true,
            style: TextStyle(
                fontFamily: "WorkSansSemiBold",
                fontSize: 16.0,
                color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Endereço de Entrega",
              labelText: "Endereço de Entrega",
              hintStyle: TextStyle(
                  fontFamily: "QuickSand",
                  fontSize: 17.0,
                  color: Colors.black87),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Confirmo o Endereço"),
              onPressed: () {
                endereco = enderecoController.text;
                enderecoConfirmado = true;
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EmpresasTab(
                        cidade: cidadeEstado,
                        endereco: endereco,
                        latitude: latitude,
                        longitude: longitude,
                        categoria: "Supermecado")));
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogEnderecoCat2(BuildContext context) {
    enderecoController.text = endereco;
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Onde será a sua entrega ?"),
          content: new TextField(
            maxLines: 4,
            controller: enderecoController,
            enabled: true,
            style: TextStyle(
                fontFamily: "WorkSansSemiBold",
                fontSize: 16.0,
                color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Endereço de Entrega",
              labelText: "Endereço de Entrega",
              hintStyle: TextStyle(
                  fontFamily: "QuickSand",
                  fontSize: 17.0,
                  color: Colors.black87),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Confirmo o Endereço"),
              onPressed: () {
                endereco = enderecoController.text;
                enderecoConfirmado = true;
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EmpresasTab(
                        cidade: cidadeEstado,
                        endereco: endereco,
                        latitude: latitude,
                        longitude: longitude,
                        categoria: "Farmácia")));
              },
            ),
          ],
        );
      },
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
        cidadeEstado == "Alagoinhas-Bahia") {
      //Corrigir essa linha
      cidadeEstado = "Catalão-Goias";
    }
  }
}
