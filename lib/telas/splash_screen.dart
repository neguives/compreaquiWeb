import 'package:compreaidelivery/telas/Login.dart';
import 'package:flutter/material.dart';

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
    await Future.delayed(
      Duration(seconds: 6),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      ),
    );
  }

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
                    scale: 1.2,
                    child: Image.asset("assets/logomodificada.png")),
              ),
            ),
          )
        ],
      ),
    );
  }
}
