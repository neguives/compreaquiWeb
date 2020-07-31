import 'package:flare_flutter/flare_actor.dart';
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
              child: Container(
                width: 100,
                height: 100,
                child: Center(
                    child: FlareActor("assets/success_check.flr",
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        animation: "Untitled")),
              ),
            ),
            Text(
              "O seu pedido foi realizado com sucesso",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Verifique o Status no menu \"Minhas Solicitações\".",
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
