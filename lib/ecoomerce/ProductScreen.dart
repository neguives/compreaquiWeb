import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/datas/cart_product.dart';
import 'package:compreaidelivery/datas/product_data.dart';
import 'package:compreaidelivery/models/cart_model.dart';
import 'package:compreaidelivery/models/user_model.dart';
import 'package:compreaidelivery/widgets/cart_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'cart_screen.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;

  ProductScreen(
      this.product,
      this.nomeEmpresa,
      this.imagemEmpresa,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.telefone);
  @override
  _ProductScreenState createState() => _ProductScreenState(product, nomeEmpresa,
      imagemEmpresa, cidadeEstado, endereco, latitude, longitude, telefone);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;
  String preferencia,
      nomeEmpresa,
      imagemEmpresa,
      cidadeEstado,
      endereco,
      telefone;
  double latitude, longitude;

  _ProductScreenState(
      this.product,
      this.nomeEmpresa,
      this.imagemEmpresa,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.telefone);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Stack(
      children: <Widget>[
        Scaffold(
//            floatingActionButton: CartButton(nomeEmpresa),
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.white,
              title: Text(
                product.title,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: ListView(
              children: <Widget>[
                AspectRatio(
                    aspectRatio: 0.9,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Carousel(
                          images: product.images.map((url) {
                            return NetworkImage(url);
                          }).toList(),
                          dotSize: 10,
                          dotSpacing: 15,
                          dotBgColor: Colors.transparent,
                          autoplay: true,
                          dotIncreasedColor: Colors.blue,
                          dotColor: Colors.blueGrey,
                          animationDuration: Duration(seconds: 2),
                        ),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        product.title,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                        maxLines: 3,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        product.promo == true
                            ? "Quantidade Disponível: " +
                                product.quantidade.toString()
                            : "",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w500),
                        maxLines: 3,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "R\$ ${product.price.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Preferência",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 40,
                        child: GridView(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.30),
                            children: product.variacao.map((s) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    preferencia = s;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      border: Border.all(
                                          color: s == preferencia
                                              ? Colors.green[600]
                                              : Colors.grey,
                                          width: s == preferencia ? 4 : 2)),
                                  width: 50,
                                  alignment: Alignment.center,
                                  child: Text(s),
                                ),
                              );
                            }).toList()),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(height: 16),
                      ScopedModelDescendant<CartModel>(
                        builder: (context, child , model){
                          String disponibilidade = model.getDisponibilidade();
                          return OutlineButton(
                            color: Colors.green,
                            hoverColor: Colors.white,
                            highlightColor: Colors.white70,
                            highlightElevation: 10,
                            child: Container(
                              width: 150,
                              height: 30,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    product.quantidade > 0
                                        ? 'Adicionar ao Carrinho'
                                        : "Produto Indisponível" ,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            onPressed: preferencia != null && product.quantidade > 0
                                ? () async {
                              DocumentReference documentReference = Firestore
                                  .instance
                                  .collection(cidadeEstado)
                                  .document(nomeEmpresa)
                                  .collection("Produtos e Servicos")
                                  .document(product.category)
                                  .collection("itens")
                                  .document(product.id);

                              Firestore.instance
                                  .runTransaction((transaction) async {
                                await transaction.update(documentReference,
                                    {"quantidade": product.quantidade - 1});
                              });

                              if (UserModel.of(context).isLoggedIn()) {
                                CartProduct cartProduct = CartProduct();
                                cartProduct.variacao = preferencia;
                                cartProduct.quantidade = 1;
                                cartProduct.pid = product.id;
                                cartProduct.categoria = product.category;
                                cartProduct.productData = product;
                                CartModel.of(context)
                                    .addCartItem(cartProduct, nomeEmpresa);
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
                              } else {
                                _scaffoldKey.currentState
                                    .showSnackBar(SnackBar(
                                  content: Text("Você não está conectado!"),
                                  backgroundColor: Colors.blueGrey,
                                  duration: Duration(seconds: 2),
                                ));
                              }
                            }
                                : null,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(
                                    color: Colors
                                        .white30)), // callback when button is clicked
                            borderSide: BorderSide(
                              color: Colors.blueGrey, //Color of the border
                              style: BorderStyle.solid, //Style of the border
                              width: 0.8, //width of the border
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Descrição",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        product.description,
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }
}
