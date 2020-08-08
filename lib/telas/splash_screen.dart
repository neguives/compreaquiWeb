import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/telas/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import 'geolocalizacaoUsuario.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    openStartPage();
  }

  openStartPage() async {
    await Future.delayed(Duration(seconds: 6), () => _loadCurrentUser());
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
