import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/Bottom/bottom_principal.dart';
import 'package:compreaidelivery/models/cart_model.dart';
import 'package:compreaidelivery/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class PaginaEmpresa extends StatelessWidget {
  List<String> galeriaImages = new List();
  CarouselSlider instance;
  String nomeEmpresa, imagemEmpresa, descricaoEmpresa, whatsapp;
  List galeriaPagina;

  UserModel user;
  PaginaEmpresa(@required this.nomeEmpresa, @required this.imagemEmpresa,
      @required this.descricaoEmpresa, this.galeriaPagina, this.whatsapp);

  @override
  void initState() {
    print(galeriaPagina);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Image.asset("assets/icon_zap.png"),
          elevation: 10,
          highlightElevation: 20,
          focusElevation: 10,
          hoverElevation: 20,
          onPressed: () async {
            var whatsappUrl =
                "whatsapp://send?phone=${whatsapp}&text=${"Olá, vim através do App CompreAqui!"}";
            await canLaunch(whatsappUrl)
                ? launch(whatsappUrl)
                : print(
                    "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
          },
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/fundo_pg_empresa.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: null /* add child content content here */,
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 90),
                    child: Center(
                        child: Card(
                      elevation: 40,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(100.0),
                          side: BorderSide(color: Colors.white30)),
                      child: Container(
                          width: 180.0,
                          height: 180.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(imagemEmpresa),
                              ))),
                    )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    nomeEmpresa,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 60,
                      ),
                      Text(
                        descricaoEmpresa,
                        style: TextStyle(color: Colors.black38),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                      height: 200.0,
                      width: 350.0,
                      child: Carousel(
                        images: [
                          Image.asset("assets/logo.png"),
                          Image.network(galeriaPagina.elementAt(0)),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BottomPrincipal(
                                      nomeEmpresa, imagemEmpresa)));
                            },
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child:
                                    Image.network(galeriaPagina.elementAt(1)),
                              ),
                            ),
                          ),
                          Image.network(galeriaPagina.elementAt(2)),
                        ],
                        dotSize: 4.0,
                        dotSpacing: 15.0,
                        dotColor: Colors.lightGreenAccent,
                        indicatorBgPadding: 5.0,
                        dotBgColor: Colors.green.withOpacity(0.5),
                        borderRadius: true,
                        moveIndicatorFromBottom: 180.0,
                        noRadiusForIndicator: true,
                      )),
                  OutlineButton(
                    hoverColor: Colors.white,
                    highlightColor: Colors.white70,
                    highlightElevation: 10,
                    child: Text('Nova Solicitação'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              BottomPrincipal(nomeEmpresa, imagemEmpresa)));
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
                  SizedBox(
                    width: 200,
                    child: InkWell(
                      child: IconButton(
                        icon: Icon(
                          Icons.keyboard_return,
                          color: Colors.green.shade600,
                        ),
                      ),
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
