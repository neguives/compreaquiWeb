import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/tiles/informacoesEmpresaTile.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

// ignore: must_be_immutable
class EmpresasTab extends StatelessWidget {
  String cidade, endereco, categoria;
  double latitude, longitude;
  String cidadeCollection;

  EmpresasTab(
      {Key key,
      @required this.cidade,
      @required this.endereco,
      this.latitude,
      this.longitude,
      this.categoria})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(cidade);
    verificarCidadeCatalao();

    return Scaffold(
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.search),
//        heroTag: "demoValue",
//        elevation: 10,
//        highlightElevation: 20,
//        focusElevation: 10,
//        hoverElevation: 20,
//        onPressed: () async {},
//          ),
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("catalaoGoias")
            .where("categoria", arrayContains: categoria)
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            return Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: EdgeInsets.only(top: 20, left: 1),
                        child: IconButton(
                          onPressed: () {
                            if (Navigator.canPop(context)) {
//                              model.finalizarCompra(nomeEmpresa, endereco);
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(
                            FlutterIcons.left_ant,
                            color: Colors.black,
                          ),
                        ))),
                Column(
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
                        child: snapshot.data.documents.length == 0
                            ? Text(
                                "Nenhuma empresa dessa categoria foi encontrada.",
                                style: TextStyle(
                                    fontSize: 20, fontFamily: "QuickSand"),
                              )
                            : Text(
                                "Selecione um estabelecimento",
                                style: TextStyle(
                                    fontSize: 20, fontFamily: "QuickSand"),
                              ),
                      ),
                    ),
                    snapshot.data.documents.length == 0
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Center(
                              child: Container(
                                height: 200,
                                width: 200,
                                child: FlareActor(
                                  "assets/no_data_found.flr",
                                  alignment: Alignment.center,
                                  fit: BoxFit.contain,
                                  animation: "no_data_found",
                                ),
                              ),
                            ),
                          )
                        : Column(),
                    Expanded(
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(top: 10),
                          children: snapshot.data.documents.map((doc) {
                            return Column(
                              children: <Widget>[
                                InformacoesEmpresaTile(
                                    doc, cidade, endereco, latitude, longitude),
                              ],
                            );
                          }).toList()),
                    ),
                  ],
                )
              ],
            );
          }
        },
      ),
    );
  }

  verificarCidadeCatalao() {
    if (cidade == "Catalão - Goias" ||
        cidade == "Catalão - Goías" ||
        cidade == "Catalão-Goias" ||
        cidade == "Catalão-Goías" ||
        cidade == "Catalão-Goiás" ||
        cidade == "Catalão-Goiás" ||
        cidade == "Catalão - Go" ||
        cidade == "Catalão-Go" ||
        cidade == "Catalao - Goias" ||
        cidade == "Catalao - Go" ||
        cidade == "Catalao-Go" ||
        cidade == "Catalao-Goias") {
      //Corrigir essa linha
      cidade = "catalaoGoias";
    }
  }
}
