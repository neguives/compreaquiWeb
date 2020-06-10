import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/models/auth.dart';
import 'package:compreaidelivery/models/user_model.dart';
import 'package:compreaidelivery/routes/routes.dart';
import 'package:compreaidelivery/telas/Login.dart';
import 'package:compreaidelivery/telas/perfil_usuario.dart';
import 'package:compreaidelivery/telas/recomendar.dart';
import 'package:compreaidelivery/tiles/drawer_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatefulWidget {
  String uid;

  CustomDrawer(this.uid);

  @override
  _CustomDrawerState createState() => _CustomDrawerState(uid);
}

class _CustomDrawerState extends State<CustomDrawer> {
  UserModel user;
  String uid;
  String photo;

  _CustomDrawerState(this.uid);

  @override
  Widget build(BuildContext context) {
    print(uid);
    return Drawer(
        child: Stack(
      children: <Widget>[
        Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/background_drawer.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: null /* add child content content here */
            ),
        ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createHeader(),
            Divider(),
            _createDrawerItem(
                icon: Icons.contacts,
                text: 'Meu Perfil',
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PerfilUsuario(uid)));
                }),
            _createDrawerItem(
              icon: Icons.business,
              text: 'Sobre o CompreAqui',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.profile),
            ),
//            _createDrawerItem(
//                icon: Icons.business_center,
//                text: 'Recomendar Estabelecimento',
//                onTap: () {
//                  Navigator.of(context).push(MaterialPageRoute(
//                      builder: (context) => RecomendarEstabelecimento()));
//                }),
            _createDrawerItem(
              icon: Icons.library_books,
              text: 'Termos de Uso',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.profile),
            ),
            _createDrawerItem(
                onTap: () {
                  _desconectar(context);
                },
                icon: Icons.exit_to_app,
                text: 'Desconectar'),
            Divider(),
            Row(
              children: <Widget>[
                Container(
                  color: Colors.black,
                  width: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text("Nossas Redes Sociais"),
                ),
                Container(
                  color: Colors.black38,
                  width: 10,
                ),
              ],
            ),
            _createDrawerItem(
                icon: FontAwesome.instagram,
                text: 'Instagram',
                onTap: () async {
                  var instagramUrl =
                      "https://www.instagram.com/compreaquidelivery/";
                  await canLaunch(instagramUrl)
                      ? launch(instagramUrl)
                      : print(
                          "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                }),
            _createDrawerItem(
                icon: FontAwesome.whatsapp,
                text: 'WhatsApp',
                onTap: () async {
                  String whatsappUrl =
                      "whatsapp://send?phone=${"+5564992961918"}&text=${"Olá, vim através do App CompreAqui!"}";
                  await canLaunch(whatsappUrl)
                      ? launch(whatsappUrl)
                      : print(
                          "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                }),
          ],
        )
      ],
    ));
  }

  Widget _createHeader() {
    teste() async {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

      FirebaseUser user = await _firebaseAuth.currentUser();
    }

    teste();
    return StreamBuilder(
        stream: Firestore.instance
            .collection("ConsumidorFinal")
            .document(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
          } else {
            return Padding(
              padding: EdgeInsets.only(top: 40),
              child: Column(
                children: <Widget>[
                  Center(
                      child: Card(
                    elevation: 40,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(100.0),
                        side: BorderSide(color: Colors.white30)),
                    child: Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: new NetworkImage(
                                  snapshot.data["photo"] != null
                                      ? snapshot.data["photo"]
                                      : ""),
                            ))),
                  )),
                  Text(
                    snapshot.data["nome"],
                    style: TextStyle(fontFamily: "QuickSand"),
                  ),
                  Text(
                    snapshot.data["email"],
                    style: TextStyle(
                        color: Colors.black54, fontFamily: "QuickSand"),
                  ),
                ],
              ),
            );
          }
        });
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}

void desconectar() {
  FirebaseAuth auth;
  auth.signOut();
}

Future<Login> _desconectar(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  await googleSignIn.signOut();

  Navigator.pop(context);
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  return Login();
}

drawerComImagem() async {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user = await _firebaseAuth.currentUser();
}

void signOut() {}
