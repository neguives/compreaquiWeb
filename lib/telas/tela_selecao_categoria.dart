import 'package:carousel_pro/carousel_pro.dart';
import 'package:compreaidelivery/drawer/custom_drawer.dart';
import 'package:compreaidelivery/tab/empresas_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/bg_selecaocategoria.webp"),
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
                                              builder: (context) => EmpresasTab(
                                                  cidade: cidadeEstado,
                                                  endereco: endereco,
                                                  latitude: latitude,
                                                  longitude: longitude,
                                                  categoria: "Supermecado")));
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
                                              builder: (context) => EmpresasTab(
                                                  cidade: "Catalão - GO",
                                                  endereco: endereco,
                                                  latitude: latitude,
                                                  longitude: longitude,
                                                  categoria: "Farmácia")));
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
      ),
    );
  }
}
