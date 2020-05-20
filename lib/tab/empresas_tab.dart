import 'package:carousel_pro/carousel_pro.dart';
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        heroTag: "demoValue",
        elevation: 10,
        highlightElevation: 20,
        focusElevation: 10,
        hoverElevation: 20,
        onPressed: () async {},
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("EmpresasParceiras")
            .where("cidade", arrayContains: cidade)
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            return Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: <Widget>[],
                      )),
                ),
                SizedBox(
                    height: 150.0,
                    width: 350.0,
                    child: Carousel(
                      images: [
                        Image.asset("assets/logo.png"),
                      ],
                      dotSize: 4.0,
                      dotSpacing: 15.0,
                      dotColor: Colors.blueGrey,
                      indicatorBgPadding: 5.0,
                      dotBgColor: Colors.white12,
                      borderRadius: true,
                      moveIndicatorFromBottom: 180.0,
                      noRadiusForIndicator: true,
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 1, top: 20),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Selecione um estabelecimento",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(top: 10),
                      children: snapshot.data.documents.map((doc) {
                        return Column(
                          children: <Widget>[
                            InformacoesEmpresaTile(doc),
                          ],
                        );
                      }).toList()),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
