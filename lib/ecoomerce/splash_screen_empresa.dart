import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/Bottom/bottom_principal.dart';
import 'package:compreaidelivery/nuagetRefresh/baseDadosProdutos.dart';
import 'package:compreaidelivery/telas/Login.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreenEmpresa extends StatefulWidget {
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;

  SplashScreenEmpresa(this.nomeEmpresa, this.imagemEmpresa, this.cidadeEstado,
      this.endereco, this.latitude, this.longitude, this.telefone);
  @override
  _SplashScreenEmpresaState createState() => _SplashScreenEmpresaState(
      this.nomeEmpresa,
      this.imagemEmpresa,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.telefone);
}

class _SplashScreenEmpresaState extends State<SplashScreenEmpresa> {
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;
  _SplashScreenEmpresaState(
      this.nomeEmpresa,
      this.imagemEmpresa,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.telefone);
  @override
  void initState() {
    super.initState();
    openStartPage();
  }

  openStartPage() async {
    var dataStr = jsonEncode({
      "command": "get_products",
    });
    var url = "https://nuage.net.br/lucas/controller.php?data=" + dataStr;

    Response response = await Dio().get(url);

//    print(response.data);

    List<BaseDadosProdutos> baseProdutos = List<BaseDadosProdutos>();

    for (Map<String, dynamic> item in response.data) {
      baseProdutos.add(BaseDadosProdutos.fromJson(item));
      print(item);
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => BottomPrincipal(
            nomeEmpresa,
            imagemEmpresa,
            "catalaoGoias",
            endereco,
            latitude,
            longitude,
            telefone,
            baseProdutos)));
  }

  String id;

  DocumentReference get firestoreRef =>
      Firestore.instance.document('ConsumidorFinal/$id');

  CollectionReference get cartReference => firestoreRef.collection('cart');

  CollectionReference get tokensReference => firestoreRef.collection('tokens');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        child: Center(
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.network(imagemEmpresa),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Te desejamos uma ótima compra!",
                        style: TextStyle(
                            fontFamily: "QuickSand",
                            color: Colors.black54,
                            fontSize: 15),
                      ),
                    ],
                  ))),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 200,
                width: 200,
                child: FlareActor(
                  "assets/loading_compreaqui.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "effect",
                ),
              ))
        ],
      ),
    );
  }

  Future<Null> _loadCurrentUser() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser;
    if (firebaseUser == null) {
      print("aqui");
      firebaseUser = await _auth.currentUser();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Login()));
    }
    if (firebaseUser != null) {
      id = firebaseUser.uid;
      final token = await FirebaseMessaging().getToken();
      print("token $token");
      tokensReference.document(token).setData({
        'token': token,
        'updateAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
      });
      print(firebaseUser.uid);
    }
  }
}
