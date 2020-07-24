import 'package:compreaidelivery/ecoomerce/ordemPedidoConfirmado.dart';
import 'package:compreaidelivery/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:math' show cos, sqrt, asin;

class CartResumo extends StatelessWidget {
  String nomeEmpresa, cidadeEstado, endereco;
  double latitude, longitude;
  final VoidCallback buy;

  CartResumo(this.buy, this.nomeEmpresa, this.cidadeEstado, this.endereco,
      this.latitude, this.longitude);
  final TextEditingController _startCoordinatesTextController =
      TextEditingController();
  final TextEditingController _endCoordinatesTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> _onCalculatePressed() async {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

      var distanceBetweenPoints = SphericalUtil.computeAngleBetween(
          LatLng(position.latitude, position.longitude),
          LatLng(-12.9704, -38.5124));

      double distanceInMeters = await Geolocator().distanceBetween(
          position.latitude, position.longitude, -12.9704, -38.5124);

      double distancia = distanceInMeters / 1000;
      String distanciaReal = distancia.toStringAsFixed(1);
      print('The distance is: $distanciaReal');
    }

    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }

    return Column(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Container(
              padding: EdgeInsets.all(16.0),
              child: ScopedModelDescendant<CartModel>(
                builder: (context, child, model) {
                  double preco = model.getProductPrice();
                  double desconto = model.getDesconto();
                  double frete = model.getFrete();
//              model.loadCartItens();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "Entrega do Pedido",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Entrega Expressa (envio imediato)"),
                          Text("R\$ ${frete.toStringAsFixed(2)}"),
                        ],
                      ),
                      Divider(
                        color: Colors.brown,
                      ),

//                      OutlineButton(
//                        hoverColor: Colors.white,
//                        highlightColor: Colors.white70,
//                        highlightElevation: 10,
//
//                        onPressed: () {
//                          {
//                            model.finalizarCompra(
//                                nomeEmpresa, endereco, cidadeEstado);
//                            Navigator.of(context).pushReplacement(
//                                MaterialPageRoute(
//                                    builder: (context) =>
//                                        OrdemPedidoConfirmado("1")));
//                          }
//                        },
//
//                        child: Text(
//                          'Finalizar (pagar pessoalmente)',
//                        ),
//
//                        shape: RoundedRectangleBorder(
//                            borderRadius: new BorderRadius.circular(18.0),
//                            side: BorderSide(
//                                color: Colors
//                                    .white30)), // callback when button is clicked
//                        borderSide: BorderSide(
//                          color: Colors.blueGrey, //Color of the border
//                          style: BorderStyle.solid, //Style of the border
//                          width: 0.8, //width of the border
//                        ),
//                      ),
                    ],
                  );
                },
              )),
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Container(
              padding: EdgeInsets.all(16.0),
              child: ScopedModelDescendant<CartModel>(
                builder: (context, child, model) {
                  double preco = model.getProductPrice();
                  double desconto = model.getDesconto();
                  double frete = model.getFrete();
//              model.loadCartItens();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "Resumo do Pedido",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Subtotal"),
                          Text("R\$ ${preco.toStringAsFixed(2)}"),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Desconto"),
                          Text("- R\$ ${desconto.toStringAsFixed(2)}"),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Entrega"),
                          Text("R\$ ${frete.toStringAsFixed(2)}"),
                        ],
                      ),
                      Divider(
                        color: Colors.brown,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Total",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          Text(
                            "R\$ ${(preco + frete - desconto).toStringAsFixed(2)}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          )
                        ],
                      ),
                    ],
                  );
                },
              )),
        ),
      ],
    );
  }

  calcularDistancia() async {
    double distanceInMeters = await Geolocator()
        .distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);

    print(distanceInMeters.toString() + " Metros");
  }
}
