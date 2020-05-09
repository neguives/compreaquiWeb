import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/ecoomerce/products_screen.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot snapshot;
  String nomeEmpresa, imagemEmpresa;
  CategoryTile(
    this.snapshot,
    @required this.nomeEmpresa,
    @required this.imagemEmpresa,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          elevation: 5,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 255, 255, 190),
                  Color.fromARGB(255, 180, 255, 255)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(snapshot.data["icon"]),
                ),
                title: Text(
                  snapshot.data["title"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          Products_Screen(snapshot, nomeEmpresa)));
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
