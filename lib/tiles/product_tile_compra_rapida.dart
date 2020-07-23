import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/datas/product_data.dart';
import 'package:compreaidelivery/ecoomerce/ProductScreen.dart';
import 'package:flutter/material.dart';

class ProductTileCompraRapida extends StatelessWidget {
  final String type;
  final ProductData product;
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;

  ProductTileCompraRapida(
    this.type,
    this.product,
    @required this.nomeEmpresa,
    @required this.imagemEmpresa,
    @required this.cidadeEstado,
    @required this.endereco,
    @required this.latitude,
    @required this.longitude,
    @required this.telefone,
  );
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
//        print(product.quantidade.toString());
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
      },
      child: Card(
          child: type == "list"
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
                                    product.promo == true
                                        ? "${((product.precoAnterior / product.price - 1) * 100).toStringAsPrecision(2)}% de Desconto"
                                        : "",
                                    style: (TextStyle(
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
                                              fontFamily: "Georgia"),
                                        ),
                                      ],
                                    ))),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_shopping_cart),
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
                                  fontSize: 14,
                                  color: product.promo == true
                                      ? Colors.red
                                      : Colors.blue.shade700),
                            ),
                            Text(
                              product.promo == true && product.quantidade > 0
                                  ? "Restam ${product.quantidade} unidades"
                                  : product.promo == false &&
                                          product.quantidade > 0
                                      ? ""
                                      : "Esgotado",
                              style:
                                  TextStyle(fontSize: 8, color: Colors.black54),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                )),
    );
  }
}
