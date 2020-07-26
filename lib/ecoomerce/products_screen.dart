import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/datas/product_data.dart';
import 'package:compreaidelivery/tiles/product_tile.dart';
import 'package:compreaidelivery/tiles/product_tile_compra_rapida.dart';
import 'package:compreaidelivery/widgets/cart_button.dart';
import 'package:flutter/material.dart';

class Products_Screen extends StatelessWidget {
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
  final buscarProdutoController = TextEditingController();

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
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(),
                  );
                },
              ),
            ],
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
                .collection(cidadeEstado)
                .document(nomeEmpresa)
                .collection("Produtos e Servicos")
                .document(snapshot.data["title"])
                .collection("itens")
                .orderBy("title")
                .startAt(["ADORALLE"]).getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else
                return Stack(
                  children: [
                    TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        GridView.builder(
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
                            }),
                        ListView.builder(
                            padding: EdgeInsets.all(4),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              ProductData data = ProductData.fromDocument(
                                  snapshot.data.documents[index]);
                              data.category = this.snapshot.documentID;
                              return ProductTileCompraRapida(
                                  "list",
                                  data,
                                  nomeEmpresa,
                                  imagemEmpresa,
                                  cidadeEstado,
                                  endereco,
                                  latitude,
                                  longitude,
                                  telefone);
                            })
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Card(
                        child: Padding(
                          child: TextField(
                            maxLines: 1,
                            controller: buscarProdutoController,
                            enabled: false,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Observação",
                              labelText: "Observação",
                              hintStyle: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 12.0,
                                  color: Colors.black87),
                            ),
                          ),
                          padding: EdgeInsets.all(5),
                        ),
                      ),
                    )
                  ],
                );
            },
          )),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    print(query);
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return null;
  }
}
