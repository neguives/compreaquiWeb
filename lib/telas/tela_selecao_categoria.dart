import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/drawer/custom_drawer.dart';
import 'package:compreaidelivery/tab/empresas_tab.dart';
import 'package:compreaidelivery/versao_empresa/demonstrativos/demonstrativos.dart';
import 'package:compreaidelivery/versao_empresa/pedidos_recebidos/telas/pedidos_recebidos.dart';
import 'package:compreaidelivery/versao_empresa/perfil_da_loja.dart';
import 'package:compreaidelivery/versao_empresa/produtos.dart';
import 'package:compreaidelivery/versao_empresa/versaoEmpresa_categorias.dart';
import 'package:compreaidelivery/versao_entregador/tiles/order_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaSelecaoCategoria extends StatelessWidget {
  String cidadeEstado, endereco, imagem, uid;
  double latitude, longitude;

  TelaSelecaoCategoria(
      {this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomDrawer(uid),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Padding(
              child: Image.asset(
          'assets/logo.png',
            width: 50,
            height: 50,
          ),
              padding: EdgeInsets.only(right: 50)
              ,
            )],),
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
              return CircularProgressIndicator();
            } else {
              if (snapshot.data["tipoPerfil"].toString() == "Empresa") {
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
                                      snapshot.data["nome"].toString())));
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
                                      snapshot.data["nome"].toString())));
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
                                      snapshot.data["nome"].toString())));
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
                return FutureBuilder<QuerySnapshot>(
                  future: Firestore.instance.collection("Entregador").getDocuments(),
                  builder: (context, snapshot){
                      if(!snapshot.hasData){
                        return Center(
                          child: Text("Nenhum pedido em aberto"),
                        );
                      }
                      else {
                        return Center(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.documents
                                .map((doc) => OrderTile(doc.documentID))
                                .toList(),
                          ),
                        );
                      }
                  },
                );
              } else {
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
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EmpresasTab(
                                                                cidade:
                                                                    cidadeEstado,
                                                                endereco:
                                                                    endereco,
                                                                latitude:
                                                                    latitude,
                                                                longitude:
                                                                    longitude,
                                                                categoria:
                                                                    "Supermecado")));
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
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EmpresasTab(
                                                                cidade:
                                                                    "Catalão - GO",
                                                                endereco:
                                                                    endereco,
                                                                latitude:
                                                                    latitude,
                                                                longitude:
                                                                    longitude,
                                                                categoria:
                                                                    "Farmácia")));
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
                      padding: EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Transform.scale(
                            scale: 1.2,
                            child: Image.asset(
                              "assets/logomodificada.png",
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
}
