import 'dart:io';

import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class PerfilUsuario extends StatefulWidget {
  String uid;

  PerfilUsuario(this.uid);
  @override
  _PerfilUsuarioState createState() => _PerfilUsuarioState(uid);
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  File _image;
  String uid;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  _PerfilUsuarioState(this.uid);
  final controllerNome = TextEditingController();
  final controllerApelido = TextEditingController();
  final controllerTelefone = TextEditingController();
  bool alterar;
  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      // ignore: deprecated_member_use
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print("image Path $_image");
        Future uploadPic(BuildContext context) async {
          String filName = basename(_image.path);
          StorageReference firebaseStorageRef =
              FirebaseStorage.instance.ref().child(filName);
          StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
          String docUrl =
              await (await uploadTask.onComplete).ref.getDownloadURL();
          setState(() {
            print(docUrl);
          });
          DocumentReference documentReference =
              Firestore.instance.collection("ConsumidorFinal").document(uid);

          documentReference.updateData({"photo": docUrl});
        }

        uploadPic(context);
      });
    }

    if (UserModel.of(context).isLoggedIn()) {
      return StreamBuilder(
        stream: Firestore.instance
            .collection("ConsumidorFinal")
            .document(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            controllerNome.text = snapshot.data["nome"].toString();
            controllerApelido.text = snapshot.data["apelido"].toString();
            controllerTelefone.text = snapshot.data["telefone"].toString();
            return Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  iconTheme: new IconThemeData(color: Colors.black),
                  backgroundColor: Colors.white,
                ),
                body: Stack(
                  children: <Widget>[
                    Container(
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: new AssetImage("assets/bg_meuspedidos.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      /* add child content content here */
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 1),
                      child: ListView(
                        children: <Widget>[
                          Card(
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Column(
                                    children: <Widget>[
                                      Center(
                                          child: Stack(
                                        children: <Widget>[
                                          Card(
                                              elevation: 40,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          100.0),
                                                  side: BorderSide(
                                                      color: Colors.white30)),
                                              child: Stack(
                                                children: <Widget>[
                                                  Container(
                                                      width: 150.0,
                                                      height: 150.0,
                                                      decoration:
                                                          new BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  new DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: new NetworkImage(snapshot.data[
                                                                            "photo"] !=
                                                                        null
                                                                    ? snapshot
                                                                            .data[
                                                                        "photo"]
                                                                    : ""),
                                                              ))),
                                                ],
                                              )),
                                        ],
                                      )),
                                      Center(
                                          child: IconButton(
                                        onPressed: () {
                                          getImage();
                                        },
                                        icon: Icon(Icons.camera_alt),
                                      )),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Column(
                                          children: <Widget>[
                                            TextField(
                                              autofocus: false,
                                              onTap: () {
                                                alterar = true;
                                              },
                                              controller: controllerNome,
                                              decoration: InputDecoration(
                                                labelText: "Nome Completo",
                                                border: InputBorder.none,
                                                icon: Icon(Icons.person),
                                              ),
                                            ),
                                            TextField(
                                              onChanged: (text) {
                                                alterar = true;
                                              },
                                              autofocus: false,
                                              controller: controllerApelido,
                                              decoration: InputDecoration(
                                                labelText: "Apelido",
                                                border: InputBorder.none,
                                                icon:
                                                    Icon(Icons.person_outline),
                                              ),
                                            ),
                                            TextField(
                                              onChanged: (text) {
                                                alterar = true;
                                              },
                                              autofocus: false,
                                              controller: controllerTelefone,
                                              decoration: InputDecoration(
                                                  labelText:
                                                      "Telefone para contato",
                                                  border: InputBorder.none,
                                                  icon: Icon(Icons.phone),
                                                  hintText:
                                                      'Informe o Telefone'),
                                            ),
                                            OutlineButton(
                                              hoverColor: Colors.white,
                                              highlightColor: Colors.white70,
                                              highlightElevation: 10,
                                              child: Text('Salvar Alterações'),
                                              onPressed: () async {
                                                FirebaseAuth _auth =
                                                    FirebaseAuth.instance;
                                                FirebaseUser firebaseUser;
                                                if (firebaseUser == null)
                                                  firebaseUser =
                                                      await _auth.currentUser();
                                                if (firebaseUser != null) {
                                                  DocumentReference
                                                      documentReference =
                                                      Firestore.instance
                                                          .collection(
                                                              "ConsumidorFinal")
                                                          .document(
                                                              firebaseUser.uid);

                                                  uid = firebaseUser.uid;
                                                  documentReference.updateData({
                                                    "nome": controllerNome.text
                                                  });
                                                  documentReference.updateData({
                                                    "apelido":
                                                        controllerApelido.text
                                                  });
                                                  documentReference.updateData({
                                                    "telefone":
                                                        controllerTelefone.text
                                                  });
                                                }
                                                showInSnackBar(
                                                    "Alterações Salvas",
                                                    context);
                                              },
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          18.0),
                                                  side: BorderSide(
                                                      color: Colors.white30)),
                                              // callback when button is clicked
                                              borderSide: BorderSide(
                                                color: Colors
                                                    .blueGrey, //Color of the border
                                                style: BorderStyle
                                                    .solid, //Style of the border
                                                width:
                                                    0.8, //width of the border
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ));
          }
        },
      );
    } else {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.remove_shopping_cart,
              size: 80,
              color: Colors.purple,
            ),
            SizedBox(height: 16),
            Text(
              "Faça login novamente",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            RaisedButton(
              color: Colors.purple,
              onPressed: () {},
              child: Text(
                "Entrar",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          ],
        ),
      );
    }
  }

  void showInSnackBar(String value, BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
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
}
