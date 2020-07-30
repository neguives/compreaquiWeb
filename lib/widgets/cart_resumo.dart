import 'package:compreaidelivery/ecoomerce/ordemPedidoConfirmado.dart';
import 'package:compreaidelivery/models/CreditCardModel.dart';
import 'package:compreaidelivery/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cielo/flutter_cielo.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:math' show cos, sqrt, asin;

class CardResumo extends StatefulWidget {
  String nomeEmpresa, cidadeEstado, endereco;
  double latitude, longitude;
  final VoidCallback buy;

  //Cartao de Credito
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color themeColor;
  final Color textColor;
  CardResumo(this.buy, this.nomeEmpresa, this.cidadeEstado, this.endereco,
      this.latitude, this.longitude,
      {this.cardNumber, this.expiryDate, this.cardHolderName, this.cvvCode, this.onCreditCardModelChange, this.themeColor, this.textColor});
  @override
  _CardResumoState createState() => _CardResumoState(this.buy, this.nomeEmpresa,
      this.cidadeEstado, this.endereco, this.latitude, this.longitude);
}

class _CardResumoState extends State<CardResumo> {
  String nomeEmpresa, cidadeEstado, endereco;
  double latitude, longitude;
  final VoidCallback buy;

  String opcaoDeFrete;
  _CardResumoState(this.buy, this.nomeEmpresa, this.cidadeEstado, this.endereco,
      this.latitude, this.longitude);
  final TextEditingController _startCoordinatesTextController =
      TextEditingController();
  final TextEditingController _endCoordinatesTextController =
      TextEditingController();
  final enderecoController = TextEditingController();
  final obsController = TextEditingController();

  //WidgetCartao
  String cardNumber = "0000 0000 0000 0000";
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isCvvFocused = false;
  Color themeColor;

  void Function(CreditCardModel) onCreditCardModelChange;
  CreditCardModel creditCardModel;
  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber ?? '';
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';

    creditCardModel = CreditCardModel(
        cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  //Api de Pagamento
  final CieloEcommerce cielo = CieloEcommerce(
      environment: Environment.PRODUCTION,
      merchant: Merchant(
        merchantId: "0ef47d5f-35f3-4fbd-ab34-54b683a09799",
        merchantKey: "IhZ5hZIlWO7vxOHK927PbRJiKqwTa7CZ39rv7T6Q",
      ));

  //Realizar Pagamento
  _efetuarTransacao(String numeroCartao, titularCartao, validadeCartao,
      codSegurancaCartao, bandeiraCartao) async {
    Sale sale = Sale(
        merchantOrderId: "1233443",
        customer: Customer(name: "Comprador crédito simples"),
        payment: Payment(
            currency: "BRL",
            type: TypePayment.creditCard,
            amount: 20,
            returnMessage: "https://www.cielo.com.br",
            installments: 1,
            softDescriptor: "CompreAqui",
            creditCard: CreditCard(
              cardNumber: numeroCartao,
              holder: "NATIELLE DE FRIAS NOGUEIRA",
              expirationDate: "02/2028",
              securityCode: "944",
              brand: numeroCartao.toString().s"Master",
            )));

    try {
      var response = await cielo.createSale(sale);
      print(response.payment.status);
    } on CieloException catch (e) {
      print(e.message);
      print(e.errors[0].message);
      print(e.errors[0].code);
    }
  }

  @override
  Widget build(BuildContext context) {
    obsController.text =
        "A entrega por conta do estabelecimento é gratuita, mas poderá demorar mais de 2 horas para ser finalizada.";

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
                  enderecoController.text = endereco;
//              model.loadCartItens();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ExpansionTile(
                        title: Text(
                          "Como o seu pedido será entregue ?",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          Divider(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextField(
                                maxLines: 4,
                                controller: enderecoController,
                                enabled: false,
                                style: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Endereço de Entrega",
                                  labelText: "Endereço de Entrega",
                                  hintStyle: TextStyle(
                                      fontFamily: "QuickSand",
                                      fontSize: 17.0,
                                      color: Colors.black87),
                                ),
                              ),
                              RadioButtonGroup(
                                  labels: <String>[
                                    "Retirar no estabelecimento",
                                    "Entrega Expressa (App Karona)",
                                    "Entrega do estabelecimento"
                                  ],
                                  onSelected: (String selected) => model.setFrete(
                                      selected,
                                      selected == "Retirar no estabelecimento"
                                          ? 0
                                          : selected ==
                                                  "Entrega Expressa (App Karona)"
                                              ? 14
                                              : 0)),
                              TextField(
                                maxLines: 4,
                                controller: obsController,
                                enabled: false,
                                style: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Observação",
                                  labelText: "Observação",
                                  hintStyle: TextStyle(
                                      fontFamily: "QuickSand",
                                      fontSize: 12.0,
                                      color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.brown,
                      ),
//
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
                          Text(
                              "- R\$ ${model.getDesconto().toStringAsFixed(2)}"),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Entrega"),
                          Text("R\$ ${model.getFrete().toStringAsFixed(2)}"),
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
                            "R\$ ${(preco + frete - model.getDesconto()).toStringAsFixed(2)}",
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
