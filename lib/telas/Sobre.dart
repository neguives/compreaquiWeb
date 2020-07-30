import 'package:flutter/material.dart';
import 'package:flutter_cielo/flutter_cielo.dart';

class Sobre extends StatefulWidget {
  @override
  _SobreState createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  int _counter = 0;

  final CieloEcommerce cielo = CieloEcommerce(
      environment: Environment.PRODUCTION,
      merchant: Merchant(
        merchantId: "0ef47d5f-35f3-4fbd-ab34-54b683a09799",
        merchantKey: "IhZ5hZIlWO7vxOHK927PbRJiKqwTa7CZ39rv7T6Q",
      ));

  _incrementCounter() async {
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
              cardNumber: "5502097794419158",
              holder: "NATIELLE DE FRIAS NOGUEIRA",
              expirationDate: "02/2028",
              securityCode: "944",
              brand: "Master",
            )));

    try {
      var response = await cielo.createSale(sale);
      print(response.payment.status);
      if(response.payment.status == 1){

      }
    } on CieloException catch (e) {
      print(e.message);
      print(e.errors[0].message);
      print(e.errors[0].code);
    }
  }

  @override
  Widget build(BuildContext context) {
    _incrementCounter();
    return Scaffold(
      body: Text("Deus no comando!"),
    );
  }
}
