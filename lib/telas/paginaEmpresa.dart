import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:compreaidelivery/Bottom/bottom_principal.dart';
import 'package:compreaidelivery/models/cart_model.dart';
import 'package:compreaidelivery/models/user_model.dart';
import 'package:compreaidelivery/tab/ordersTab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class PaginaEmpresa extends StatelessWidget {
  List<String> galeriaImages = new List();
  CarouselSlider instance;
  String distanciaReal;
  String nomeEmpresa,
      imagemEmpresa,
      descricaoEmpresa,
      whatsapp,
      cidadeEstado,
      endereco;
  double latitude, longitude, latitudeEmpresa, longitudeEmpresa;
  List galeriaPagina;
  String cidadeCollection;

  UserModel user;
  PaginaEmpresa(
      this.nomeEmpresa,
      this.imagemEmpresa,
      this.descricaoEmpresa,
      this.galeriaPagina,
      this.whatsapp,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.latitudeEmpresa,
      this.longitudeEmpresa);

  void initState() {
    print(galeriaPagina);
  }

  @override
  Widget build(BuildContext context) {
    verificarCidadeCatalao();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Image.asset("assets/icon_zap.png"),
          elevation: 10,
          highlightElevation: 20,
          focusElevation: 10,
          hoverElevation: 20,
          onPressed: () async {
            var whatsappUrl =
                "whatsapp://send?phone=$whatsapp&text=${"Olá, vim através do App CompreAqui!"}";
            await canLaunch(whatsappUrl)
                ? launch(whatsappUrl)
                : print(
                    "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
          },
        ),
        body: ScopedModelDescendant<CartModel>(
          builder: (context, child, model) {
            return Stack(
              children: <Widget>[
                Container(
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage("assets/fundo_pg_empresa.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: null /* add child content content here */
                    ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 40),
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
                            fontFamily: "QuickSand",
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          descricaoEmpresa,
                          textAlign: TextAlign.justify,
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      galeriaPagina.elementAt(0).toString().length > 10
                          ? SizedBox(
                              height: 150.0,
                              width: 350.0,
                              child: Carousel(
                                images: [
                                  Image.network(galeriaPagina.elementAt(0)),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BottomPrincipal(
                                                      nomeEmpresa,
                                                      imagemEmpresa,
                                                      cidadeEstado,
                                                      endereco,
                                                      latitude,
                                                      longitude,
                                                      whatsapp)));
                                    },
                                    child: Container(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image.network(
                                            galeriaPagina.elementAt(1)),
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
                              ))
                          : Text(""),
                      OutlineButton(
                        hoverColor: Colors.white,
                        highlightColor: Colors.white70,
                        highlightElevation: 10,
                        child: Text('Entrar na Loja',
                            style: TextStyle(
                                fontFamily: "QuickSand", fontSize: 12)),
                        onPressed: () async {
                          double laEmpresa = latitudeEmpresa;
                          double longEmpresa = longitudeEmpresa;
                          double distanceInMeters = await Geolocator()
                              .distanceBetween(
                                  latitude, longitude, laEmpresa, longEmpresa);

                          print(distanceInMeters);
                          double distancia = distanceInMeters / 1000;
                          double valorCorrida = (distancia + 1.5) * 2.50 + 2.50;
                          double valorCorridaMinimo =
                              valorCorrida < 7 ? 7.00 : valorCorrida;
                          String valorCorridaNumero =
                              valorCorridaMinimo.toStringAsFixed(2);
                          double valorCorridaCorrigido =
                              double.parse(valorCorridaNumero);
                          print('The distance is: $distancia');
                          print('Valor corrida é: $valorCorridaCorrigido');

                          model.setFreteKarona(valorCorridaCorrigido);
                          print(model.getFreteKarona());
                          model.limparCarrinho(nomeEmpresa, endereco);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BottomPrincipal(
                                  nomeEmpresa,
                                  imagemEmpresa,
                                  "catalaoGoias",
                                  endereco,
                                  latitude,
                                  longitude,
                                  whatsapp)));
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
                      OutlineButton(
                        hoverColor: Colors.white,
                        highlightColor: Colors.white70,
                        highlightElevation: 10,
                        child: Text('Meus Pedidos',
                            style: TextStyle(
                                fontFamily: "QuickSand", fontSize: 12)),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OrdersTab(
                                    nomeEmpresa,
                                    imagemEmpresa,
                                    cidadeEstado,
                                  )));
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
                      OutlineButton(
                        hoverColor: Colors.white,
                        highlightColor: Colors.white70,
                        highlightElevation: 10,
                        child: Text(
                          ' Localização ',
                          style:
                              TextStyle(fontFamily: "QuickSand", fontSize: 12),
                        ),
                        onPressed: () async {
                          var mapsAppUrl =
                              "https://www.google.com/maps/place/@$latitudeEmpresa,$longitudeEmpresa,17z";
                          print(mapsAppUrl);
                          await canLaunch(mapsAppUrl)
                              ? launch(mapsAppUrl)
                              : print(
                                  "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
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
                )
              ],
            );
          },
        ));
  }

  verificarCidadeCatalao() {
    if (cidadeEstado == "Catalão - Goias" ||
        cidadeEstado == "Catalão - Goías" ||
        cidadeEstado == "Catalão-Goias" ||
        cidadeEstado == "Catalão-Goías" ||
        cidadeEstado == "Catalão-Goiás" ||
        cidadeEstado == "Catalão-Goiás" ||
        cidadeEstado == "Catalão - Go" ||
        cidadeEstado == "Catalão-Go" ||
        cidadeEstado == "Catalao - Goias" ||
        cidadeEstado == "Catalao - Go" ||
        cidadeEstado == "Catalao-Go" ||
        cidadeEstado == "Catalao-Goias" ||
        cidadeEstado == "Alagoinhas - BA" ||
        cidadeEstado == "Alagoinhas-Bahia") {
      //Corrigir essa linha
      cidadeCollection = "catalaoGoias";
    }
  }
}
