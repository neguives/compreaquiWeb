import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/datas/product_data.dart';
import 'package:compreaidelivery/versao_empresa/categorias/produtos/product_tile.dart';
import 'package:compreaidelivery/widgets/cart_button.dart';
import 'package:flutter/material.dart';

class ProdutosScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;
  String nomeEmpresa;
  final _nomeDoProduto_controller = TextEditingController();

  ProdutosScreen(
    this.snapshot,
    this.nomeEmpresa,
  );

  @override
  Widget build(BuildContext context) {
    _nomeDoProduto_controller.text = snapshot.data["title"];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
//          floatingActionButton: CartButton(
//            nomeEmpresa: nomeEmpresa,
//            imagemEmpresa: imagemEmpresa,
//            cidadeEstado: cidadeEstado,
//            endereco: endereco,
//            latitude: latitude,
//            longitude: longitude,
//            telefone: telefone,
//          ),
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Colors.white,
            title: Text(
              snapshot.data["title"], style: TextStyle(color: Colors.black),
//              snapshot.data["title"],
            ),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.lightGreen.shade100,
              tabs: <Widget>[
                Tab(
                    child: Text(
                      "Vizualizar em grade",
                      style: TextStyle(color: Colors.black38),
                    ),
                    icon: Icon(
                      Icons.grid_on,
                      color: Colors.black,
                    )),
                Tab(
                    child: Text(
                      "Compra Rápida",
                      style: TextStyle(color: Colors.black38),
                    ),
                    icon: Icon(
                      Icons.list,
                      color: Colors.black,
                    )),
              ],
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection("Catalão - GO")
                .document("Supermecado Bretas")
                .collection("Produtos e Servicos")
                .document(snapshot.data["title"])
                .collection("itens")
                .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else
                return TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    GridView.builder(
                        padding: EdgeInsets.all(5),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                          );
                        }),
                    ListView.builder(
                        padding: EdgeInsets.all(4),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          ProductData data = ProductData.fromDocument(
                              snapshot.data.documents[index]);
                          data.category = this.snapshot.documentID;
                          return ProductTile(
                            "list",
                            data,
                            nomeEmpresa,
                          );
                        })
                  ],
                );
            },
          )),
    );
  }
}
