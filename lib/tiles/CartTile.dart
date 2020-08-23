import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/datas/cart_product.dart';
import 'package:compreaidelivery/datas/product_data.dart';
import 'package:compreaidelivery/ecoomerce/cart_screen.dart';
import 'package:compreaidelivery/models/cart_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CartTile extends StatefulWidget {
  final CartProduct cartProduct;
  ProductData productData;
  String nomeEmpresa, cidadeEstado, imagem, telefone, endereco;
  double latitude, longitude;
  int quantidadeRemovida = 0;
  CartTile(
      this.cartProduct,
      this.nomeEmpresa,
      this.productData,
      this.cidadeEstado,
      this.imagem,
      this.latitude,
      this.longitude,
      this.telefone,
      this.endereco);
  @override
  _CartTileState createState() => _CartTileState(
      this.cartProduct,
      this.nomeEmpresa,
      this.productData,
      this.cidadeEstado,
      this.imagem,
      this.latitude,
      this.longitude,
      this.telefone,
      this.endereco);
}

class _CartTileState extends State<CartTile> {
  final CartProduct cartProduct;
  ProductData productData;
  String nomeEmpresa, cidadeEstado, imagem, telefone, endereco;
  double latitude, longitude;
  int quantidadeRemovida = 0;
  _CartTileState(
      this.cartProduct,
      this.nomeEmpresa,
      this.productData,
      this.cidadeEstado,
      this.imagem,
      this.latitude,
      this.longitude,
      this.telefone,
      this.endereco);
  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 120,
            child: Image.network(
              cartProduct.productData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cartProduct.productData.title,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  Text(
                    cartProduct.variacao,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  Text(
                    "R\$ " + cartProduct.productData.price.toStringAsFixed(2),
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: cartProduct.productData.quantidade > 1 &&
                                cartProduct.quantidade > 1
                            ? () {
                                quantidadeRemovida--;
                                Future<Null> _atualizarQuantidade() async {
                                  DocumentReference documentReference =
                                      Firestore.instance
                                          .collection("catalaoGoias")
                                          .document(nomeEmpresa)
                                          .collection("produtos")
                                          .document(productData.category)
                                          .collection("itens")
                                          .document(productData.id);

                                  documentReference.updateData({
                                    "quantidade":
                                        cartProduct.productData.quantidade++
                                  });
                                }

                                _atualizarQuantidade();
                                CartModel.of(context)
                                    .decProduct(cartProduct, nomeEmpresa);
                              }
                            : null,
                      ),
                      Text(cartProduct.quantidade.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: cartProduct.productData.quantidade > 1
                            ? () {
                                quantidadeRemovida++;
                                Future<Null> _atualizarQuantidade() async {
                                  DocumentReference documentReference =
                                      Firestore.instance
                                          .collection("catalaoGoias")
                                          .document(nomeEmpresa)
                                          .collection("produtos")
                                          .document(productData.category)
                                          .collection("itens")
                                          .document(productData.id);

                                  documentReference.updateData({
                                    "quantidade":
                                        cartProduct.productData.quantidade--
                                  });
                                }

                                _atualizarQuantidade();
                                CartModel.of(context)
                                    .incProduct(cartProduct, nomeEmpresa);
                              }
                            : null,
                      ),
                      FlatButton(
                        onPressed: () {
                          // ignore: missing_return
                          Future<Null> _atualizarQuantidade() {
                            DocumentReference documentReference = Firestore
                                .instance
                                .collection("catalaoGoias")
                                .document(nomeEmpresa)
                                .collection("produtos")
                                .document(productData.category)
                                .collection("itens")
                                .document(productData.id);

                            documentReference.updateData({
                              "quantidade": cartProduct.productData.quantidade +
                                  quantidadeRemovida
                            });
                          }

                          _atualizarQuantidade();
                          CartModel.of(context)
                              .removeCartItem(cartProduct, nomeEmpresa);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => CartScreen(
                                      cartProduct.productData,
                                      nomeEmpresa,
                                      imagem,
                                      cidadeEstado,
                                      endereco,
                                      latitude,
                                      longitude,
                                      telefone)));
                        },
                        child: Text("Remover"),
                        textColor: Colors.red,
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );
    }

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: cartProduct.productData == null
            ? FutureBuilder<DocumentSnapshot>(
                future: Firestore.instance
                    .collection("catalaoGoias")
                    .document(nomeEmpresa)
                    .collection("produtos")
                    .document(cartProduct.categoria)
                    .collection("itens")
                    .document(cartProduct.pid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    cartProduct.productData =
                        ProductData.fromDocument(snapshot.data);
                    return _buildContent();
                  } else {
                    return Container(
                      height: 70,
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    );
                  }
                },
              )
            : _buildContent());
  }
}
