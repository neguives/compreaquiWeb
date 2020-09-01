import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/telas/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'geolocalizacaoUsuario.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    configFCM();
    openStartPage();
  }

  void configFCM() {
    final fcm = FirebaseMessaging();

    if (Platform.isIOS) {
      fcm.requestNotificationPermissions(
          const IosNotificationSettings(provisional: true));
    }

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
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/fundocatalao.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: null /* add child content content here */,
          ),
          Center(
            child: Container(
              width: 200,
              height: 200,
              child: Center(
                child: Transform.scale(
                    scale: 1.2, child: Image.asset("assets/logo.png")),
              ),
            ),
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
