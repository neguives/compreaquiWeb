import 'package:flutter/material.dart';

class Introducao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(
            child: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/fundocatalao.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: null /* add child content content here */,
            ),
          )
        ],
      ),
    );
  }
}
