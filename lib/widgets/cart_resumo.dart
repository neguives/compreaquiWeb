import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/ecoomerce/checkout_screen.dart';
import 'package:compreaidelivery/ecoomerce/finalizarPagamento.dart';
import 'package:compreaidelivery/ecoomerce/ordemPedidoConfirmado.dart';
import 'package:compreaidelivery/models/CreditCardModel.dart';
import 'package:compreaidelivery/models/cart_model.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
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
  final Color cursorColor;

  CardResumo(this.buy, this.nomeEmpresa, this.cidadeEstado, this.endereco,
      this.latitude, this.longitude,
      {this.cardNumber,
      this.expiryDate,
      this.cardHolderName,
      this.cvvCode,
      this.onCreditCardModelChange,
      this.themeColor,
      this.textColor,
      this.cursorColor});
  @override
  _CardResumoState createState() => _CardResumoState(this.buy, this.nomeEmpresa,
      this.cidadeEstado, this.endereco, this.latitude, this.longitude);
}

class _CardResumoState extends State<CardResumo> {
  String nomeEmpresa, cidadeEstado, endereco;
  double latitude, longitude;
  final VoidCallback buy;
  String bandeira;
  String opcaoDeFrete;
  String freteTipo = "a";
  _CardResumoState(this.buy, this.nomeEmpresa, this.cidadeEstado, this.endereco,
      this.latitude, this.longitude);

  final TextEditingController _startCoordinatesTextController =
      TextEditingController();
  final TextEditingController _endCoordinatesTextController =
      TextEditingController();
  final enderecoController = TextEditingController();
  final textDialogController = TextEditingController();
  final obsController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//Api de Pagamento

//Realizar Pagamento

  @override
  Widget build(BuildContext context) {
    enderecoController.text = endereco;
    textDialogController.text =
        "Modalidade de pagamento não disponível para entrega expressa.";
    bool entregaGratuita = false;

    obsController.text =
        "A entrega por conta do estabelecimento é gratuita e está disponível apenas para pedidos com o valor total acima de R\$50,00. Essa modalidade poderá demorar mais de 2 horas para o pedido ser entregue.";

    return ScopedModelDescendant<CartModel>(
      builder: (context, child, model) {
        double freteKarona = model.getFreteKarona();

        double freteKaronaFixo = freteKarona;
        double preco = model.getProductPrice();
        double desconto = model.getDesconto();
        double frete = model.getFrete();
        return Column(
          key: _scaffoldKey,
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
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
                                    "Entrega Expressa (Karona)",
                                    "Entrega do estabelecimento"
                                  ],
                                  onSelected: (String selected) async {
                                    freteTipo = selected;

                                    model.setEntregaGratuita(
                                        selected == "Entrega Expressa (Karona)"
                                            ? false
                                            : true);
                                  }),
                              TextField(
                                maxLines: 6,
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
                    ],
                  )),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Container(
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
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
                              Text(model.getEntregaGratuita() == false
                                  ? "R\$ " +
                                      model.getFreteKarona().toStringAsFixed(2)
                                  : "R\$ 0.00"),
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
                                "R\$ ${(preco + (model.getEntregaGratuita() == false ? model.getFreteKarona() : 0.0) - model.getDesconto()).toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                            ],
                          ),
                          OutlineButton(
                            hoverColor: Colors.white,
                            highlightColor: Colors.white70,
                            highlightElevation: 10,

                            onPressed: freteTipo.length > 5
                                ? () {
                                    if (freteTipo ==
                                            "Entrega do estabelecimento" &&
                                        preco < 50) {
                                      _pedidoInferior(context);
                                    } else {
                                      Navigator.of(context).pushNamed(
                                        '/finalizarPagamento',
                                      );
                                    }
                                    {}
                                  }
                                : () {
                                    _dialogSelecioneEntrega(context);
                                  },

                            child: Text(
                              'Pagamento com Cartão',
                            ),

                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(
                                    color: Colors
                                        .white30)), // callback when button is clicked
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

                            onPressed: freteTipo.length > 5
                                ? () {
                                    if (freteTipo ==
                                        "Entrega Expressa (Karona)") {
                                      _dialogPagamentoPresencial(context);
                                    }
                                    if ((freteTipo ==
                                                "Entrega do estabelecimento" ||
                                            freteTipo ==
                                                "Retirar no estabelecimento") &&
                                        preco < 50) {
                                      _pedidoInferior(context);
                                    }
                                    {}
                                  }
                                : () {
                                    _dialogSelecioneEntrega(context);
                                  },

                            child: Text(
                              'Pagar Pessoalmente',
                            ),

                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(
                                    color: Colors
                                        .white30)), // callback when button is clicked
                            borderSide: BorderSide(
                              color: Colors.blueGrey, //Color of the border
                              style: BorderStyle.solid, //Style of the border
                              width: 0.8, //width of the border
                            ),
                          ),
                        ],
                      ))),
            ),
          ],
        );
      },
    );
  }

  void _pedidoInferior(BuildContext context) {
    // flutter defined function
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            backgroundColor: Colors.transparent,
            title: new Card(
              child: Center(
                  child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Icon(
                      Icons.local_car_wash,
                      size: 70,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Ops!",
                      style: TextStyle(fontFamily: "QuickSand", fontSize: 15),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "A entrega realizada pelo estabelecimento só está disponível em pedidos acima de R\$50,00.",
                      style: TextStyle(fontFamily: "QuickSand", fontSize: 12),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Adicione mais itens no seu carrinho ou altere a modalidade da entrega para confirmar o seu pedido!",
                      style: TextStyle(fontFamily: "QuickSand", fontSize: 12),
                    )
                  ],
                ),
              )),
            ));
      },
    );
  }

  void _dialogSelecioneEntrega(BuildContext context) {
    // flutter defined function
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.red,
                      size: 100,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Frete não escolhido"),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _dialogPagamentoPresencial(BuildContext context) {
    // flutter defined function
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.red,
                      size: 100,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                        hintStyle: TextStyle(
                            fontFamily: "QuickSand",
                            fontSize: 17.0,
                            color: Colors.black87),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
