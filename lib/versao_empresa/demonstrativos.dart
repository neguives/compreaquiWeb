import 'package:flutter/material.dart';

class Demonstrativos extends StatefulWidget {
  @override
  _DemonstrativosState createState() => _DemonstrativosState();
}

class _DemonstrativosState extends State<Demonstrativos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            "Demonstrativos",
            style: TextStyle(color: Colors.black87),
          )),
      body: Column(),
    );
  }
}
