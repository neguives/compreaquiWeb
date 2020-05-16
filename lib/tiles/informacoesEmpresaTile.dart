import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/telas/paginaEmpresa.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InformacoesEmpresaTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  InformacoesEmpresaTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          color: Colors.transparent,
          elevation: 5,
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PaginaEmpresa(
                          snapshot.data["nomeEmpresa"],
                          snapshot.data["imagem"],
                          snapshot.data["descricao"],
                          snapshot.data["galeriaPagina"],
                          snapshot.data["telefone"])));
                },
                child: Container(
                    width: 200,
                    height: 300,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: new AssetImage("assets/fundocurto.png"),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 60),
                              child: Center(
                                  child: Card(
                                elevation: 70,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(120.0),
                                    side: BorderSide(color: Colors.white30)),
                                child: Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: new NetworkImage(
                                              snapshot.data["imagem"]),
                                        ))),
                              )),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                snapshot.data["nomeEmpresa"],
                                style: TextStyle(
                                  fontFamily: "assets/fonts/GillSansLight.ttf",
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                snapshot.data["tipoNegocio"],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "assets/fonts/GillSansLight.ttf",
                                  color: Colors.black26,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                snapshot.data["descricao"],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "assets/fonts/GillSansLight.ttf",
                                  color: Colors.black26,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            OutlineButton(
                              hoverColor: Colors.white,
                              highlightColor: Colors.white70,
                              highlightElevation: 10,
                              child: Container(
                                width: 130,
                                height: 30,
                                child: Row(
                                  children: <Widget>[
                                    Text('Fazer Compras'),
                                    Icon(
                                      FontAwesomeIcons.cartPlus,
                                      color: Colors.green.shade300,
                                    )
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PaginaEmpresa(
                                        snapshot.data["nomeEmpresa"],
                                        snapshot.data["imagem"],
                                        snapshot.data["descricao"],
                                        snapshot.data["galeriaPagina"],
                                        snapshot.data["telefone"])));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.white30)),
                              // callback when button is clicked
                              borderSide: BorderSide(
                                color: Colors.blueGrey, //Color of the border
                                style: BorderStyle.solid, //Style of the border
                                width: 0.8, //width of the border
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 60,
                          height: 70,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Card(
                                elevation: 40,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(90.0),
                                    side: BorderSide(color: Colors.white30)),
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(snapshot.data["classificacao"]
                                          .toString()),
                                      Icon(
                                        Icons.stars,
                                        color: Colors.amber,
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ],
                    )),
              )
            ],
          ),
        )
      ],
    );
  }
}
