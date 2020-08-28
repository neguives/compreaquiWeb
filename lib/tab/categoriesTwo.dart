import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/ecoomerce/products_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryTile extends StatelessWidget {
  final DocumentSnapshot snapshot;
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;
  CategoryTile(
    this.snapshot,
    this.nomeEmpresa,
    this.imagemEmpresa,
    this.cidadeEstado,
    this.endereco,
    this.latitude,
    this.longitude,
    this.telefone,
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
                      builder: (context) => Products_Screen(
                          snapshot,
                          nomeEmpresa,
                          imagemEmpresa,
                          cidadeEstado,
                          endereco,
                          latitude,
                          longitude,
                          telefone,
                          snapshot.data["id_categoria"])));
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
