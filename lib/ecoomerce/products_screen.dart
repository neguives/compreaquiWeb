import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/Bottom/bottom_principal.dart';
import 'package:compreaidelivery/datas/product_data.dart';
import 'package:compreaidelivery/ecoomerce/produtosTwo.dart';
import 'package:compreaidelivery/models/cart_model.dart';
import 'package:compreaidelivery/tiles/product_tile.dart';
import 'package:compreaidelivery/widgets/cart_button.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Products_Screen extends StatefulWidget {
  final DocumentSnapshot snapshot;
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;

  Products_Screen(
      this.snapshot,
      this.nomeEmpresa,
      this.imagemEmpresa,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.telefone);
  @override
  _Products_ScreenState createState() => _Products_ScreenState(
      this.snapshot,
      this.nomeEmpresa,
      this.imagemEmpresa,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.telefone);
}

class _Products_ScreenState extends State<Products_Screen> {
  final DocumentSnapshot snapshot;
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;

  _Products_ScreenState(
      this.snapshot,
      this.nomeEmpresa,
      this.imagemEmpresa,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.telefone);
  final pequisarController = TextEditingController();
  String produtoPesquisado;

  @override
  void setState(VoidCallback fn) {}

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          floatingActionButton: CartButton(
            nomeEmpresa: nomeEmpresa,
            imagemEmpresa: imagemEmpresa,
            cidadeEstado: cidadeEstado,
            endereco: endereco,
            latitude: latitude,
            longitude: longitude,
            telefone: telefone,
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
                    return FutureBuilder<QuerySnapshot>(
                      future: Firestore.instance
                          .collection(cidadeEstado)
                          .document(nomeEmpresa)
                          .collection("produtos")
                          .document(snapshot.data["title"])
                          .collection("itens")
                          .orderBy("title")
                          .startAt([produtoPesquisado]).getDocuments(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        else
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
                                ProductData data = ProductData.fromDocument(
                                    snapshot.data.documents[index]);
                                data.category = this.snapshot.documentID;
                                print(data.quantidade);
                                return ProductTile(
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
