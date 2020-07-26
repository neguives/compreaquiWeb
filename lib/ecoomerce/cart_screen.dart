import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/datas/product_data.dart';
import 'package:compreaidelivery/models/cart_model.dart';
import 'package:compreaidelivery/models/user_model.dart';
import 'package:compreaidelivery/tiles/CartTile.dart';
import 'package:compreaidelivery/widgets/card_cartao_credito.dart';
import 'package:compreaidelivery/widgets/card_desconto.dart';
import 'package:compreaidelivery/widgets/card_entrega.dart';
import 'package:compreaidelivery/widgets/cart_button.dart';
import 'package:compreaidelivery/widgets/cart_resumo.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'ordemPedidoConfirmado.dart';

class CartScreen extends StatelessWidget {
  ProductData product;
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CartScreen(
      this.product,
      this.nomeEmpresa,
      this.imagemEmpresa,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.telefone);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Meu Carrinho",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int p = model.products.length;

                return Text(
                  "${p ?? 0} ${p == 1 ? "ITEM" : "ITENS"}",
                  style: TextStyle(color: Colors.white),
                );
              },
            ),
          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80,
                    color: Colors.purple,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Faça o login para adicionar produtos!",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  RaisedButton(
                    color: Colors.purple,
                    onPressed: () {},
                    child: Text(
                      "Entrar",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )
                ],
              ),
            );
          } else if (model.products == null || model.products.length == 0) {
            return Center(
              child: Text(
                "Seu carrinho está vazio",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map((products) {
                    return CartTile(
                        products, nomeEmpresa, product, cidadeEstado);
                  }).toList(),
                ),
                CardDesconto(nomeEmpresa),
                CardResumo(() async {
                  String ordemId = await model.finalizarCompra(
                      nomeEmpresa, endereco, cidadeEstado);
                  if (ordemId != null) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => OrdemPedidoConfirmado(ordemId)));
                  }
                }, nomeEmpresa, cidadeEstado, endereco, latitude, longitude),
                CardCartaoCredito()
//                CardCartaoCredito(),
              ],
            );
          }
        },
      ),
    );
  }
}
