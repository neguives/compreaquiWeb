import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/telas/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nice_button/NiceButton.dart';

import 'geolocalizacaoUsuario.dart';

class RecepcaoUsuarioVisitante extends StatefulWidget {
  @override
  _RecepcaoUsuarioVisitanteState createState() =>
      _RecepcaoUsuarioVisitanteState();
}

class _RecepcaoUsuarioVisitanteState extends State<RecepcaoUsuarioVisitante> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//    configFCM();
//    openStartPage();
  }

  void configFCM() {
    if (Platform.isIOS) {
      final fcm = FirebaseMessaging();

      fcm.requestNotificationPermissions(
          const IosNotificationSettings(provisional: true));

      fcm.configure(
        onLaunch: (Map<String, dynamic> message) async {
          print('onLaunch $message');
        },
        onResume: (Map<String, dynamic> message) async {
          print('onResume $message');
        },
        onMessage: (Map<String, dynamic> message) async {
          showNotification(
            message['notification']['title'] as String,
            message['notification']['body'] as String,
          );
        },
      );
    } else {
      final fcm = FirebaseMessaging();

      fcm.configure(
        onLaunch: (Map<String, dynamic> message) async {
          print('onLaunch $message');
        },
        onResume: (Map<String, dynamic> message) async {
          print('onResume $message');
        },
        onMessage: (Map<String, dynamic> message) async {
          showNotification(
            message['notification']['title'] as String,
            message['notification']['body'] as String,
          );
        },
      );
    }
  }

  void showNotification(String title, String message) {
    Flushbar(
            title: title,
            message: message,
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            isDismissible: true,
            backgroundColor: Theme.of(context).primaryColor,
            duration: const Duration(seconds: 3),
            icon: Image.asset("assets/ic_launcher.png"))
        .show(context);
  }

  openStartPage() async {
    await Future.delayed(Duration(seconds: 3), () => _loadCurrentUser());
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
          Column(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: Transform.scale(
                                scale: 1.2,
                                child: Image.asset("assets/logo.png")),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "#FiqueEmCasa\n e compre conosco!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontFamily: "QuickSand"),
                    ),
                    Column(children: <Widget>[
                      SizedBox(
                          height: 200.0,
                          width: 350.0,
                          child: Carousel(
                            images: [
                              Image.asset("assets/btn_categoria_farmacia.png"),
                              Image.asset(
                                  "assets/btn_categoria_supermecados.png"),
                            ],
                            dotSize: 4.0,
                            dotSpacing: 15.0,
                            dotColor: Colors.white,
                            indicatorBgPadding: 5.0,
                            dotBgColor: Colors.deepPurple.withOpacity(0.5),
                            borderRadius: true,
                            moveIndicatorFromBottom: 180.0,
                            noRadiusForIndicator: true,
                          ))
                    ]),
                    SizedBox(
                      height: 100,
                    ),
                    NiceButton(
                      width: 255,
                      elevation: 8.0,
                      radius: 52.0,
                      text: "Fazer Login",
                      fontSize: 14,
                      textColor: Colors.black87,
                      gradientColors: [Colors.white, Colors.white],
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    NiceButton(
                      width: 255,
                      elevation: 8.0,
                      radius: 52.0,
                      fontSize: 14,
                      text: "Entrar como Visitante",
                      textColor: Colors.black,
                      gradientColors: [Colors.white, Colors.white],
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => GeolocalizacaoUsuario()));
                      },
                    ),
                  ],
                ),
              )
            ],
          )
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
      if (Platform.isIOS) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => GeolocalizacaoUsuario()));
      } else {
        id = firebaseUser.uid;
        final token = await FirebaseMessaging().getToken();
        print("token $token");
        tokensReference.document(token).setData({
          'token': token,
          'updateAt': FieldValue.serverTimestamp(),
          'platform': Platform.operatingSystem,
        });
        print(firebaseUser.uid);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => GeolocalizacaoUsuario()));
      }
    }
  }
}
