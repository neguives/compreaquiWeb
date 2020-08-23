import 'package:compreaidelivery/ecoomerce/services/checkout_manager.dart';
import 'package:compreaidelivery/ecoomerce/services/common/price_card.dart';
import 'package:compreaidelivery/ecoomerce/services/components/cpf_field.dart';
import 'package:compreaidelivery/ecoomerce/services/components/credit_card_widget.dart';
import 'package:compreaidelivery/models/credit_card.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CheckoutScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CheckoutManager checkoutManager = new CheckoutManager();
  final CreditCard creditCard = CreditCard();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              CreditCardWidget(creditCard),
              CpfField(),
              PriceCard(
                buttonText: 'Finalizar Pedido',
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();

                    checkoutManager.checkout(
                        creditCard: creditCard,
                        onStockFail: (e) {
                          Navigator.of(context).popUntil(
                              (route) => route.settings.name == '/cart');
                        },
                        onPayFail: (e) {
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('$e'),
                            backgroundColor: Colors.red,
                          ));
                        },
                        onSuccess: (order) {
                          Navigator.of(context)
                              .popUntil((route) => route.settings.name == '/');
                          Navigator.of(context)
                              .pushNamed('/confirmation', arguments: order);
                        });
                  }
                },
              )
            ],
          ),
        ));
  }
}
