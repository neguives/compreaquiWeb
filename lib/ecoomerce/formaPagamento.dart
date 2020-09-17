import 'package:compreaidelivery/models/cart_model.dart';
import 'package:compreaidelivery/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:scoped_model/scoped_model.dart';

import 'ordemPedidoConfirmado.dart';

class FormaPagamento extends StatelessWidget {
  String freteTipo, nomeEmpresa, endereco, cidadeEstado, formaPagamento;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FormaPagamento(
      this.nomeEmpresa, this.endereco, this.cidadeEstado, this.freteTipo);
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, modelUser) {
        return ScopedModelDescendant<CartModel>(
          builder: (context, child, model) {
            double preco = model.getProductPrice();

            return Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text("Valor Total: R\$ " +
                      (preco +
                              (model.getEntregaGratuita() == false
                                  ? model.getFreteKarona()
                                  : 0.0) -
                              model.getDesconto())
                          .toStringAsFixed(2)),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Stack(
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/teste.png',
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Como o seu pedido será pago ?",
                                      style: TextStyle(
                                          fontFamily: "QuickSand",
                                          fontSize: 24),
                                    ),
                                    RadioButtonGroup(
                                        labels: <String>[
                                          "Pagamento em Dinheiro",
                                          "Cartão de Débito",
                                          "Cartão de Crédito"
                                        ],
                                        onSelected: (String selected) async {
                                          formaPagamento = selected;
                                        }),
                                    OutlineButton(
                                      hoverColor: Colors.white,
                                      highlightColor: Colors.white70,
                                      highlightElevation: 10,

                                      onPressed: () async {
                                        if (formaPagamento.toString().length >
                                            5) {
                                          print(formaPagamento);
                                          model.finalizarCompra(
                                              nomeEmpresa,
                                              endereco,
                                              cidadeEstado,
                                              freteTipo,
                                              formaPagamento,
                                              modelUser.firebaseUser.uid);

                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrdemPedidoConfirmado(
                                                          "1")));
                                        } else {
                                          showInSnackBar(
                                              "Selecione uma das opções",
                                              context);
                                        }
                                      },
                                      child: Text(
                                        'Confirmar Pedido',
                                        style:
                                            TextStyle(fontFamily: "QuickSand"),
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
                                  ],
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ));
          },
        );
      },
    );
  }

  void showInSnackBar(String value, BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
    ));
  }
}
