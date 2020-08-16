import 'dart:io';
import 'package:compreaidelivery/versao_empresa/categorias/produtos/editar_produtos.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/ecoomerce/products_screen.dart';
import 'package:compreaidelivery/versao_empresa/categorias/produtos/produto_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CategoriaTile extends StatefulWidget {
  final _nomeCategoria = TextEditingController();
  final _posCategoria = TextEditingController();

  final DocumentSnapshot snapshot;
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;

  CategoriaTile(this.snapshot, this.nomeEmpresa, this.cidadeEstado);
  @override
  _CategoriaTileState createState() =>
      _CategoriaTileState(this.snapshot, this.nomeEmpresa);
}

class _CategoriaTileState extends State<CategoriaTile> {
  final _nomeCategoria = TextEditingController();
  final _posCategoria = TextEditingController();
  final _nomeProdutoController = TextEditingController();
  final _codigoBarraProdutoController = TextEditingController();
  final _preferenciaProdutoController = TextEditingController();
  final _descricaoProdutoController = TextEditingController();
  final _precoAtualProdutoController = TextEditingController();
  final _precoAnteriorProdutoController = TextEditingController();
  final _quantidadeEstoqueProdutoController = TextEditingController();
  final _codigoBarraBuscaController = TextEditingController();
  File _image;

  final DocumentSnapshot snapshot;
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;
  FlutterToast flutterToast;
  var listImages;
  String urlImagem1 = "url", urlImagem2 = "url";
  @override
  void initState() {
    super.initState();
    flutterToast = FlutterToast(context);
  }

  _CategoriaTileState(this.snapshot, this.nomeEmpresa);

  @override
  Widget build(BuildContext context) {
    _nomeCategoria.text = snapshot.data["title"];
    _posCategoria.text = snapshot.data["pos"];
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print("image Path $_image");
        Future uploadPic(BuildContext context) async {
          String filName = path.basename(_image.path);
          StorageReference firebaseStorageRef =
              FirebaseStorage.instance.ref().child(filName);
          StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
          StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
          String docUrl =
              await (await uploadTask.onComplete).ref.getDownloadURL();
          setState(() {
            print(docUrl);
          });

          snapshot.reference.updateData({"icon": docUrl});
        }

        uploadPic(context);
      });
    }

    Future getImageProduto1() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print("image Path $_image");
        Future uploadPic(BuildContext context) async {
          String filName = path.basename(_image.path);
          StorageReference firebaseStorageRef =
              FirebaseStorage.instance.ref().child(filName);
          StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
          StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
          String docUrl =
              await (await uploadTask.onComplete).ref.getDownloadURL();
          setState(() {
            print(docUrl);
          });

          urlImagem1 = docUrl;
        }

        _showImagemCarregada("imagem 1");
        uploadPic(context);
      });
    }

    Future getImageProduto2() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print("image Path $_image");
        Future uploadPic(BuildContext context) async {
          String filName = path.basename(_image.path);
          StorageReference firebaseStorageRef =
              FirebaseStorage.instance.ref().child(filName);
          StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
          StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
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

    return Stack(
      children: <Widget>[
        ExpansionTile(
          title: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(snapshot.data["icon"]),
            ),
            title: Text(
              snapshot.data["title"],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
//                  snapshot.reference.updateData({"title": "Carnes"});
            },
          ),
          children: [
            ExpansionTile(
              title: Text("Editar Categoria"),
              children: [
                Card(
                  elevation: 10,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        TextField(
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          controller: _nomeCategoria,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Nome da Categoria",
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
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          controller: _posCategoria,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Posição da categoria",
                            hintStyle: TextStyle(
                                fontFamily: "QuickSand",
                                fontSize: 17.0,
                                color: Colors.black87),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () async {
                            await getImage();
                          },
                          child: Container(
                              width: 150.0,
                              height: 150.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image: new NetworkImage(
                                        snapshot.data["icon"] != null
                                            ? snapshot.data["icon"]
                                            : ""),
                                  ))),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("(clique na imagem para alterá-la)"),
                        SizedBox(
                          height: 10,
                        ),
                        OutlineButton(
                          hoverColor: Colors.white,
                          highlightColor: Colors.white70,
                          highlightElevation: 10,

                          onPressed: () {
                            snapshot.reference
                                .updateData({"title": _nomeCategoria.text});
                            snapshot.reference
                                .updateData({"pos": _posCategoria.text});
                            _showToast();
                            _nomeCategoria.text = "";
                            _posCategoria.text = "";
                          },
                          child: Text(
                            'Salvar',
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
                      ],
                    ),
                  ),
                )
              ],
            ),
            ExpansionTile(
              title: Text("Adicionar Novo Produto"),
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
                                    controller: _precoAnteriorProdutoController,
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
                                      style: TextStyle(fontFamily: "QuickSand"),
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
                                      style: TextStyle(fontFamily: "QuickSand"),
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
                              _nomeProdutoController.text
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
                                          await Firestore.instance
                                              .collection("catalaoGoias")
                                              .document(nomeEmpresa)
                                              .collection("produtos")
                                              .document(snapshot.data["title"])
                                              .collection("itens")
                                              .document(
                                                  _codigoBarraProdutoController
                                                      .text);

                                      await referenciaOrdem.setData(({
                                        "title": _nomeProdutoController.text,
                                        "codigoBarras": codigoBarras,
                                        "price": price,
                                        "promo": _precoAnteriorProdutoController
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
                                          await Firestore.instance
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
                                        "promo": _precoAnteriorProdutoController
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

                                      _showToastProdutoCadastrado();
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
            ),
            ExpansionTile(
              title: Text("Modificar Produtos Existentes"),
              children: [
                Card(
                  elevation: 10,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        TextField(
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          controller: _codigoBarraBuscaController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Código de Barra",
                            hintStyle: TextStyle(
                                fontFamily: "QuickSand",
                                fontSize: 17.0,
                                color: Colors.black87),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        InkWell(
                            onTap: () async {
                              double codigoBarras = double.parse(
                                  _codigoBarraBuscaController.text);

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditarProdutos(
                                      nomeEmpresa,
                                      snapshot.data["title"],
                                      codigoBarras)));
                            },
                            child: Icon(Icons.search)),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  _showToast() {
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
          Text("Informações Salvas!"),
        ],
      ),
    );

    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
    _showToast2();
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

  _showToast2() {
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
          Text("O icone aparecerá em breve."),
        ],
      ),
    );

    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 5),
    );
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
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image as File;
      });
    });
  }
}
