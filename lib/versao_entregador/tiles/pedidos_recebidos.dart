import 'package:compreaidelivery/versao_entregador/telas/pedidos_recebidos_concluido.dart';
import 'package:compreaidelivery/versao_entregador/telas/pedidos_recebidos_transporte.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PedidosRecebidos extends StatefulWidget {
  String uid;

  PedidosRecebidos(this.uid);
  @override
  _PedidosRecebidosState createState() => _PedidosRecebidosState(uid);
}

class _PedidosRecebidosState extends State<PedidosRecebidos> {
  String uid;

  _PedidosRecebidosState(this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        )),
        body: Stack(
          children: [
            Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    PedidosRecebidosTransporte(uid)));
                          },
                          child: FlatButton(
                            onPressed: () {},
                            child: Image.asset(
                              "assets/btn_pedidos_transporte.png",
                              height: 140,
                              width: 140,
                            ),
                          )),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    PedidosRecebidosConcluido(uid)));
                          },
                          child: FlatButton(
                            onPressed: () {},
                            child: Image.asset(
                              "assets/btn_pedidos_entregues.png",
                              height: 140,
                              width: 140,
                            ),
                          )),
                    ],
                  ),
                ))
          ],
        ));
  }
}
