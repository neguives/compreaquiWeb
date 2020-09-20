import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/datas/cart_product.dart';
import 'package:compreaidelivery/datas/product_data.dart';
import 'package:compreaidelivery/ecoomerce/cart_screen.dart';
import 'package:compreaidelivery/models/cart_model.dart';
import 'package:compreaidelivery/nuagetRefresh/baseDadosProdutos.dart';
import 'package:compreaidelivery/tiles/product_tile.dart';
import 'package:compreaidelivery/widgets/cart_button.dart';
import 'package:dio/dio.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

// ignore: must_be_immutable

// ignore: camel_case_types
// ignore: must_be_immutable
class Products_Screen extends StatefulWidget {
  final DocumentSnapshot snapshot;
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;
  int id_categoria;

  List<BaseDadosProdutos> baseDadosProdutos;
  Products_Screen(
      this.snapshot,
      this.nomeEmpresa,
      this.imagemEmpresa,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.telefone,
      this.id_categoria,
      this.baseDadosProdutos);
  @override
  _Products_ScreenState createState() => _Products_ScreenState(
      this.snapshot,
      this.nomeEmpresa,
      this.imagemEmpresa,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.telefone,
      this.id_categoria,
      this.baseDadosProdutos);
}

// ignore: camel_case_types
class _Products_ScreenState extends State<Products_Screen> {
  final DocumentSnapshot snapshot;
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;
  int id_categoria;
  List<BaseDadosProdutos> baseDadosProdutos;

  _Products_ScreenState(
      this.snapshot,
      this.nomeEmpresa,
      this.imagemEmpresa,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.telefone,
      this.id_categoria,
      this.baseDadosProdutos);
  final pequisarController = TextEditingController();
  String produtoPesquisado;
  List<BaseDadosProdutos> baseProdutos = List<BaseDadosProdutos>();

  @override
  void setState(VoidCallback fn) {}

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductData product;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Stack(children: <Widget>[
              Icon(
                Icons.shopping_cart,
                color: Colors.deepPurple,
                size: 35,
              ),
              ScopedModelDescendant<CartModel>(
                  builder: (context, child, cartModel) {
                if (cartModel.products.length != null &&
                    cartModel.products.length > 0) {
                  return Positioned(
                      right: 0,
                      child: Container(
                        alignment: Alignment.center,
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        //color: Colors.redAccent,
                        child: Text('${cartModel.products.length}',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ));
                } else
                  return Container(
                    height: 1,
                    width: 1,
                  );
              }),
            ]),
            onPressed: () {
              ProductData product;

              CartModel.of(context).verItens(
                  context,
                  product,
                  imagemEmpresa,
                  cidadeEstado,
                  endereco,
                  latitude,
                  longitude,
                  telefone,
                  nomeEmpresa);
            },
            backgroundColor: Colors.white70,
          ),
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Colors.white,
            title: Text(
              snapshot.data["title"],
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: ScopedModelDescendant<CartModel>(
                  builder: (context, child, model) {
                    List<BaseDadosProdutos> base =
                        model.getAdicionarValoresAtualizados();
                    return FutureBuilder<QuerySnapshot>(
                      future: id_categoria == 0
                          ? Firestore.instance
                              .collection(cidadeEstado)
                              .document(nomeEmpresa)
                              .collection("baseProdutos")
                              .orderBy("title")
                              .startAt([produtoPesquisado]).getDocuments()
                          : Firestore.instance
                              .collection(cidadeEstado)
                              .document(nomeEmpresa)
                              .collection("baseProdutos")
                              .where("id_categoria", isEqualTo: id_categoria)
                              .orderBy("title")
                              .startAt([produtoPesquisado]).getDocuments(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: Container(
                              height: 200,
                              width: 200,
                              child: FlareActor(
                                "assets/fruit_loading.flr",
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                                animation: "move",
                              ),
                            ),
                          );
                        else
//                          print("Deus " + baseDadosProdutos.toString());

                          return GridView.builder(
                              padding: EdgeInsets.all(5),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 4,
                                      childAspectRatio: 0.65),
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                double valor;
                                ProductData data = ProductData.fromDocument(
                                    snapshot.data.documents[index]);
                                data.category = this.snapshot.documentID;
                                List<BaseDadosProdutos> _searchResult = [];
                                baseProdutos.forEach((element) {
                                  if (element.cODIGO
                                      .contains(data.codigoBarras)) {
                                    _searchResult.add(element);
                                    valor = double.parse(
                                        _searchResult[0].vLVARJ.toString());
                                    data.price = 555;
                                  }

                                  print(_searchResult[0].vLVARJ.toString);
                                });

                                return ProductTile(
                                    baseDadosProdutos,
                                    "grid",
                                    data,
                                    nomeEmpresa,
                                    imagemEmpresa,
                                    cidadeEstado,
                                    endereco,
                                    latitude,
                                    longitude,
                                    telefone);
                              });
                      },
                    );
                  },
                ),
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Card(
                    elevation: 10,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: ScopedModelDescendant<CartModel>(
                          builder: (context, child, model) {
                            return TextField(
                              maxLines: 1,
                              controller: pequisarController,
                              enabled: true,
                              onEditingComplete: () {
                                setState(() {});
                                produtoPesquisado =
                                    pequisarController.text.toUpperCase();
                                model.setProdutoPesquisado(
                                    pequisarController.text);
                                // ignore: invalid_use_of_protected_member
                                model.notifyListeners();
                                initState();
                              },
                              style: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black),
                              decoration: InputDecoration.collapsed(
                                hintText: "Pesquisar produto",
                              ),
                            );
                          },
                        )),
                  )),
            ],
          )),
    );
  }
}
