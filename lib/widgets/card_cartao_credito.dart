import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:compreaidelivery/models/CreditCardModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class CardCartaoCredito extends StatefulWidget {
  const CardCartaoCredito({
    Key key,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    @required this.onCreditCardModelChange,
    this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
  }) : super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color themeColor;
  final Color textColor;

  final Color cursorColor;
  @override
  _CardCartaoCreditoState createState() => _CardCartaoCreditoState();
}

class _CardCartaoCreditoState extends State<CardCartaoCredito> {
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

//  final CieloEcommerce cielo = CieloEcommerce(
//      environment: Environment.SANDBOX, // ambiente de desenvolvimento
//      merchant: Merchant(
//        merchantId: "7cb5a0a9-9504-40eb-9914-c801eb50d783",
//        merchantKey: "nA0xWwQBu9QeHIlTi1AtYif5VgWz7szzmNbiNdGY",
//      ));
  _incrementCounter() async {
//    print("Iniciando pagamento....");
//    Sale sale = Sale(
//        merchantOrderId: "123",
//        customer: Customer(name: "Comprador crédito simples"),
//        payment: Payment(
//            type: TypePayment.creditCard,
//            amount: 7777,
//            installments: 1,
//            softDescriptor: "Pagame",
//            creditCard: CreditCard(
//              cardNumber: "0000000000000004",
//              holder: "Lucas Santos Reinaldo",
//              expirationDate: "12/2020",
//              securityCode: "123",
//              brand: "Visa",
//            )));
//
//    try {
//      var response = await cielo.createSale(sale);
//      print(response.payment.paymentId);
//    } on CieloException catch (e) {
//      print(e.message);
//      print(e.errors[0].message);
//      print(e.errors[0].code);
//    }

//    print("Iniciando pagamento tokenizado....");
//    Sale sale = Sale(
//        merchantOrderId: "123",
//        customer: Customer(name: "Comprador crédito simples"),
//        payment: Payment(
//            type: TypePayment.creditCard,
//            amount: 7777,
//            installments: 1,
//            softDescriptor: "Pagame",
//            creditCard: CreditCard(
//              cardToken: "302c35e9-be30-487c-9c09-44ad0746e4b5",
//              securityCode: "123",
//              brand: "Visa",
//            )));
//
//    try {
//      var response = await cielo.createSale(sale);
//      print(response.payment.paymentId);
//    } on CieloException catch (e) {
//      print(e.message);
//      print(e.errors[0].message);
//      print(e.errors[0].code);
//    }

    print("Tokenizando cartão....");

//    CreditCard cart = CreditCard(
//      customerName: "Comprador Teste Cielo",
//      cardNumber: "1234123412341231",
//      securityCode: "123",
//      holder: "SARA M M F",
//      expirationDate: "10/2026",
//      brand: "Visa",
//    );
//    try {
//      var response = await cielo.tokenizeCard(cart);
//      print(response.cardToken);
//      print(response.cardNumber);
//    } catch (e) {
//      print(e.message);
//      print(e.errors[0].message);
//      print(e.errors[0].code);
//    }
  }

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
    return Card(
      elevation: 10,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          "Pagar com Cartão de Crédito",
          textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        leading: Icon(Icons.credit_card),
        trailing: Icon(Icons.add_circle_outline),
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Text(
                      "Os meios de pagamentos através do App estão desabilitados temporariamente."),
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
                    animationDuration: Duration(milliseconds: 2000),
                  ),
                  Form(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin: const EdgeInsets.only(
                              left: 16, top: 16, right: 16),
                          child: TextFormField(
                            onChanged: (String text) {
                              setState(() {});
                              isCvvFocused = false;
                            },
                            controller: _cardNumberController,
                            cursorColor: widget.cursorColor ?? themeColor,
                            style: TextStyle(
                              color: widget.textColor,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Número do Cartão',
                              hintText: 'xxxx xxxx xxxx xxxx',
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin: const EdgeInsets.only(
                              left: 16, top: 8, right: 16),
                          child: TextFormField(
                            onChanged: (String text) {
                              setState(() {});
                              isCvvFocused = false;
                            },
                            controller: _expiryDateController,
                            cursorColor: widget.cursorColor ?? themeColor,
                            style: TextStyle(
                              color: widget.textColor,
                            ),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Data de Validade',
                                hintText: 'MM/YY'),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin: const EdgeInsets.only(
                              left: 16, top: 8, right: 16),
                          child: TextField(
                            focusNode: cvvFocusNode,
                            controller: _cvvCodeController,
                            cursorColor: widget.cursorColor ?? themeColor,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Código de Segurança',
                              hintText: 'XXXX',
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            onChanged: (String text) {
                              setState(() {
                                cvvCode = text;
                                isCvvFocused = true;
                              });
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin: const EdgeInsets.only(
                              left: 16, top: 8, right: 16),
                          child: TextFormField(
                            onChanged: (String text) {
                              setState(() {});
                              isCvvFocused = false;
                            },
                            controller: _cardHolderNameController,
                            cursorColor: widget.cursorColor ?? themeColor,
                            style: TextStyle(
                              color: widget.textColor,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nome do Titular',
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlineButton(
                    hoverColor: Colors.white,
                    highlightColor: Colors.white70,
                    highlightElevation: 10,

                    onPressed: () {
                      _incrementCounter();
                    },
                    child: Text(
                      'Pagar',
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
              ))
        ],
      ),
    );
  }
}
