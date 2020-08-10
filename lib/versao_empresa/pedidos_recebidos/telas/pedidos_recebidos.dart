import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/versao_empresa/pedidos_recebidos/telas/pedidos_recebidos_abertos.dart';
import 'package:compreaidelivery/versao_empresa/pedidos_recebidos/telas/pedidos_recebidos_concluido.dart';
import 'package:compreaidelivery/versao_empresa/pedidos_recebidos/telas/pedidos_recebidos_entregues.dart';
import 'package:compreaidelivery/versao_empresa/pedidos_recebidos/telas/pedidos_recebidos_transporte.dart';
import 'package:compreaidelivery/versao_empresa/pedidos_recebidos/tiles/order_tile.dart';
import 'package:flutter/material.dart';

class PedidosRecebidos extends StatefulWidget {
  String nomeEmpresa, cidadeEstado;

  PedidosRecebidos(this.nomeEmpresa, this.cidadeEstado);
  @override
  _PedidosRecebidosState createState() =>
      _PedidosRecebidosState(nomeEmpresa, cidadeEstado);
}

class _PedidosRecebidosState extends State<PedidosRecebidos> {
  String nomeEmpresa, cidadeEstado;
  _PedidosRecebidosState(this.nomeEmpresa, this.cidadeEstado);
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
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PedidosRecebidosAbertos(
                                    nomeEmpresa, cidadeEstado)));
                          },
                          child: FlatButton(
                            child: Image.asset(
                              "assets/btn_pedidos_em_aberto.png",
                              height: 140,
                              width: 140,
                            ),
                          )),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    PedidosRecebidosTransporte(
                                        nomeEmpresa, cidadeEstado)));
                          },
                          child: FlatButton(
                            child: Image.asset(
                              "assets/btn_pedidos_transporte.png",
                              height: 140,
                              width: 140,
                            ),
                          )),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PedidosRecebidosConcluido(
                                    nomeEmpresa, cidadeEstado)));
                          },
                          child: FlatButton(
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
