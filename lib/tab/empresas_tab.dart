import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/tiles/informacoesEmpresaTile.dart';
import 'package:flutter/material.dart';

class EmpresasTab extends StatelessWidget {
  final String cidade, endereco;
  TextEditingController _senhaController = TextEditingController();

  EmpresasTab({Key key, @required this.cidade, @required this.endereco})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection("EmpresasParceiras")
                .where("cidade", arrayContains: "Alagoinhas-Bahia")
                .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else {
                return Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            Colors.green.shade100,
                            Colors.white10,
                            Colors.white10,
                            Colors.white10,
                            Colors.white10,
                            Colors.white10,
                            Colors.white10,
                          ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Você está em $cidade",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black54),
                              ),
                              Text(
                                "Endereço: $endereco",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Text(
                                  "Supermecados na sua localidade",
                                  style: TextStyle(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(40),
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(top: 130),
                          children: snapshot.data.documents.map((doc) {
                            return Column(
                              children: <Widget>[
                                InformacoesEmpresaTile(doc),
                              ],
                            );
                          }).toList()),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
