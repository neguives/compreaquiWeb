import 'package:flutter/material.dart';

class OrdemPedidoConfirmado extends StatelessWidget {
  final String orderId;

  OrdemPedidoConfirmado(this.orderId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        title: Text("Pedido Realizado"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Image.asset(
                  'assets/in.png',
                  width: 200,
                  height: 200,
                )),
            Icon(
              Icons.check,
              color: Colors.green,
              size: 80,
            ),
            Text(
              "O seu pedido foi realizado com sucesso",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Entraremos em contato com você para confirmar",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
