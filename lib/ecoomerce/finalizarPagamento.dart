import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/ecoomerce/ordemPedidoConfirmado.dart';
import 'package:compreaidelivery/models/CreditCardModel.dart';
import 'package:compreaidelivery/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cielo/flutter_cielo.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:scoped_model/scoped_model.dart';

class FinalizarPagamento extends StatefulWidget {
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

  FinalizarPagamento(this.buy, this.nomeEmpresa, this.cidadeEstado,
      this.endereco, this.latitude, this.longitude,
      {this.cardNumber,
      this.expiryDate,
      this.cardHolderName,
      this.cvvCode,
      this.onCreditCardModelChange,
      this.themeColor,
      this.textColor,
      this.cursorColor});
  @override
  _FinalizarPagamentoState createState() => _FinalizarPagamentoState(
      this.buy,
      this.nomeEmpresa,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude);
}

class _FinalizarPagamentoState extends State<FinalizarPagamento> {
  String nomeEmpresa, cidadeEstado, endereco;
  double latitude, longitude;
  final VoidCallback buy;
  String bandeira;
  String opcaoDeFrete;
  String freteTipo = "a";
  _FinalizarPagamentoState(this.buy, this.nomeEmpresa, this.cidadeEstado,
      this.endereco, this.latitude, this.longitude);

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

    return Scaffold(
      floatingActionButton: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          return StreamBuilder(
            stream: Firestore.instance
                .collection(cidadeEstado)
                .document(nomeEmpresa)
                .snapshots(),
            builder: (context, snapshot) {
              double preco = model.getProductPrice();
              double desconto = model.getDesconto();
              double frete = model.getFreteKarona();
              return FloatingActionButton(
                child: ,
              );
            },
          );
        },
      ),
      appBar: AppBar(),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          double preco = model.getProductPrice();
          double desconto = model.getDesconto();
          double frete = model.getFreteKarona();
//              model.loadCartItens();

          return SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              animationDuration: Duration(milliseconds: 2000),
                            ),
                            Form(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    margin: const EdgeInsets.only(
                                        left: 16, top: 1, right: 16),
                                    child: TextFormField(
                                      onChanged: (String text) {
                                        setState(() {});
                                        isCvvFocused = false;
                                      },
                                      controller: _cardNumberController,
                                      cursorColor:
                                          widget.cursorColor ?? themeColor,
                                      style: TextStyle(
                                        color: widget.textColor,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Número do Cartão',
                                        hintText: 'xxxx xxxx xxxx xxxx',
                                      ),
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    margin: const EdgeInsets.only(
                                        left: 16, top: 1, right: 16),
                                    child: TextFormField(
                                      onChanged: (String text) {
                                        setState(() {});
                                        isCvvFocused = false;
                                      },
                                      controller: _expiryDateController,
                                      cursorColor:
                                          widget.cursorColor ?? themeColor,
                                      style: TextStyle(
                                        color: widget.textColor,
                                      ),
                                      decoration: InputDecoration(
                                          labelText: 'Data de Validade',
                                          hintText: 'MM/AAAA'),
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    margin: const EdgeInsets.only(
                                        left: 16, top: 1, right: 16),
                                    child: TextField(
                                      focusNode: cvvFocusNode,
                                      controller: _cvvCodeController,
                                      cursorColor:
                                          widget.cursorColor ?? themeColor,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    margin: const EdgeInsets.only(
                                        left: 16, top: 1, right: 16),
                                    child: TextFormField(
                                      onChanged: (String text) {
                                        setState(() {});
                                        isCvvFocused = false;
                                      },
                                      controller: _cardHolderNameController,
                                      cursorColor:
                                          widget.cursorColor ?? themeColor,
                                      style: TextStyle(
                                        color: widget.textColor,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Nome do Titular',
                                      ),
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RaisedButton(
                              child: Text("Comprar Sem Cartao"),
                              onPressed: () {
                                model.finalizarCompra(nomeEmpresa, endereco,
                                    cidadeEstado, freteTipo);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OrdemPedidoConfirmado("1")));
                              },
                            ),
                          ],
                        ))
                  ],
                )),
          );
        },
      ),
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
}
