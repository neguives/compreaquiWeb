import 'dart:convert';

import 'package:compreaidelivery/datas/cart_product.dart';
import 'package:compreaidelivery/datas/product_data.dart';
import 'package:compreaidelivery/ecoomerce/ProductScreen.dart';
import 'package:compreaidelivery/ecoomerce/cart_screen.dart';
import 'package:compreaidelivery/models/cart_model.dart';
import 'package:compreaidelivery/models/user_model.dart';
import 'package:compreaidelivery/nuagetRefresh/baseDadosProdutos.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';

// ignore: must_be_immutable
class ProductTile extends StatelessWidget {
  final String type;
  final ProductData product;
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;

  List<BaseDadosProdutos> baseDadosProdutos;
  ProductTile(
    this.baseDadosProdutos,
    this.type,
    this.product,
    this.nomeEmpresa,
    this.imagemEmpresa,
    this.cidadeEstado,
    this.endereco,
    this.latitude,
    this.longitude,
    this.telefone,
  );
  List<BaseDadosProdutos> _searchResult = [];
  double valor;

  List<BaseDadosProdutos> _userDetails = [];
  refreshDataDio() async {
    var dataStr = jsonEncode({
      "command": "get_products",
    });
    var url = "https://nuage.net.br/lucas/controller.php?data=" + dataStr;

    Response response = await Dio().get(url);

//    print(response.data);

    List<BaseDadosProdutos> baseProdutos = List<BaseDadosProdutos>();

    for (Map<String, dynamic> item in response.data) {
      baseProdutos.add(BaseDadosProdutos.fromJson(item));
//      print(item);

    }
    List<BaseDadosProdutos> _searchResult = [];

    List<BaseDadosProdutos> _userDetails = [];
  }

  @override
  Widget build(BuildContext context) {
    _searchResult.clear();
    baseDadosProdutos.forEach((element) {
      if (element.cODIGO.contains(product.codigoBarras)) {
        _searchResult.add(element);
        double quant = double.parse(_searchResult[0].estoque);
        // print(_searchResult[0]);
        product.price = double.parse(_searchResult[0].vLVARJ);

        product.quantidade = quant.round();
      }
    });

    if (product.quantidade < 10 && product.precoAnterior < 1) {
      product.precoAnterior =
          product.price + ((product.price / 1000) * product.price.floor() + 1);
      product.promo = true;
    }
    if (_searchResult.length < 1) {
      product.quantidade = 0;
    }
    return InkWell(onTap: () {
      print(product.codBarras.toString());
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductScreen(
              product,
              nomeEmpresa,
              imagemEmpresa,
              cidadeEstado,
              endereco,
              latitude,
              longitude,
              telefone)));
    }, child: ScopedModelDescendant<CartModel>(
      builder: (context, child, model) {
//        product.price = 1;

        return Card(
            child: type == "grid"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 1.1,
                            child: Image.network(
                              product.images[0],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Card(
                                      child: Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Text(
                                      product.promo == true &&
                                              product.precoAnterior > 0
                                          ? "${((product.precoAnterior / product.price - 1) * 100).toStringAsPrecision(2)} % de Desconto"
                                          : "",
                                      style: (TextStyle(
                                          fontSize: 8,
                                          fontFamily: "QuickSand",
                                          color: Colors.blueGrey)),
                                    ),
                                  ))),
                            ),
                          )
                        ],
                      ),
                      Divider(),
                      SingleChildScrollView(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                  padding: EdgeInsets.all(3),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${product.title}",
                                            maxLines: 4,
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontFamily: "Georgia",
                                                color: Colors.black),
                                          ),
                                        ],
                                      ))),
                            ),
                            IconButton(
                              icon: Icon(Icons.add_shopping_cart),
                              onPressed: () {
                                if (UserModel.of(context).isLoggedIn()) {
                                  CartProduct cartProduct = CartProduct();

                                  cartProduct.variacao = "UND";
                                  cartProduct.quantidade = 1;
                                  cartProduct.pid = product.id;
                                  cartProduct.categoria = product.category;
                                  cartProduct.productData = product;
                                  CartModel.of(context)
                                      .addCartItem(cartProduct, nomeEmpresa);
                                } else {
                                  CartProduct cartProduct = CartProduct();

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CartScreen(
                                          cartProduct.productData,
                                          nomeEmpresa,
                                          imagemEmpresa,
                                          cidadeEstado,
                                          endereco,
                                          latitude,
                                          longitude,
                                          telefone)));
                                }

                                // ignore: deprecated_member_use
                              },
                            )
                          ],
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: <Widget>[
                              Text(
                                product.promo == true
                                    ? "De R\$ ${product.precoAnterior.toStringAsFixed(2)} por "
                                    : "",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo),
                              ),
                              Text(
                                " R\$ ${product.price.toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: product.promo == true
                                        ? Colors.red
                                        : Colors.red),
                              ),
                              Text(
                                product.promo == true && product.quantidade > 0
                                    ? "Restam ${product.quantidade} unidades"
                                    : product.promo == false &&
                                            product.quantidade > 0
                                        ? ""
                                        : "Esgotado",
                                style: TextStyle(
                                    fontSize: 8, color: Colors.black54),
                              ),
                            ],
                          ))
                    ],
                  )
                : Stack(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Image.network(
                              product.images[0],
                              fit: BoxFit.cover,
                              height: 100,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        product.title,
                                        style: TextStyle(
                                            fontSize: 9, fontFamily: "Georgia"),
                                      ),
                                      Text(
                                        "R\$ ${product.price.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo),
                                      ),
                                    ],
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Card(
                                            child: Container(
                                              height: 100,
                                              color: Colors.purple,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.add_shopping_cart,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  CartProduct cartProduct =
                                                      CartProduct();

                                                  cartProduct.variacao = "UND";
                                                  cartProduct.quantidade = 1;
                                                  cartProduct.pid = product.id;
                                                  cartProduct.categoria =
                                                      product.category;
                                                  cartProduct.productData =
                                                      product;
                                                  CartModel.of(context)
                                                      .addCartItem(cartProduct,
                                                          nomeEmpresa);
                                                },
                                              ),
                                            ),
                                            elevation: 5,
                                          )
                                        ],
                                      ))
                                ],
                              ))
                        ],
                      ),
                    ],
                  ));
      },
    ));
  }
}
