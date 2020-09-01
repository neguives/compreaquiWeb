import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class ProductTile extends StatefulWidget {
  final String type, idDocument, categoria;
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;
  final DocumentSnapshot snapshot;

  ProductTile(this.type, this.nomeEmpresa, this.snapshot, this.idDocument,
      this.categoria);

  @override
  _ProductTileState createState() =>
      _ProductTileState(type, nomeEmpresa, snapshot, idDocument, categoria);
}

class _ProductTileState extends State<ProductTile> {
  final String type, idDocument, categoria;
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;
  final DocumentSnapshot snapshot;

  final _nomeProdutoController = TextEditingController();
  final _codigoBarraProdutoController = TextEditingController();
  final _preferenciaProdutoController = TextEditingController();
  final _descricaoProdutoController = TextEditingController();
  final _precoAtualProdutoController = TextEditingController();
  final _precoAnteriorProdutoController = TextEditingController();
  final _quantidadeEstoqueProdutoController = TextEditingController();
  File _image;

  FlutterToast flutterToast;
  var listImages;
  String urlImagem1 = "url", urlImagem2 = "url";
  _ProductTileState(this.type, this.nomeEmpresa, this.snapshot, this.idDocument,
      this.categoria);
  @override
  Widget build(BuildContext context) {
    List<dynamic> img = snapshot.data["images"];

    urlImagem1 = img.first;
    urlImagem2 = img.last;

    List variac = snapshot.data["variacao"];
    String variacao = variac.first;
    _nomeProdutoController.text = snapshot.data["title"];
    _codigoBarraProdutoController.text =
        snapshot.data["codigoBarras"].toString();
    _descricaoProdutoController.text = snapshot.data["description"];
    _precoAtualProdutoController.text = snapshot.data["price"].toString();
    _precoAnteriorProdutoController.text =
        snapshot.data["precoAnterior"].toString();
    _quantidadeEstoqueProdutoController.text =
        snapshot.data["quantidade"].toString();
    _preferenciaProdutoController.text = variacao;
    _nomeProdutoController.text = snapshot.data["title"];

    Future getImageProduto1() async {
      // ignore: deprecated_member_use
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print("image Path $_image");
        Future uploadPic(BuildContext context) async {
          String filName = path.basename(_image.path);
          StorageReference firebaseStorageRef =
              FirebaseStorage.instance.ref().child(filName);
          StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
          String docUrl =
              await (await uploadTask.onComplete).ref.getDownloadURL();
          setState(() {
            print(docUrl);
          });

          DocumentReference documentReference = Firestore.instance
              .collection("catalaoGoias")
              .document(nomeEmpresa)
              .collection("baseProdutos")
              .document(idDocument);

          urlImagem1 = docUrl;

          listImages = [urlImagem1, urlImagem2];
          documentReference.updateData({"images": listImages});
        }

        _showImagemCarregada("imagem 1");
        uploadPic(context);
      });
    }

    Future getImageProduto2() async {
      // ignore: deprecated_member_use
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print("image Path $_image");
        Future uploadPic(BuildContext context) async {
          String filName = path.basename(_image.path);
          StorageReference firebaseStorageRef =
              FirebaseStorage.instance.ref().child(filName);
          StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
          String docUrl =
              await (await uploadTask.onComplete).ref.getDownloadURL();
          setState(() {
            print(docUrl);
          });

          urlImagem2 = docUrl;
        }

        _showImagemCarregada("imagem 2");
        uploadPic(context);
      });
    }

    return InkWell(
      onTap: () {
//        print(product.quantidade.toString());
      },
      child: Card(
        child: type == "grid"
            ? ExpansionTile(
                title: Text(snapshot.data["title"]),
                children: [
                  Card(
                    color: Colors.white70,
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nomeProdutoController,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Nome do Produto",
                              labelText: "Nome do Produto",
                              hintStyle: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 17.0,
                                  color: Colors.black87),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: _codigoBarraProdutoController,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Código de Barras",
                              labelText: "Código de Barras",
                              hintStyle: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 17.0,
                                  color: Colors.black87),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: _precoAtualProdutoController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Preço Atual",
                              labelText: "Preço Atual",
                              hintStyle: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 17.0,
                                  color: Colors.black87),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: _preferenciaProdutoController,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Preferência",
                              hintText: "Preferencia",
                              hintStyle: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 17.0,
                                  color: Colors.black87),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            maxLines: 6,
                            controller: _descricaoProdutoController,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Descrição",
                              hintText: "Descrição",
                              hintStyle: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 17.0,
                                  color: Colors.black87),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          ExpansionTile(
                            title: Text("Produto Promocional ?"),
                            subtitle: Text(
                              "Se o produto estiver em promoção, adicione o Preço Anterior.",
                              style: TextStyle(fontSize: 10),
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: _precoAtualProdutoController,
                                      keyboardType: TextInputType.number,
                                      enabled: false,
                                      style: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 16.0,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Preço Atual",
                                        hintStyle: TextStyle(
                                            fontFamily: "QuickSand",
                                            fontSize: 15.0,
                                            color: Colors.black87),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      enabled: true,
                                      controller:
                                          _precoAnteriorProdutoController,
                                      style: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 16.0,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Preço Anterior",
                                        hintStyle: TextStyle(
                                            fontFamily: "QuickSand",
                                            fontSize: 15.0,
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            enabled: true,
                            controller: _quantidadeEstoqueProdutoController,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Quantidade em Estoque",
                              hintStyle: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 15.0,
                                  color: Colors.black87),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              Text("Defina as imagens do produto: ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: "QuickSand",
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await getImageProduto1();
                                        },
                                        child: Container(
                                            child:
                                                Icon(Icons.add_photo_alternate),
                                            width: 100.0,
                                            height: 100.0,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image:
                                                        new NetworkImage("")))),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Imagem 1",
                                        style:
                                            TextStyle(fontFamily: "QuickSand"),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await getImageProduto2();
                                        },
                                        child: Container(
                                            child:
                                                Icon(Icons.add_photo_alternate),
                                            width: 100.0,
                                            height: 100.0,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image:
                                                        new NetworkImage("")))),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Imagem 2",
                                        style:
                                            TextStyle(fontFamily: "QuickSand"),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          OutlineButton(
                            hoverColor: Colors.white,
                            highlightColor: Colors.white70,
                            highlightElevation: 10,

                            onPressed:
                                _nomeProdutoController
                                                .text
                                                .toString()
                                                .length >
                                            1 &&
                                        _codigoBarraProdutoController
                                                .toString()
                                                .length >
                                            1 &&
                                        _precoAtualProdutoController
                                                .toString()
                                                .length >
                                            1 &&
                                        _preferenciaProdutoController
                                                .toString()
                                                .length >
                                            1 &&
                                        _descricaoProdutoController
                                                .toString()
                                                .length >
                                            1 &&
                                        _quantidadeEstoqueProdutoController
                                                .toString()
                                                .length >
                                            1
                                    ? () async {
                                        listImages = [urlImagem1, urlImagem2];
                                        var variacao = [
                                          _preferenciaProdutoController.text
                                        ];

                                        double codigoBarras = double.parse(
                                            _codigoBarraProdutoController.text);
                                        double price = double.parse(
                                            _precoAtualProdutoController.text);
                                        double precoAnterior =
                                            _precoAnteriorProdutoController.text
                                                        .toString()
                                                        .length >
                                                    0
                                                ? double.parse(
                                                    _precoAnteriorProdutoController
                                                        .text)
                                                : 00.00;
                                        int quantidade = int.parse(
                                            _quantidadeEstoqueProdutoController
                                                .text);

                                        DocumentReference referenciaOrdem =
                                            Firestore.instance
                                                .collection("catalaoGoias")
                                                .document("Supermecado Bretas")
                                                .collection(
                                                    "Produtos e Servicos")
                                                .document(
                                                    snapshot.data["title"])
                                                .collection("itens")
                                                .document(
                                                    _codigoBarraProdutoController
                                                        .text);

                                        await referenciaOrdem.setData(({
                                          "title": _nomeProdutoController.text,
                                          "codigoBarras": codigoBarras,
                                          "price": price,
                                          "promo":
                                              _precoAnteriorProdutoController
                                                          .text !=
                                                      null
                                                  ? true
                                                  : false,
                                          "images": listImages,
                                          "precoAnterior": precoAnterior,
                                          "quantidade": quantidade,
                                          "variacao": variacao,
                                          "description":
                                              _descricaoProdutoController.text,
                                        }));

                                        DocumentReference referenciaOrdemBase =
                                            Firestore.instance
                                                .collection("BaseGlobal")
                                                .document("Produtos")
                                                .collection("itens")
                                                .document(
                                                    _codigoBarraProdutoController
                                                        .text);

                                        await referenciaOrdemBase.setData(({
                                          "title": _nomeProdutoController.text,
                                          "codigoBarras": codigoBarras,
                                          "price": price,
                                          "promo":
                                              _precoAnteriorProdutoController
                                                          .text !=
                                                      null
                                                  ? true
                                                  : false,
                                          "images": listImages,
                                          "precoAnterior": precoAnterior,
                                          "quantidade": quantidade,
                                          "variacao": variacao,
                                          "description":
                                              _descricaoProdutoController.text,
                                        }));

//                                        _showToastProdutoCadastrado();
                                      }
                                    : null,
                            child: Text(
                              'Cadastrar Produto',
                            ),

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
                          ),
                          OutlineButton(
                            hoverColor: Colors.white,
                            highlightColor: Colors.white70,
                            highlightElevation: 10,

                            onPressed: () {
//                            listImages.clear();
                              _clearProduto();
                            },
                            child: Text(
                              'Limpar Preenchimento',
                              style: TextStyle(fontSize: 10),
                            ),

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
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : ExpansionTile(
                title: Text(snapshot.data["title"]),
                children: [
                  Card(
                    color: Colors.white70,
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nomeProdutoController,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Nome do Produto",
                              labelText: "Nome do Produto",
                              hintStyle: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 17.0,
                                  color: Colors.black87),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: _codigoBarraProdutoController,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Código de Barras",
                              labelText: "Código de Barras",
                              hintStyle: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 17.0,
                                  color: Colors.black87),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: _precoAtualProdutoController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Preço Atual",
                              labelText: "Preço Atual",
                              hintStyle: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 17.0,
                                  color: Colors.black87),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: _preferenciaProdutoController,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Preferência",
                              hintText: "Preferencia",
                              hintStyle: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 17.0,
                                  color: Colors.black87),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            maxLines: 6,
                            controller: _descricaoProdutoController,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Descrição",
                              hintText: "Descrição",
                              hintStyle: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 17.0,
                                  color: Colors.black87),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          ExpansionTile(
                            title: Text("Produto Promocional ?"),
                            subtitle: Text(
                              "Se o produto estiver em promoção, adicione o Preço Anterior.",
                              style: TextStyle(fontSize: 10),
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: _precoAtualProdutoController,
                                      keyboardType: TextInputType.number,
                                      enabled: false,
                                      style: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 16.0,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Preço Atual",
                                        hintStyle: TextStyle(
                                            fontFamily: "QuickSand",
                                            fontSize: 15.0,
                                            color: Colors.black87),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      enabled: true,
                                      controller:
                                          _precoAnteriorProdutoController,
                                      style: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 16.0,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Preço Anterior",
                                        hintStyle: TextStyle(
                                            fontFamily: "QuickSand",
                                            fontSize: 15.0,
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            enabled: true,
                            controller: _quantidadeEstoqueProdutoController,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Quantidade em Estoque",
                              hintStyle: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 15.0,
                                  color: Colors.black87),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              Text("Defina as imagens do produto: ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: "QuickSand",
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await getImageProduto1();
                                        },
                                        child: Container(
                                            width: 150.0,
                                            height: 150.0,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: new NetworkImage(
                                                      urlImagem1.length < 5 !=
                                                              null
                                                          ? urlImagem1
                                                          : img.first),
                                                ))),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Imagem 1",
                                        style:
                                            TextStyle(fontFamily: "QuickSand"),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await getImageProduto1();
                                        },
                                        child: Container(
                                            width: 150.0,
                                            height: 150.0,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: new NetworkImage(
                                                      urlImagem2.length < 5 !=
                                                              null
                                                          ? urlImagem2
                                                          : img.last),
                                                ))),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Imagem 2",
                                        style:
                                            TextStyle(fontFamily: "QuickSand"),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          OutlineButton(
                            hoverColor: Colors.white,
                            highlightColor: Colors.white70,
                            highlightElevation: 10,

                            onPressed:
                                _nomeProdutoController
                                                .text
                                                .toString()
                                                .length >
                                            1 &&
                                        _codigoBarraProdutoController
                                                .toString()
                                                .length >
                                            1 &&
                                        _precoAtualProdutoController
                                                .toString()
                                                .length >
                                            1 &&
                                        _preferenciaProdutoController
                                                .toString()
                                                .length >
                                            1 &&
                                        _descricaoProdutoController
                                                .toString()
                                                .length >
                                            1 &&
                                        _quantidadeEstoqueProdutoController
                                                .toString()
                                                .length >
                                            1
                                    ? () async {
                                        var variacao = [
                                          _preferenciaProdutoController.text
                                        ];

                                        double codigoBarras = double.parse(
                                            _codigoBarraProdutoController.text);
                                        double price = double.parse(
                                            _precoAtualProdutoController.text);
                                        double precoAnterior =
                                            _precoAnteriorProdutoController.text
                                                        .toString()
                                                        .length >
                                                    0
                                                ? double.parse(
                                                    _precoAnteriorProdutoController
                                                        .text)
                                                : 00.00;
                                        int quantidade = int.parse(
                                            _quantidadeEstoqueProdutoController
                                                .text);

                                        DocumentReference referenciaOrdem =
                                            Firestore.instance
                                                .collection("catalaoGoias")
                                                .document(nomeEmpresa)
                                                .collection("baseProdutos")
                                                .document(idDocument);

                                        await referenciaOrdem.updateData(({
                                          "title": _nomeProdutoController.text,
                                          "codigoBarras": codigoBarras,
                                          "price": price,
                                          "promo":
                                              _precoAnteriorProdutoController
                                                          .text !=
                                                      "0.0"
                                                  ? true
                                                  : false,
                                          "precoAnterior": precoAnterior,
                                          "quantidade": quantidade,
                                          "variacao": variacao,
                                          "description":
                                              _descricaoProdutoController.text,
                                        }));

                                        _showToastProdutoCadastrado();
                                      }
                                    : null,
                            child: Text(
                              'Salvar Alterações',
                            ),

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
                          ),
//                          OutlineButton(
//                            hoverColor: Colors.white,
//                            highlightColor: Colors.white70,
//                            highlightElevation: 10,
//
//                            onPressed: () {
////                            listImages.clear();
//                              _clearProduto();
//                            },
//                            child: Text(
//                              'Limpar Preenchimento',
//                              style: TextStyle(fontSize: 10),
//                            ),
//
//                            shape: RoundedRectangleBorder(
//                                borderRadius: new BorderRadius.circular(18.0),
//                                side: BorderSide(
//                                    color: Colors
//                                        .white30)), // callback when button is clicked
//                            borderSide: BorderSide(
//                              color: Colors.blueGrey, //Color of the border
//                              style: BorderStyle.solid, //Style of the border
//                              width: 0.8, //width of the border
//                            ),
//                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  _showImagemCarregada(String img) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("A $img foi carregada "),
        ],
      ),
    );

    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 5),
    );
  }

  void onErrorCallback(error, stackTrace) {
    print(error);
    print(stackTrace);
  }

  Future chooseFile() async {
    // ignore: deprecated_member_use
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  _clearProduto() {
    _nomeProdutoController.text = "";
    _precoAnteriorProdutoController.text = "";
    urlImagem1 = "url";
    urlImagem2 = "url";
    _codigoBarraProdutoController.text = "";
    _quantidadeEstoqueProdutoController.text = "";
    _descricaoProdutoController.text = "";
    _preferenciaProdutoController.text = "";
  }

  _showToastProdutoCadastrado() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Seu produto foi cadastrado!"),
        ],
      ),
    );

    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 5),
    );
  }
}
