import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/ecoomerce/ordemPedidoConfirmado.dart';
import 'package:compreaidelivery/models/CreditCardModel.dart';
import 'package:compreaidelivery/models/cart_model.dart';
import 'package:flare_flutter/flare_actor.dart';
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
  final MaskedTextController _cardNumberControllerTrim =
      MaskedTextController(mask: '0000000000000000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/0000');
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

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel);
      });
    });
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool entregaGratuita = false;

    obsController.text =
        "A entrega por conta do estabelecimento é gratuita e está disponível apenas para pedidos com o valor total acima de R\$60,00. Essa modalidade poderá demorar mais de 2 horas para o pedido ser entregue.";

    return Column(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Container(
              padding: EdgeInsets.all(16.0),
              child: ScopedModelDescendant<CartModel>(
                builder: (context, child, model) {
                  double freteKarona = model.getFreteKarona();

                  double freteKaronaFixo = freteKarona;
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
                                  onSelected: (String selected) async {
                                    freteTipo = selected;

                                    model.setEntregaGratuita(selected ==
                                            "Entrega Expressa (App Karona)"
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
          child: Container(child: ScopedModelDescendant<CartModel>(
            builder: (context, child, model) {
              double preco = model.getProductPrice();
              double desconto = model.getDesconto();
              double frete = model.getFreteKarona();
//              model.loadCartItens();

              return Padding(
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
                      ExpansionTile(
                        title: Text(
                          "Pagar com Cartão",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.grey),
                        ),
                        leading: Icon(Icons.credit_card),
                        trailing: Icon(Icons.add_circle_outline),
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: <Widget>[
                                  CreditCardWidget(
                                    cardNumber: cardNumber,
                                    expiryDate: expiryDate,
                                    cardHolderName: cardHolderName,
                                    cvvCode: cvvCode,
                                    showBackView: isCvvFocused,
                                    cardbgColor: Colors.green.shade300,
                                    height: 175,
                                    textStyle: TextStyle(color: Colors.black87),
                                    width: MediaQuery.of(context).size.width,
                                    animationDuration:
                                        Duration(milliseconds: 2000),
                                  ),
                                  Form(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          margin: const EdgeInsets.only(
                                              left: 16, top: 16, right: 16),
                                          child: TextFormField(
                                            onChanged: (String text) {
                                              setState(() {});
                                              isCvvFocused = false;
                                            },
                                            controller: _cardNumberController,
                                            cursorColor: widget.cursorColor ??
                                                themeColor,
                                            style: TextStyle(
                                              color: widget.textColor,
                                            ),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Número do Cartão',
                                              hintText: 'xxxx xxxx xxxx xxxx',
                                            ),
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          margin: const EdgeInsets.only(
                                              left: 16, top: 8, right: 16),
                                          child: TextFormField(
                                            onChanged: (String text) {
                                              setState(() {});
                                              isCvvFocused = false;
                                            },
                                            controller: _expiryDateController,
                                            cursorColor: widget.cursorColor ??
                                                themeColor,
                                            style: TextStyle(
                                              color: widget.textColor,
                                            ),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Data de Validade',
                                                hintText: 'MM/AAAA'),
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          margin: const EdgeInsets.only(
                                              left: 16, top: 8, right: 16),
                                          child: TextField(
                                            focusNode: cvvFocusNode,
                                            controller: _cvvCodeController,
                                            cursorColor: widget.cursorColor ??
                                                themeColor,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Código de Segurança',
                                              hintText: 'XXXX',
                                            ),
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.done,
                                            onChanged: (String text) {
                                              setState(() {
                                                cvvCode = text;
                                                isCvvFocused = true;
                                              });
                                            },
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          margin: const EdgeInsets.only(
                                              left: 16, top: 8, right: 16),
                                          child: TextFormField(
                                            onChanged: (String text) {
                                              setState(() {});
                                              isCvvFocused = false;
                                            },
                                            controller:
                                                _cardHolderNameController,
                                            cursorColor: widget.cursorColor ??
                                                themeColor,
                                            style: TextStyle(
                                              color: widget.textColor,
                                            ),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Nome do Titular',
                                            ),
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RaisedButton(
                                    child: Text("Comprar Sem Cartao"),
                                    onPressed: (){

                                      model.finalizarCompra(
                                          nomeEmpresa,
                                          endereco,
                                          cidadeEstado,freteTipo);
                                      Navigator.of(context)
                                          .pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrdemPedidoConfirmado(
                                                      "1")));
                                    },
                                  ),
                                  StreamBuilder(
                                    stream: Firestore.instance
                                        .collection(cidadeEstado)
                                        .document(nomeEmpresa)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      return Column(
                                        children: [
                                        OutlineButton(
                                        hoverColor: Colors.white,
                                        highlightColor: Colors.white70,
                                        highlightElevation: 10,
                                        onPressed: snapshot
                                            .data["disponibilidade"] ==
                                            "aberto"
                                            ? () {
                                          double total = preco +
                                              frete -
                                              model.getDesconto();
                                          if (total <= 50 &&
                                              freteTipo ==
                                                  "Entrega do estabelecimento") {
                                            _pedidoInferior(context);
                                          } else {
                                            String valorTotal = (preco +
                                                (model.getEntregaGratuita() ==
                                                    false
                                                    ? model
                                                    .getFreteKarona()
                                                    : 0.0) -
                                                model.getDesconto())
                                                .toString()
                                                .replaceAll(".", "");
                                            String valorTotalCorrigido =
                                            valorTotal
                                                .replaceAll(",", "")
                                                .trim();
                                            int valorTotalFinal =
                                            int.parse(
                                                valorTotalCorrigido);
                                            _finalizarPagamento(
                                                String numeroCartao,
                                                validadeCartao,
                                                nomeCartao,
                                                codSeguranca) async {
                                              _cardNumberControllerTrim
                                                  .text = numeroCartao;
                                              print(
                                                  _cardNumberControllerTrim
                                                      .text);
                                              bandeira = numeroCartao
                                                  .startsWith(
                                                  "51") ||
                                                  numeroCartao.startsWith(
                                                      "55") ||
                                                  numeroCartao.startsWith(
                                                      "2221") ||
                                                  numeroCartao.startsWith(
                                                      "2229") ||
                                                  numeroCartao.startsWith(
                                                      "223") ||
                                                  numeroCartao.startsWith(
                                                      "229") ||
                                                  numeroCartao.startsWith(
                                                      "23") ||
                                                  numeroCartao.startsWith(
                                                      "26") ||
                                                  numeroCartao.startsWith(
                                                      "270") ||
                                                  numeroCartao
                                                      .startsWith("271") ||
                                                  numeroCartao.startsWith("2720")
                                                  ? "Master"
                                                  : numeroCartao.startsWith("4") ? "Visa" : numeroCartao.startsWith("34") || numeroCartao.startsWith("37") ? "Amex" : numeroCartao.startsWith("38") || numeroCartao.startsWith("60") ? "Hiper" : numeroCartao.startsWith("636368") || numeroCartao.startsWith("636369") || numeroCartao.startsWith("438935") || numeroCartao.startsWith("504175") || numeroCartao.startsWith("451416") || numeroCartao.startsWith("636297") || numeroCartao.startsWith("5067") || numeroCartao.startsWith("4576") || numeroCartao.startsWith("4011") || numeroCartao.startsWith("506699") ? "Elo" : numeroCartao.startsWith("301") || numeroCartao.startsWith("305") || numeroCartao.startsWith("36") || numeroCartao.startsWith("38") ? "Diners" : numeroCartao.startsWith("6011") || numeroCartao.startsWith("622") || numeroCartao.startsWith("64") || numeroCartao.startsWith("65") ? "Discover" : "Invalida";
                                              Sale sale = Sale(
                                                  merchantOrderId:
                                                  "1233443",
                                                  customer: Customer(
                                                      name:
                                                      "Comprador crédito simples"),
                                                  payment: Payment(
                                                      currency: "BRL",
                                                      type: TypePayment
                                                          .creditCard,
                                                      amount:
                                                      valorTotalFinal,
                                                      returnMessage:
                                                      "https://www.cielo.com.br",
                                                      installments: 1,
                                                      softDescriptor:
                                                      "CompreAqui",
                                                      creditCard:
                                                      CreditCard(
                                                        cardNumber:
                                                        _cardNumberControllerTrim
                                                            .text,
                                                        holder: nomeCartao
                                                            .toString()
                                                            .toUpperCase(),
                                                        expirationDate:
                                                        validadeCartao,
                                                        securityCode:
                                                        codSeguranca,
                                                        brand: numeroCartao.startsWith("51") ||
                                                            numeroCartao.startsWith(
                                                                "55") ||
                                                            numeroCartao.startsWith(
                                                                "2221") ||
                                                            numeroCartao.startsWith(
                                                                "2229") ||
                                                            numeroCartao.startsWith(
                                                                "223") ||
                                                            numeroCartao.startsWith(
                                                                "229") ||
                                                            numeroCartao.startsWith(
                                                                "23") ||
                                                            numeroCartao.startsWith(
                                                                "26") ||
                                                            numeroCartao.startsWith(
                                                                "270") ||
                                                            numeroCartao.startsWith(
                                                                "271") ||
                                                            numeroCartao.startsWith(
                                                                "2720")
                                                            ? "Master"
                                                            : numeroCartao.startsWith("4")
                                                            ? "Visa"
                                                            : numeroCartao.startsWith("34") || numeroCartao.startsWith("37") ? "Amex" : numeroCartao.startsWith("38") || numeroCartao.startsWith("60") ? "Hiper" : numeroCartao.startsWith("636368") || numeroCartao.startsWith("636369") || numeroCartao.startsWith("438935") || numeroCartao.startsWith("504175") || numeroCartao.startsWith("451416") || numeroCartao.startsWith("636297") || numeroCartao.startsWith("5067") || numeroCartao.startsWith("4576") || numeroCartao.startsWith("4011") || numeroCartao.startsWith("506699") ? "Elo" : numeroCartao.startsWith("301") || numeroCartao.startsWith("305") || numeroCartao.startsWith("36") || numeroCartao.startsWith("38") ? "Diners" : numeroCartao.startsWith("6011") || numeroCartao.startsWith("622") || numeroCartao.startsWith("64") || numeroCartao.startsWith("65") ? "Discover" : "Master",
                                                      )));

                                              try {
                                                var response = await cielo
                                                    .createSale(sale);
                                                print(response
                                                    .payment.status);
                                                print(bandeira);
                                                if (response
                                                    .payment.status ==
                                                    1) {
                                                  model.finalizarCompra(
                                                      nomeEmpresa,
                                                      endereco,
                                                      cidadeEstado,freteTipo);
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              OrdemPedidoConfirmado(
                                                                  "1")));
                                                } else {
                                                  _pagamentoReprovado(
                                                      context);
                                                }
                                              } on CieloException catch (e) {
                                                print(e.message);
                                                print(
                                                    e.errors[0].message);
                                                print(e.errors[0].code);
                                              }
                                            }

//      numeroCartao, bandeiraCartao, validadeCartao, nomeCartao , codSeguranca
                                            _finalizarPagamento(
                                                _cardNumberController
                                                    .text,
                                                _expiryDateController
                                                    .text,
                                                _cardHolderNameController
                                                    .text,
                                                _cvvCodeController.text);
                                          }
                                        }
                                            : null,
                                        child: Text(
                                          'Pagar',
                                        ),

                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            new BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Colors
                                                    .white30)), // callback when button is clicked
                                        borderSide: BorderSide(
                                          color: Colors
                                              .blueGrey, //Color of the border
                                          style: BorderStyle
                                              .solid, //Style of the border
                                          width: 0.8, //width of the border
                                        ),
                                      ), Text(snapshot
                                              .data["disponibilidade"] !=
                                              "aberto"?"(estabelecimento fechado)":"", style: TextStyle(fontSize: 10),)
                                        ],
                                      );
                                    },
                                  )
                                ],
                              ))
                        ],
                      ),
                    ],
                  ));
            },
          )),
        ),
      ],
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
                      "Compra não processada!",
                      style: TextStyle(fontFamily: "QuickSand", fontSize: 15),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "A entrega realizada pelo estabelecimento só está disponível em pedidos acima de R\$60,00.",
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

  void _pagamentoAprovado(BuildContext context) {
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
                  children: [],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Pagamento Aprovado"),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _pagamentoReprovado(BuildContext context) {
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
                      Icons.error_outline,
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
                    Text("Pagamento Reprovado"),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}
