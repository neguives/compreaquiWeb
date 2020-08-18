import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/datas/user_final_data.dart';
import 'package:compreaidelivery/ecoomerce/ordemPedidoConfirmado.dart';
import 'package:compreaidelivery/models/CreditCardModel.dart';
import 'package:compreaidelivery/models/cart_model.dart';
import 'package:compreaidelivery/models/credit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:scoped_model/scoped_model.dart';

class FinalizarPagamentoPresencial extends StatefulWidget {
  String nomeEmpresa, cidadeEstado, endereco, freteTipo;
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

  FinalizarPagamentoPresencial(this.freteTipo, this.buy, this.nomeEmpresa,
      this.cidadeEstado, this.endereco, this.latitude, this.longitude,
      {this.cardNumber,
      this.expiryDate,
      this.cardHolderName,
      this.cvvCode,
      this.onCreditCardModelChange,
      this.themeColor,
      this.textColor,
      this.cursorColor});
  @override
  _FinalizarPagamentoPresencialState createState() =>
      _FinalizarPagamentoPresencialState(
          this.freteTipo,
          this.buy,
          this.nomeEmpresa,
          this.cidadeEstado,
          this.endereco,
          this.latitude,
          this.longitude);
}

class _FinalizarPagamentoPresencialState
    extends State<FinalizarPagamentoPresencial> {
  String nomeEmpresa, cidadeEstado, endereco, freteTipo;
  double latitude, longitude;
  final VoidCallback buy;
  String bandeira;
  String opcaoDeFrete;
  _FinalizarPagamentoPresencialState(this.freteTipo, this.buy, this.nomeEmpresa,
      this.cidadeEstado, this.endereco, this.latitude, this.longitude);

  final TextEditingController _startCoordinatesTextController =
      TextEditingController();
  final TextEditingController _endCoordinatesTextController =
      TextEditingController();
  final enderecoController = TextEditingController();
  final obsController = TextEditingController();

  UserFinalData userFinalData;
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

  final CreditCard creditCard = CreditCard();
//Realizar Pagamento
  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(
        title: ScopedModelDescendant<CartModel>(
          builder: (context, child, model) {
            double preco = model.getProductPrice();
            String valorTotal = (preco +
                    (model.getEntregaGratuita() == false
                        ? model.getFreteKarona()
                        : 0.0) -
                    model.getDesconto())
                .toStringAsFixed(2);
            return Text(
              "Valor da compra: R\$ " + valorTotal,
              style: TextStyle(fontSize: 14),
            );
          },
        ),
      ),
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
                    CreditCardWidget(
                      cardHolderName: "LUCAS SANTOS REINALDO",
                      cardNumber: "5553 3333 3333 3333",
                      cvvCode: "144",
                      expiryDate: "12/2024",
                      showBackView: false,
                    ),
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
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
                                              "fechado"
                                          ? () {
                                              if (freteTipo.length == 1) {
                                                _dialogSelecioneEntrega(
                                                    context);
                                              } else {
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
                                                              .replaceAll(
                                                                  ",", "")
                                                              .trim() +
                                                          "";
                                                  int valorTotalFinal =
                                                      int.parse(
                                                          valorTotalCorrigido);
                                                  String numeroCartao;
                                                  _cardNumberControllerTrim
                                                      .text = numeroCartao;
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

//      numeroCartao, bandeiraCartao, validadeCartao, nomeCartao , codSeguranca
                                                  // _finalizarPagamento(
                                                  //     _cardNumberController
                                                  //         .text,
                                                  //     _expiryDateController
                                                  //         .text,
                                                  //     _cardHolderNameController
                                                  //         .text,
                                                  //     _cvvCodeController.text);
                                                }
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
                                    ),
                                    Text(
                                      snapshot.data["disponibilidade"] !=
                                              "aberto"
                                          ? "(estabelecimento fechado)"
                                          : "",
                                      style: TextStyle(fontSize: 10),
                                    )
                                  ],
                                );
                              },
                            )
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
              onPressed: () {
                Navigator.pop(context);
              },
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
