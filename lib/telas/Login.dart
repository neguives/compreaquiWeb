import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/models/auth.dart';
import 'package:compreaidelivery/telas/geolocalizacaoUsuario.dart';
import 'package:compreaidelivery/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:compreaidelivery/style/theme.dart' as Theme;
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _Login createState() => new _Login();
}

class _Login extends State<Login> with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _apelidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _cidadeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKeyRegister = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();
  final FocusNode myFocusNodeApelido = FocusNode();
  final FocusNode myFocusNodeTelefone = FocusNode();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  PageController _pageController;
  final telefoneController = TextEditingController();
  Color left = Colors.black;
  Color right = Colors.white;
  String uid;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        // ignore: missing_return
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height >= 775.0
                ? MediaQuery.of(context).size.height
                : 775.0,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Theme.Colors.loginGradientStart,
                    Theme.Colors.loginGradientEnd
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new AssetImage("assets/fundocatalao.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: null /* add child content content here */,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 1.0),
                      child: new Padding(
                          padding: EdgeInsets.only(
                              left: 30, right: 30, top: 30, bottom: 20),
                          child: Image.asset(
                            'assets/logo.png',
                            width: 200,
                            height: 200,
                          )),
                    ),
                    Expanded(
                      flex: 2,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (i) {
                          if (i == 0) {
                            setState(() {
                              right = Colors.white;
                              left = Colors.black;
                            });
                          } else if (i == 1) {
                            setState(() {
                              right = Colors.black;
                              left = Colors.white;
                            });
                          }
                        },
                        children: <Widget>[
                          new ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignIn(context),
                          ),
                          new ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                              child: SingleChildScrollView(
                                child: _buildSignUp(context),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  String msg = "";
  Future<Login> _desconectar(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    final GoogleSignIn googleSignIn = GoogleSignIn();

    await googleSignIn.signOut();

    return Login();
  }

  void showInSnackBar(String value) {
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

  Widget _buildSignIn(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return Form(
          key: _formKey,
          child: ListView(children: <Widget>[
            Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Card(
                      elevation: 2.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        width: 300.0,
                        height: 190.0,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20.0,
                                  bottom: 20.0,
                                  left: 25.0,
                                  right: 25.0),
                              child: TextField(
                                focusNode: myFocusNodeEmailLogin,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.mail,
                                    color: Colors.black,
                                    size: 22.0,
                                  ),
                                  hintText: "E-mail",
                                  hintStyle: TextStyle(
                                      fontFamily: "Georgia", fontSize: 17.0),
                                ),
                              ),
                            ),
                            Container(
                              width: 250.0,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20.0,
                                  bottom: 20.0,
                                  left: 25.0,
                                  right: 25.0),
                              child: TextField(
                                focusNode: myFocusNodePasswordLogin,
                                controller: _senhaController,
                                obscureText: _obscureTextLogin,
                                style: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.lock,
                                    size: 22.0,
                                    color: Colors.black,
                                  ),
                                  hintText: "Minha Senha",
                                  hintStyle: TextStyle(
                                      fontFamily: "WorkSansSemiBold",
                                      fontSize: 17.0),
                                  suffixIcon: GestureDetector(
                                    onTap: _toggleLogin,
                                    child: Icon(
                                      _obscureTextLogin
                                          ? Icons.remove_red_eye
                                          : Icons.remove_red_eye,
                                      size: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 170.0),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Theme.Colors.loginGradientStart,
                              offset: Offset(1.0, 6.0),
                              blurRadius: 20.0,
                            ),
                            BoxShadow(
                              color: Theme.Colors.loginGradientEnd,
                              offset: Offset(1.0, 6.0),
                              blurRadius: 20.0,
                            ),
                          ],
                          gradient: new LinearGradient(
                              colors: [Colors.green.shade500, Colors.lightBlue],
                              begin: const FractionalOffset(0.2, 0.2),
                              end: const FractionalOffset(1.0, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        child: MaterialButton(
                          minWidth: 100,
                          highlightColor: Colors.transparent,
                          splashColor: Theme.Colors.loginGradientEnd,
                          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                          child: Text(
                            "Entrar",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontFamily: "WorkSansBold"),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {}

                            model.signIn(
                                email: _emailController.text,
                                pass: _senhaController.text,
                                onSucess: _onSucess,
                                onFail: _onFail);

                            if (Platform.isIOS) {
                            } else {
                              model.saveToken();
                            }
                          },
                        )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [
                                Colors.white10,
                                Colors.white,
                              ],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        width: 100.0,
                        height: 1.0,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(1),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 40,
                        child: FlatButton(
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            disabledColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            color: Colors.transparent,
                            onPressed: () async {
                              model.signIn(
                                  email: "teste@compreaqui.com.br",
                                  pass: "221295",
                                  onSucess: _onSucess2,
                                  onFail: _onFail);

                              _desconectar(context);
                              AuthService authService = AuthService();
                              bool res = await authService.googleSignIn();
                              if (!res) {
                                print("Erro ao fazer o login com o Google");
                              } else {
                                telefoneController.text = "";
                                FirebaseAuth _auth = FirebaseAuth.instance;
                                FirebaseUser firebaseUser;

                                if (firebaseUser == null)
                                  firebaseUser = await _auth.currentUser();
                                if (firebaseUser != null) {
                                  uid = firebaseUser.uid;
                                  showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      // return object of type Dialog
                                      return AlertDialog(
                                        title: new Center(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/icon_zap.png",
                                                    height: 50,
                                                    width: 50,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                      "Qual é o seu whatsapp?"),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        content: new TextField(
                                          maxLines: 1,
                                          controller: telefoneController,
                                          enabled: true,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              fontFamily: "WorkSansSemiBold",
                                              fontSize: 16.0,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: "Telefone com DDD",
                                            labelText: "Telefone com DDD",
                                            hintStyle: TextStyle(
                                                fontFamily: "QuickSand",
                                                fontSize: 17.0,
                                                color: Colors.black87),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: new Text("Continuar"),
                                            onPressed: () async {
                                              uid = firebaseUser.uid;
                                              DocumentReference
                                                  documentReference = Firestore
                                                      .instance
                                                      .collection(
                                                          "ConsumidorFinal")
                                                      .document(
                                                          firebaseUser.uid);

//            Mudar quando for lançar
//            documentReference.updateData({"cidade": cidadeEstado});
                                              documentReference.updateData({
                                                "telefone":
                                                    telefoneController.text
                                              });

                                              Future.delayed(
                                                      Duration(seconds: 1))
                                                  .then((_) async {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                GeolocalizacaoUsuario()));
                                              });
                                            },
                                          )
                                          // usually buttons at the bottom of the dialog
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            },
                            child: Image.asset(
                              'assets/gmail.png',
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          "Não tem conta ? Arraste para o lado!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black26),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ]));
    });
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 10.0),
        child:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          return Form(
            key: _formKeyRegister,
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Card(
                      elevation: 2.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                          width: 300.0,
                          height: 360.0,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 1.0,
                                      left: 25.0,
                                      right: 25.0),
                                  child: TextField(
                                    focusNode: myFocusNodeApelido,
                                    controller: _apelidoController,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 16.0,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        Icons.person_outline,
                                        color: Colors.black,
                                      ),
                                      hintText: "Apelido",
                                      hintStyle: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 20.0,
                                      left: 25.0,
                                      right: 25.0),
                                  child: TextField(
                                    focusNode: myFocusNodeName,
                                    controller: _nameController,
                                    keyboardType: TextInputType.text,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    style: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 16.0,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.user,
                                        color: Colors.black,
                                      ),
                                      hintText: "Nome Completo",
                                      hintStyle: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 20.0,
                                      bottom: 20.0,
                                      left: 25.0,
                                      right: 25.0),
                                  child: TextField(
                                    focusNode: myFocusNodeEmail,
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 16.0,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.envelope,
                                        color: Colors.black,
                                      ),
                                      hintText: "Email",
                                      hintStyle: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 20.0,
                                      bottom: 20.0,
                                      left: 25.0,
                                      right: 25.0),
                                  child: TextField(
                                    focusNode: myFocusNodePassword,
                                    controller: _senhaController,
                                    obscureText: _obscureTextSignup,
                                    style: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 16.0,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.lock,
                                        color: Colors.black,
                                      ),
                                      hintText: "Senha",
                                      hintStyle: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 16.0),
                                      suffixIcon: GestureDetector(
                                        onTap: _toggleSignup,
                                        child: Icon(
                                          _obscureTextSignup
                                              ? FontAwesomeIcons.eye
                                              : FontAwesomeIcons.eyeSlash,
                                          size: 15.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  child: Text(
                                    "Ao se cadastrar, você estará concordando com nossos termos de uso.",
                                    style: TextStyle(
                                        fontSize: 8,
                                        decoration: TextDecoration.underline),
                                  ),
                                  onTap: () {
                                    _showDialogTermos(context);
                                  },
                                )
                              ],
                            ),
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 340.0),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.blue,
                            offset: Offset(1.0, 6.0),
                            blurRadius: 20.0,
                          ),
                          BoxShadow(
                            color: Theme.Colors.loginGradientEnd,
                            offset: Offset(1.0, 6.0),
                            blurRadius: 20.0,
                          ),
                        ],
                        gradient: new LinearGradient(
                            colors: [Colors.green, Colors.lightGreen],
                            begin: const FractionalOffset(0.2, 0.2),
                            end: const FractionalOffset(1.0, 1.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      child: MaterialButton(
                        highlightColor: Colors.blue,
                        elevation: 20,
                        splashColor: Colors.blue,
                        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 42.0),
                          child: Text(
                            "Registrar",
                            style: TextStyle(
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  )
                                ],
                                color: Colors.white.withBlue(244),
                                fontSize: 25.0,
                                fontFamily: "WorkSansBold"),
                          ),
                        ),
                        onPressed: () {
                          void _showDialogTelefone(BuildContext context) {
                            telefoneController.text = "";
                            // flutter defined function
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  title: new Center(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/icon_zap.png",
                                              height: 50,
                                              width: 50,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text("Qual é o seu whatsapp?"),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  content: new TextField(
                                    maxLines: 1,
                                    controller: telefoneController,
                                    enabled: true,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 16.0,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Telefone para contato",
                                      labelText: "Telefone para contato",
                                      hintStyle: TextStyle(
                                          fontFamily: "QuickSand",
                                          fontSize: 17.0,
                                          color: Colors.black87),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    new FlatButton(
                                      child: new Text("Continuar"),
                                      onPressed: () {
                                        if (_formKeyRegister.currentState
                                            .validate()) {
                                          print(telefoneController.text);
                                          Map<String, dynamic> userData = {
                                            "photo":
                                                "https://firebasestorage.googleapis.com/v0/b/compreai-delivery.appspot.com/o/user.png?alt=media&token=cd7aea4b-4d19-4b10-adce-03008b277da7",
                                            "nome": _nameController.text.trim(),
                                            "apelido":
                                                _apelidoController.text.trim(),
                                            "email":
                                                _emailController.text.trim(),
                                            "telefone": telefoneController
                                                        .text.length >=
                                                    5
                                                ? telefoneController.text.trim()
                                                : "00000",
                                            "cidade":
                                                _cidadeController.text.trim(),
                                            "latitude": "-12.117111",
                                            "logintude": "-38.430454",
                                            "tipoPerfil": "Consumidor"
                                          };

                                          model.signUp(
                                              userData: userData,
                                              pass: _senhaController.text,
                                              onSucess: _onSucessRegister,
                                              onFail: _onFailRegister);

                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }

                          _showDialogTelefone(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }));
  }

  Future<void> _onSucessRegister() async {
    final token = await FirebaseMessaging().getToken();
    print("token $token");
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Parabéns, sua conta foi criada com sucesso !"),
      backgroundColor: Colors.blueGrey,
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => GeolocalizacaoUsuario()));
    });
  }

  _onSucess() async {
    Future.delayed(Duration(seconds: 1)).then((_) async {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => GeolocalizacaoUsuario()));
    });
  }

  _onSucess2() {}

  void _onFail() async {
    await _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Sua senha está errada."),
      backgroundColor: Colors.blueGrey,
      duration: Duration(seconds: 3),
    ));
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: new Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock,
                        size: 50,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Deseja redefinir sua senha ?",
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                children: [
                  FlatButton(
                    child: new Text("Redefinir"),
                    onPressed: () async {
                      FirebaseAuth auth = FirebaseAuth.instance;

                      auth.sendPasswordResetEmail(email: _emailController.text);

                      Navigator.pop(context);
                      await _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                            "Um e-mail de redefinição de senha foi enviado para ${_emailController.text}"),
                        backgroundColor: Colors.blueGrey,
                        duration: Duration(seconds: 3),
                      ));
                    },
                  ),
                  FlatButton(
                      child: new Text("Cancelar"),
                      onPressed: () async {
                        Navigator.pop(context);
                      })
                ],
              ),
            ]);
      },
    );
  }

  void _onFailRegister() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Houve algum erro ao tentar fazer seu registro."),
      backgroundColor: Colors.blueGrey,
      duration: Duration(seconds: 2),
    ));
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  _loginGoogle() async {
    AuthService authService = AuthService();
    bool res = await authService.googleSignIn();
    if (!res) {
      print("Erro ao fazer o login com o Google");
    } else {
      telefoneController.text = "";
      FirebaseAuth _auth = FirebaseAuth.instance;
      FirebaseUser firebaseUser;

      if (firebaseUser == null) firebaseUser = await _auth.currentUser();
      if (firebaseUser != null) {
        uid = firebaseUser.uid;
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon_zap.png",
                          height: 50,
                          width: 50,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Qual é o seu whatsapp?"),
                      ],
                    )
                  ],
                ),
              ),
              content: new TextField(
                maxLines: 1,
                controller: telefoneController,
                enabled: true,
                keyboardType: TextInputType.number,
                style: TextStyle(
                    fontFamily: "WorkSansSemiBold",
                    fontSize: 16.0,
                    color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Telefone com DDD",
                  labelText: "Telefone com DDD",
                  hintStyle: TextStyle(
                      fontFamily: "QuickSand",
                      fontSize: 17.0,
                      color: Colors.black87),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: new Text("Continuar"),
                  onPressed: () async {
                    uid = firebaseUser.uid;
                    DocumentReference documentReference = Firestore.instance
                        .collection("ConsumidorFinal")
                        .document(firebaseUser.uid);

//            Mudar quando for lançar
//            documentReference.updateData({"cidade": cidadeEstado});
                    documentReference
                        .updateData({"telefone": telefoneController.text});

                    Future.delayed(Duration(seconds: 1)).then((_) async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => GeolocalizacaoUsuario()));
                    });
                  },
                )
                // usually buttons at the bottom of the dialog
              ],
            );
          },
        );
      }
    }
    // flutter defined function
  }
}

_showDialogTermos(BuildContext context) {
  // flutter defined function
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.description)],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Termos de Utilização"),
                ],
              )
            ],
          ),
        ),
        content: new SingleChildScrollView(
          child: Column(
            children: [
              Html(
                data:
                    """<p>Os presentes termos de uso (\&ldquo;<u>Termos\</u>&rdquo;) representam os termos e condi&ccedil;&otilde;es que regem a presta&ccedil;&atilde;o dos Servi&ccedil;os pelo&nbsp;<strong>CompreAqui Delivery </strong><strong>-</strong><strong> Alves do Vale e Almeida LTDA.</strong>, inscrita no CNPJ sob o n&ordm; 37.314.012/0001-09, com sede na Cidade de Catal&atilde;o, Estado de Goi&aacute;s (\ &ldquo;CompreAqui Delivery\&rdquo;) por meio do aplicativo CompreAqui Delivery dispon&iacute;vel na App Store e na Google Play (\ &ldquo;<u>Plataforma</u>\&rdquo;) para voc&ecirc; (\&ldquo;<u>Usu&aacute;rio</u>\&rdquo;).</p>

<p>\nAo se cadastrar em nossa Plataforma e utilizar os nossos Servi&ccedil;os, voc&ecirc; declara estar de acordo com os termos e condi&ccedil;&otilde;es dispostos neste instrumento e declara que aceitou todas as regras, condi&ccedil;&otilde;es e obriga&ccedil;&otilde;es dispostas neste instrumento e compromete-se a cumpri-las. Portanto, leia estes Termos com aten&ccedil;&atilde;o.</p>

<p>\n&nbsp; Ressaltamos que poderemos oferecer recursos, servi&ccedil;os e/ou condi&ccedil;&otilde;es especiais que possuir&atilde;o seus pr&oacute;prios termos e condi&ccedil;&otilde;es que se aplicam concomitantemente a estes Termos, sendo certo que caso haja conflito entre o disposto nos termos espec&iacute;ficos e nestes Termos, os primeiros prevalecer&atilde;o no que forem diferentes do aqui disposto.</p>

<p>\n O&nbsp;<strong>COMPREAQUI DELIVERY</strong>&nbsp;&Eacute; UMA PLATAFORMA ONLINE QUE FUNCIONA COMO INTERMEDI&Aacute;RIA COMERCIAL CONECTANDO FORNECEDORES E CLIENTES. O&nbsp;<strong>COMPREAQUI DELIVERY</strong>&nbsp; N&Atilde;O &Eacute; PARTE DE NENHUM ACORDO CELEBRADO ENTRE OS SUPERMERCADOS E CLIENTES, BEM COMO N&Atilde;O ATUA COMO SEGURADORA, N&Atilde;O PRESTA SERVI&Ccedil;OS DE ENTREGA DE PRODUTOS E N&Atilde;O POSSUI NENHUMA RESPONSABILIDADE SOBRE A CONDUTA DOS SUPERMERCADOS, CLIENTES E TRANSPORTADORES.</p>

<p>&nbsp;</p>

<ol>
	<li><strong>DEFINI&Ccedil;&Otilde;ES</strong></li>
</ol>

<p><strong>Janelas emergentes (Pop-Ups):</strong>&nbsp;Janela ou aviso da internet que emerge automaticamente em qualquer momento quando a Plataforma &eacute; utilizada, especialmente utilizado para a formaliza&ccedil;&atilde;o do contrato de compra e venda entre Consumidores e Fornecedores.</p>

<p><strong>Cookies:</strong>&nbsp;Arquivos enviados pelo servidor do site para o computador do USU&Aacute;RIO, com a finalidade de identificar o computador e obter dados de acesso, como p&aacute;ginas navegadas ou links clicados, permitindo, desta forma, personalizar a utiliza&ccedil;&atilde;o do site, de acordo com o seu perfil. Tamb&eacute;m podem ser utilizados para garantir uma maior seguran&ccedil;a dos USU&Aacute;RIOS da PLATAFORMA.</p>

<p><strong>Com&eacute;rcio Eletr&ocirc;nico:</strong>&nbsp;Abrange o envio, a transmiss&atilde;o, a recep&ccedil;&atilde;o, o armazenamento de mensagens de dados pela via eletr&ocirc;nica.</p>

<p><strong>Consumidores (usu&aacute;rios):&nbsp;</strong>&nbsp;s&atilde;o as pessoas f&iacute;sicas cadastradas no Aplicativo denominado&nbsp;<strong>COMPREAQUI DELIVERY&nbsp;</strong>que acessem este para solicitar contrato de compra ou qualquer outro tipo de contrato l&iacute;cito, com o fim de adquirir bens ou servi&ccedil;os.</p>

<p><strong>Dados pessoais:</strong>&nbsp;&Eacute; toda informa&ccedil;&atilde;o que permite identificar ou fazer identific&aacute;vel uma pessoa f&iacute;sica.</p>

<p><strong>Intera&ccedil;&atilde;o na Plataforma:</strong>&nbsp;Faculdade de acesso dos Consumidores para conhecer os produtos e servi&ccedil;os exibidos pelos parceiros da OPERADORA, a publicidade colocada &agrave; disposi&ccedil;&atilde;o na Plataforma e manifestar sua vontade de solicitar a compra.</p>

<p><strong>Maior de idade:</strong>&nbsp;Pessoa f&iacute;sica maior de dezoito (18) anos.</p>

<p><strong>Mensagens de dados:</strong>&nbsp;A informa&ccedil;&atilde;o gerada, enviada, recebida, armazenada ou comunicada por meios eletr&ocirc;nicos, &oacute;pticos ou similares, como poderiam ser, entre outros, o Interc&acirc;mbio Eletr&ocirc;nico de Dados (EDI), Internet, o correio eletr&ocirc;nico, o telegrama, o telex e o telefax.</p>

<p><strong>Lojistas/Fornecedores:</strong> Parceiro do COMPREAQUI DELIVERY que exp&otilde;e seus produtos ou servi&ccedil;os no Aplicativo para comercializa&ccedil;&atilde;o, mediante cadastrado previamente autorizado pela Operadora do Aplicativo atrav&eacute;s do Termo de Ades&atilde;o aos Termos e Condi&ccedil;&otilde;es Gerais &ndash; MARKETPLACE COMPREAQUI DELIVERY.</p>

<p><strong>Operadora da plataforma:</strong>&nbsp;Encarregada de administrar operativamente e funcionalmente a Plataforma, representado para os efeitos destes termos pela COMPREAQUI DELIVERY, ou pela pessoa f&iacute;sica ou jur&iacute;dica que ela designar.</p>

<p><strong>Meios de pagamentos:</strong>&nbsp;Servi&ccedil;o que permite a realiza&ccedil;&atilde;o de pagamentos pelos Consumidores diretamente a Operadora da Plataforma, atrav&eacute;s de meios eletr&ocirc;nicos, utilizando API externa de pagamento usando protocolo <em>https</em> com sistema antifraude.</p>

<p><strong>PLATAFORMA COMPREAQUI DELIVERY:</strong>&nbsp;Aplicativo m&oacute;vel administrado e com os direitos exclusivos de utiliza&ccedil;&atilde;o pela COMPREAQUI DELIVERY, atrav&eacute;s do qual: i) s&atilde;o exibidos diferentes produtos de consumo de forma publicit&aacute;ria, ii) facilita a aproxima&ccedil;&atilde;o entre os Consumidores e os Fornecedores que tenham loja virtual dentro Aplicativo, iii) serve como meio de envio de comunica&ccedil;&otilde;es entre o Consumidor e a COMPREAQUI DELIVERY e iv) recebe os pagamentos das compras diretamente do consumidor, com repasse do dinheiro aos Lojistas/Fornecedores. O COMPREAQUI DELIVERY n&atilde;o realiza a compra de produtos por conta pr&oacute;pria, n&atilde;o armazena produtos e tampouco &eacute; vendedor de produtos, sendo uma plataforma de tecnologia somente para intermedia&ccedil;&atilde;o, que permite a intera&ccedil;&atilde;o entre Consumidores e Lojistas/Fornecedores. Tamb&eacute;m denominado neste Instrumento como&nbsp;<strong>&ldquo;PLATAFORMA&rdquo;,&nbsp;</strong>podendo ser acessada por&nbsp;<em>smartphones.</em></p>

<p><strong>Publicidade:</strong>&nbsp;&Eacute; toda forma de comunica&ccedil;&atilde;o realizada pela OPERADORA, com a finalidade de prestar informa&ccedil;&otilde;es sobre produtos, atividades comerciais e comunicar estrat&eacute;gias ou campanhas publicit&aacute;rias ou de marketing, pr&oacute;prias ou de terceiros; realizada como mecanismo de refer&ecirc;ncia e n&atilde;o como oferta p&uacute;blica.</p>

<p><strong>Produto:</strong>&nbsp;Bem de consumo exibido atrav&eacute;s da Plataforma.</p>

<p><strong>Servi&ccedil;o:</strong>&nbsp;Servi&ccedil;os oferecidos atrav&eacute;s da plataforma.</p>

<ol>
	<li><strong>OBJETO</strong></li>
</ol>

<p>Este instrumento tem por objeto estabelecer as regras e condi&ccedil;&otilde;es para a presta&ccedil;&atilde;o dos Servi&ccedil;os e, consequente, utiliza&ccedil;&atilde;o da Plataforma e compra de produtos e servi&ccedil;os pelo Usu&aacute;rio junto aos Fornecedores, conforme defini&ccedil;&atilde;o abaixo.</p>

<ol>
	<li><strong>SERVI&Ccedil;OS</strong></li>
</ol>

<p>Para fins destes Termos, &ldquo;Servi&ccedil;os&rdquo; significar&atilde;o a presta&ccedil;&atilde;o de servi&ccedil;os pelo COMPREAQUI DELIVERY que possibilitar&aacute; a voc&ecirc;, Usu&aacute;rio, a escolha de fornecedores de mercadorias destinadas &agrave;s atividades de supermercados e/ou outros estabelecimentos similares (&ldquo;<u>Fornecedores</u>&rdquo;) para que fa&ccedil;a pedidos online de delivery de alimentos, embalagens e outros insumos (&ldquo;<u>Produtos</u>&rdquo;) de acordo com o cat&aacute;logo de Produtos disponibilizado pelos Fornecedores (&ldquo;<u>Pedidos</u>&rdquo;).</p>

<p>O delivery &eacute; disponibilizado aos Usu&aacute;rios nas seguintes modalidades: o pr&oacute;prio estabelecimento comercial (Fornecedor) pode fazer a entrega, mediante valor m&iacute;nimo da compra a ser estipulada pelo fornecedor, ou o Usu&aacute;rio pode optar pela entrega expressa, mediante pr&eacute;vio pagamento. Ou, ainda, o consumidor pode optar por retirar seu pedido no pr&oacute;prio estabelecimento comercial do fornecedor.</p>

<p>Usu&aacute;rio reconhece e concorda que os Pedidos dever&atilde;o conter apenas os Produtos para sua utiliza&ccedil;&atilde;o pr&oacute;pria, n&atilde;o sendo permitida a aquisi&ccedil;&atilde;o dos Produtos para revenda. Os Pedidos que forem feitos para fins de revenda ser&atilde;o cancelados, sem que isso gere qualquer tipo de responsabilidade ou &ocirc;nus ao COMPREAQUI DELIVERY.</p>

<p>Os Servi&ccedil;os oferecidos pelo COMPREAQUI DELIVERY se relacionam apenas &agrave;&nbsp;<strong>intermedia&ccedil;&atilde;o</strong>&nbsp;da comercializa&ccedil;&atilde;o de produtos ou servi&ccedil;os pelos Fornecedores, n&atilde;o abarcando confec&ccedil;&atilde;o, embalagem, disponibiliza&ccedil;&atilde;o e entrega f&iacute;sica dos produtos, sendo os primeiros itens de responsabilidade integral do Fornecedor e o &uacute;ltimo de responsabilidade do Fornecedor e/ou da empresa especializada na presta&ccedil;&atilde;o de servi&ccedil;os de entrega (&ldquo;Aplicativo de Mobilidade Urbana&rdquo;), conforme o caso, a quem dever&atilde;o ser direcionadas quaisquer reclama&ccedil;&otilde;es sobre problemas decorrentes dessas atividades.</p>

<p>Ao aceitar estes Termos de Uso, o Consumidor reconhece e concorda que todo o conte&uacute;do apresentado na PLATAFORMA est&aacute; protegido por direitos autorais, marcas, patentes ou outros direitos e leis de propriedade industrial e &eacute; propriedade exclusiva da Operadora.&nbsp;</p>

<p>O uso dos Servi&ccedil;os n&atilde;o lhe confere a propriedade ou direito de uso sobre quaisquer de nossos direitos de propriedade intelectual sobre a Plataforma, Servi&ccedil;os ou sobre nosso conte&uacute;do, incluindo, sem limita&ccedil;&atilde;o, cabe&ccedil;alhos de p&aacute;gina, elementos gr&aacute;ficos personalizados, &iacute;cones de bot&otilde;es, sinais distintivos e scripts dispon&iacute;veis na Plataforma. Voc&ecirc; n&atilde;o poder&aacute; usar, copiar, imitar, total ou parcialmente, qualquer conte&uacute;do da Plataforma e dos Servi&ccedil;os a menos que obtenha nossa permiss&atilde;o ou a permiss&atilde;o do propriet&aacute;rio de referido conte&uacute;do ou que o fa&ccedil;a por algum meio permitido de acordo com a legisla&ccedil;&atilde;o aplic&aacute;vel.</p>

<p>O uso n&atilde;o autorizado dos materiais que aparecem na PLATAFORMA pode violar direitos autorais, marcas registradas e outras leis aplic&aacute;veis ​​e pode resultar em penalidades criminais ou civis. O Consumidor n&atilde;o dever&aacute; enviar &agrave; Operadora informa&ccedil;&otilde;es confidenciais, a menos que as Partes tenham concordado mutuamente por escrito. Eventuais ideias ou propostas&nbsp;<strong>n&atilde;o</strong>&nbsp;solicitadas enviadas pelo Consumidor &agrave; Operadora n&atilde;o reserva nenhum direito ao Consumidor.&nbsp;</p>

<p>Poder&aacute; ser exibido, na Plataforma ou em nossos Servi&ccedil;os, alguns conte&uacute;dos que n&atilde;o sejam de nossa titularidade, os quais poder&atilde;o ser revistos por n&oacute;s para determinar sua legalidade e adequa&ccedil;&atilde;o &agrave;s nossas pol&iacute;ticas.</p>

<p>O COMPREAQUI DELIVERY poder&aacute;, a seu exclusivo crit&eacute;rio, remover ou se recusar a exibir conte&uacute;do na Plataforma que acredite estar violando as nossas pol&iacute;ticas ou legisla&ccedil;&atilde;o aplic&aacute;vel, sem a necessidade de notifica&ccedil;&atilde;o ou aviso pr&eacute;vio aos Usu&aacute;rios.</p>

<p>A Operadora administra a Plataforma diretamente ou por meio de terceiras pessoas, todas as informa&ccedil;&otilde;es ali comunicadas est&atilde;o certas e atualizadas. Em nenhum caso responder&aacute; por danos diretos ou indiretos sofridos pelo Consumidor pela utiliza&ccedil;&atilde;o ou incapacidade de utiliza&ccedil;&atilde;o da Plataforma.</p>

<ol>
	<li><strong>CADASTRO E CONTA</strong></li>
</ol>

<p>Ao utilizar a Plataforma e solicitar a presta&ccedil;&atilde;o dos Servi&ccedil;os, voc&ecirc; declara, de acordo com a legisla&ccedil;&atilde;o aplic&aacute;vel, ter capacidade jur&iacute;dica para praticar atos civis e se compromete a prestar as informa&ccedil;&otilde;es exigidas na Plataforma com exatid&atilde;o e veracidade, assumindo integral responsabilidade por referidas informa&ccedil;&otilde;es fornecidas em seu cadastro (&ldquo;<u>Cadastro</u>&rdquo;). As informa&ccedil;&otilde;es disponibilizadas em seu Cadastro ser&atilde;o utilizadas para a cria&ccedil;&atilde;o de sua conta de Usu&aacute;rio a qual, por meio de&nbsp;<em>login</em>&nbsp;e senha de acesso individuais, lhe garantir&aacute; acesso &agrave; Plataforma (&ldquo;<u>Conta</u>&rdquo;).</p>

<p>&nbsp;Cada Usu&aacute;rio poder&aacute; criar apenas 1 (uma) Conta, se o COMPREAQUI DELIVERY desativar sua Conta, independentemente do motivo ou raz&atilde;o, voc&ecirc; compromete-se a n&atilde;o criar outra Conta sem a nossa permiss&atilde;o, sendo certo que caso o COMPREAQUI DELIVERY constate a exist&ecirc;ncia de 2 (duas) Contas poder&aacute; suspend&ecirc;-las ou exclui-las sem a necessidade de envio de notifica&ccedil;&atilde;o ou aviso pr&eacute;vio ao Usu&aacute;rio e sem que isso implique em qualquer &ocirc;nus ao COMPREAQUI DELIVERY.</p>

<p>Para proteger sua Conta, o Usu&aacute;rio dever&aacute; manter o seu&nbsp;<em>login</em>&nbsp;e senha em sigilo, uma vez que toda e qualquer atividade realizada em sua Conta ou por seu interm&eacute;dio &eacute; de responsabilidade do Usu&aacute;rio. O Usu&aacute;rio n&atilde;o poder&aacute; criar Contas por meio n&atilde;o autorizados, incluindo, mas sem limita&ccedil;&atilde;o, por meio da utiliza&ccedil;&atilde;o de dispositivos autom&aacute;ticos, script, bot, spider, rastreador ou scraper.</p>

<p>Caso o COMPREAQUI DELIVERY constate que qualquer informa&ccedil;&atilde;o fornecida em seu Cadastro &eacute; incorreta, inver&iacute;dica e/ou duvidosa, bem como na hip&oacute;tese de negativa em corrigi-las, o COMPREAQUI DELIVERY poder&aacute; n&atilde;o concluir seu cadastramento como Usu&aacute;rio ou, ainda, bloquear sua Conta e/ou seu Cadastro j&aacute; existentes.</p>

<p>O COMPREAQUI DELIVERY poder&aacute; ainda impedir, a seu exclusivo crit&eacute;rio, a realiza&ccedil;&atilde;o de novos Cadastros ou cancelar qualquer Conta existente, caso&nbsp;<em>(i)</em>&nbsp;detecte qualquer anomalia grave no Cadastro e/ou na Conta;&nbsp;<em>(ii)</em>&nbsp;verifique qualquer a&ccedil;&atilde;o e/ou omiss&atilde;o cuja inten&ccedil;&atilde;o seja burlar o disposto nestes Termos; ou&nbsp;<em>(iii)</em>&nbsp;verifique o descumprimento de qualquer obriga&ccedil;&atilde;o ou disposi&ccedil;&atilde;o destes Termos.</p>

<ol>
	<li><strong>OFERTAS</strong></li>
</ol>

<p>Al&eacute;m da disponibiliza&ccedil;&atilde;o dos Produtos na Plataforma, o COMPREAQUI DELIVERY poder&aacute; disponibilizar ofertas com condi&ccedil;&otilde;es comerciais mais favor&aacute;veis do que as normalmente praticadas para os Produtos. O COMPREAQUI DELIVERY poder&aacute; retirar uma oferta do ar a seu exclusivo crit&eacute;rio, por diversos motivos, incluindo, mas sem limita&ccedil;&atilde;o, solicita&ccedil;&atilde;o do Fornecedor neste sentido ou quando o estoque dos Produtos objeto da Oferta (&ldquo;<u>Estoque</u>&rdquo;) for encerrado.</p>

<p>O Usu&aacute;rio, ao utilizar a Plataforma, reconhece e concorda que as ofertas estar&atilde;o sujeitas &agrave; quantidade dos Produtos dispon&iacute;veis em estoque do Fornecedor, sendo certo que, em caso de t&eacute;rmino do Estoque, os Pedidos de Produtos objetos da Oferta ser&atilde;o cancelados pelo COMPREAQUI DELIVERY.&nbsp;</p>

<ol>
	<li><strong>FORMA DE PAGAMENTO DOS PEDIDOS</strong></li>
</ol>

<p>O Usu&aacute;rio poder&aacute; realizar o pagamento dos seus Pedidos no COMPREAQUI DELIVERY atrav&eacute;s de cart&atilde;o de cr&eacute;dito ou d&eacute;bito, atrav&eacute;s de meios eletr&ocirc;nicos, utilizando API externa de pagamento usando protocolo <em>https</em> com sistema antifraude.</p>

<p>Qualquer tentativa de pagamento com cart&atilde;o de cr&eacute;dito estar&aacute; sujeita &agrave; avalia&ccedil;&atilde;o e aprova&ccedil;&atilde;o da administradora e/ou bandeira do cart&atilde;o de cr&eacute;dito.</p>

<ol>
	<li><strong>ENTREGA DOS PEDIDOS</strong></li>
</ol>

<p>O COMPREAQUI DELIVERY n&atilde;o presta qualquer servi&ccedil;o de transporte de qualquer tipo de carga, sendo o COMPREAQUI DELIVERY respons&aacute;vel apenas e t&atilde;o somente pela&nbsp;<strong>intermedia&ccedil;&atilde;o</strong>&nbsp;entre o Usu&aacute;rio e os Fornecedores ou entre o Usu&aacute;rio, os Fornecedores e os Aplicativos de Mobilidade Urbana, conforme o caso.</p>

<p>O Usu&aacute;rio reconhece que o tempo de transporte dos Pedidos variar&aacute; de acordo com diversos fatores, incluindo, mas sem limita&ccedil;&atilde;o, se &eacute; um produto personalizado ou n&atilde;o, os itens que o comp&otilde;em, estoque, tempo de produ&ccedil;&atilde;o, processo de emiss&atilde;o de nota fiscal, forma de pagamento e a regi&atilde;o do destinat&aacute;rio.</p>

<p>O prazo para entrega dos Pedidos ser&aacute; informado durante o processo de compra e ser&aacute; contabilizado em dias &uacute;teis. O Usu&aacute;rio dever&aacute; manter-se dispon&iacute;vel para receber os Pedidos em hor&aacute;rio comercial, conforme hor&aacute;rio de funcionamento do Estabelecimento Comercial Parceiro, de&nbsp;<strong>segunda-feira a s&aacute;bado, das 06h &agrave;s 22h</strong>, e aos domingos conforme o caso.</p>

<p>Na hip&oacute;tese de a entrega n&atilde;o ser efetivada na data prevista, e caso n&atilde;o seja poss&iacute;vel realizar a entrega em poss&iacute;veis tentativas posteriores, o Fornecedor e/ou a Transportadora, conforme o caso dever&aacute; retornar o Pedido ao Fornecedor e seu respectivo centro de distribui&ccedil;&atilde;o. Nestes casos, o Usu&aacute;rio ser&aacute; respons&aacute;vel por eventuais cobran&ccedil;as referentes a tentativas posteriores de entrega do Pedido.</p>

<p>O valor do frete ser&aacute; calculado com base no local de entrega, peso e dimens&otilde;es dos Produtos. O COMPREAQUI DELIVERY compromete-se a orientar os Fornecedores e as Transportadoras, quando aplic&aacute;vel, a&nbsp;<em>(i)</em>&nbsp;realizar as entregas dos Pedidos de&nbsp;<strong>segunda-feira a s&aacute;bado, das 06h &agrave;s 22h</strong>, e aos domingos conforme o caso, preferencialmente no hor&aacute;rio de entrega desejado/informado pelo Usu&aacute;rio (mas tamb&eacute;m n&atilde;o &eacute; obrigat&oacute;rio);&nbsp;<em>(ii)</em>&nbsp;n&atilde;o ingressar no estabelecimento dos Usu&aacute;rios;&nbsp;<em>(iii)</em>&nbsp;n&atilde;o abrir os Produtos; e&nbsp;<em>(iv)</em>&nbsp;n&atilde;o realizar a entrega em endere&ccedil;o distinto do que foi informado pelo Usu&aacute;rio.</p>

<p>O Usu&aacute;rio reconhece e concorda que o Fornecedor poder&aacute; recusar Pedidos caso o endere&ccedil;o de entrega informado pelo Usu&aacute;rio seja diferente do endere&ccedil;o constante no Cadastro Nacional da Pessoa Jur&iacute;dica.</p>

<p>O COMPREAQUI DELIVERY n&atilde;o poder&aacute; ser considerado respons&aacute;vel pela reten&ccedil;&atilde;o dos Produtos na SEFAZ quando esta se dever exclusivamente a pend&ecirc;ncias relacionadas ao Usu&aacute;rio, casos em que o Usu&aacute;rio dever&aacute; comparecer ao posto fiscal para que a mercadoria seja liberada, tendo em vista que nestes casos as informa&ccedil;&otilde;es referentes a libera&ccedil;&otilde;es e pagamentos s&oacute; s&atilde;o passadas aos interessados.</p>

<p>Os produtos de uso restrito como tabaco e bebidas alcoolicas somente ser&atilde;o entregues pelo Transportador aos Consumidores que forem maiores de idade, que manifestarem expressamente esta qualidade no momento de se registrarem ou no momento da sele&ccedil;&atilde;o dos produtos.</p>

<ol>
	<li><strong>RECUSA DE PEDIDOS PELO USU&Aacute;RIO</strong></li>
</ol>

<p>Os Pedidos dever&atilde;o ser enviados ao Usu&aacute;rio em &oacute;timo estado de conserva&ccedil;&atilde;o e de acordo com as especifica&ccedil;&otilde;es e caracter&iacute;sticas descritas na Plataforma.</p>

<p>O Usu&aacute;rio dever&aacute; recusar o pedido no ato de recebimento e escrever o motivo da recusa no verso do documento fiscal, caso o Usu&aacute;rio constate que&nbsp;<em>(i)</em>&nbsp;a embalagem de armazenamento dos Produtos est&aacute; aberta, rompida, avariada ou apresenta qualquer tipo de defeito que interfira na integridade dos Produtos, impedindo o seu consumo pelo Usu&aacute;rio;&nbsp;<em>(ii)</em>&nbsp;o Produto est&aacute; avariado; e&nbsp;<em>(iii)</em>&nbsp;o Produto est&aacute; em desacordo com as especificidades e caracter&iacute;sticas do Pedido.</p>

<p>O Fornecedor&nbsp;ser&aacute; respons&aacute;vel pela corre&ccedil;&atilde;o de quaisquer execu&ccedil;&otilde;es dos Pedidos feitas de forma inadequada ou incompleta, garantindo a qualidade dos Produtos e o atendimento e satisfa&ccedil;&atilde;o dos Usu&aacute;rios.</p>

<ol>
	<li><strong>DEVOLU&Ccedil;&Atilde;O E TROCA DE PRODUTOS COM DEFEITOS</strong></li>
</ol>

<p>O Usu&aacute;rio ter&aacute; o prazo de at&eacute; 7 (sete) dias corridos contados a partir da data de recebimento do Pedido para solicitar a troca ou devolu&ccedil;&atilde;o de Produtos em que for constatado v&iacute;cio e/ou defeito, devendo o Usu&aacute;rio comunicar o COMPREAQUI DELIVERY sobre a constata&ccedil;&atilde;o do v&iacute;cio e/ou defeito, sendo certo que dever&aacute; seguir as instru&ccedil;&otilde;es dadas pelo COMPREAQUI DELIVERY para que o pedido de troca ou de devolu&ccedil;&atilde;o seja analisado e processado.</p>

<p>Nessas hip&oacute;teses, o COMPREAQUI DELIVERY far&aacute; a&nbsp;<strong>intermedia&ccedil;&atilde;o</strong>&nbsp;para que o Fornecedor, &uacute;nico e exclusivo respons&aacute;vel pelos Produtos, troque os Produtos defeituosos por outros id&ecirc;nticos, a serem enviados sem a cobran&ccedil;a de nova taxa de entrega ao Usu&aacute;rio. Caso n&atilde;o seja poss&iacute;vel realizar a troca dos Produtos por qualquer motivo, incluindo, mas sem limita&ccedil;&atilde;o, por indisponibilidade do Produto, o Usu&aacute;rio poder&aacute; optar por&nbsp;<em>(i)</em>&nbsp;voucher no valor total do Pedido, incluindo o valor da taxa de entrega, caso tenha sido cobrado, para utiliza&ccedil;&atilde;o em uma pr&oacute;xima compra na Plataforma; ou&nbsp;<em>(ii)</em>&nbsp;restitui&ccedil;&atilde;o do valor do Produto, incluindo o valor pago pelo frete.</p>

<p>Nas hip&oacute;teses de troca dos Produtos em decorr&ecirc;ncia da constata&ccedil;&atilde;o de v&iacute;cio e/ou defeito nos Produtos, o Usu&aacute;rio n&atilde;o arcar&aacute; com os custos da taxa de entrega da retirada dos Produtos e da eventual nova taxa de entrega para que lhe sejam disponibilizados os Produtos sem defeitos.</p>

<ol>
	<li><strong>CANCELAMENTO DA COMPRA</strong></li>
</ol>

<p>Caso o Usu&aacute;rio se arrependa de um Pedido por ele efetuado, independente do motivo ou da raz&atilde;o para tanto, poder&aacute; exercer o seu direito de arrependimento no prazo de at&eacute; 7 (sete) dias corridos contados a partir da data de recebimento do Pedido para solicitar a retirada dos Produtos, devendo o Usu&aacute;rio comunicar o COMPREAQUI DELIVERY sobre o seu arrependimento da compra, sendo certo que dever&aacute; seguir as instru&ccedil;&otilde;es dadas pelo COMPREAQUI DELIVERY para que o seu pedido seja analisado e processado.</p>

<p>O pedido de devolu&ccedil;&atilde;o dos Produtos passar&aacute; por uma avalia&ccedil;&atilde;o para que seja verificado se houve utiliza&ccedil;&atilde;o, parcial ou total dos Produtos, ou se os Produtos apresentam avarias ou danos significativos que impe&ccedil;am o seu uso, sendo certo que caso seja constatada a utiliza&ccedil;&atilde;o e/ou avarias nos Produtos, a devolu&ccedil;&atilde;o n&atilde;o ser&aacute; poss&iacute;vel.</p>

<p>Caso o Pedido seja cancelado pelo Usu&aacute;rio ap&oacute;s o seu faturamento pelo COMPREAQUI DELIVERY, caber&aacute; ao Usu&aacute;rio arcar com eventuais custos, taxas e despesas decorrentes da entrega.</p>

<p>Nas hip&oacute;teses de devolu&ccedil;&atilde;o dos Produtos, o COMPREAQUI DELIVERY far&aacute; a intermedia&ccedil;&atilde;o para que o Fornecedor, &uacute;nico e exclusivo respons&aacute;vel pelos Produtos, efetue a devolu&ccedil;&atilde;o dos valores ao Usu&aacute;rio, o que dever&aacute; ocorrer no prazo de at&eacute; 25 (vinte e cinco) dias &uacute;teis contados a partir da solicita&ccedil;&atilde;o do Usu&aacute;rio nesse sentido. Ademais, o Usu&aacute;rio reconhece e concorda que arcar&aacute; com os custos da taxa de entrega original dos Produtos e os custos da taxa de retirada dos Produtos para que sejam devolvidos ao Fornecedor.</p>

<ol>
	<li><strong>PROCEDIMENTOS PARA A TROCA E DEVOLU&Ccedil;&Atilde;O DE PRODUTOS COM DEFEITO E CANCELAMENTO DA COMPRA</strong></li>
</ol>

<p>O Usu&aacute;rio dever&aacute; comunicar ao COMPREAQUI DELIVERY toda e qualquer inten&ccedil;&atilde;o de realizar a troca ou a devolu&ccedil;&atilde;o de Produtos com defeitos ou sobre seu arrependimento quanto a qualquer compra por ele realizada, antes de tomar qualquer outra medida, como, por exemplo, contatar o Fornecedor ou tentar devolver o Produto ao Fornecedor.</p>

<p>Para que possa realizar a troca ou devolu&ccedil;&atilde;o de qualquer Produto, o Usu&aacute;rio dever&aacute; entrar em contato com o COMPREAQUI DELIVERY, via chat ou whatsapp, conforme Cl&aacute;usula 16, abaixo,&nbsp; fazer a solicita&ccedil;&atilde;o para a equipe de atendimento e&nbsp; enviar o&nbsp;&nbsp;<strong>Formul&aacute;rio de Troca, Devolu&ccedil;&atilde;o e Cancelamento</strong>&nbsp;dispon&iacute;vel, devidamente preenchido para o e-mail&nbsp;<a href="mailto:atendimentocompreaquidelivery@gmail.com"><strong>atendimentocompreaquidelivery@gmail.com</strong></a>.</p>

<p>A troca e a devolu&ccedil;&atilde;o de Produtos com defeito ou o cancelamento da compra por arrependimento somente ser&atilde;o poss&iacute;veis se os Produtos:&nbsp;<em>(i)</em>&nbsp;n&atilde;o apresentarem ind&iacute;cios de uso, avaria ou consumo, estando acondicionados na embalagem original em que foram enviados;&nbsp;<em>(ii)</em>&nbsp;n&atilde;o forem perec&iacute;vei;&nbsp;<em>(iii)</em>&nbsp;n&atilde;o forem personalizados/customizados;&nbsp;<em>(iv)</em>&nbsp;estiverem acompanhados da 1&ordf; via do documento fiscal que os acompanhava na entrega; e&nbsp;<em>(v)</em>&nbsp;apresentarem, caso demandado, Nota Fiscal de Devolu&ccedil;&atilde;o de Mercadoria.</p>

<p>Caso as condi&ccedil;&otilde;es acima sejam satisfeitas, o COMPREAQUI DELIVERY realizar&aacute; a&nbsp;<strong>intermedia&ccedil;&atilde;o</strong>&nbsp;entre o Fornecedor e o Usu&aacute;rio para que o primeiro retire os Produtos junto ao segundo e tome todas as medidas necess&aacute;rias para realizar a troca ou devolu&ccedil;&atilde;o dos Produtos, conforme o caso.</p>

<ol>
	<li><strong>FRAUDES EM COMPRAS</strong></li>
</ol>

<p>Na hip&oacute;tese de o COMPREAQUI DELIVERY suspeitar e/ou constatar a ocorr&ecirc;ncia de fraude perpetuada pelo Usu&aacute;rio em seus Pedidos, o COMPREAQUI DELIVERY poder&aacute; cancelar os referidos Pedidos, em at&eacute; 1 (um) dia &uacute;til, sendo certo que nessa hip&oacute;tese os valores aos Pedidos fraudulentos ou sobre os que haja suspeita de fraude ser&atilde;o estornados ao Usu&aacute;rio e que o cancelamento n&atilde;o ensejar&aacute; quaisquer &ocirc;nus ou penalidades ao COMPREAQUI DELIVERY.</p>

<ol>
	<li><strong>OBRIGA&Ccedil;&Otilde;ES E DECLARA&Ccedil;&Otilde;ES DO USU&Aacute;RIO</strong></li>
</ol>

<p>Por meio de sua aceita&ccedil;&atilde;o aos presentes Termos e da utiliza&ccedil;&atilde;o da Plataforma, o Usu&aacute;rio:</p>

<p>(a) obriga-se a n&atilde;o divulgar a terceiros seu&nbsp;<em>login</em>&nbsp;e senha de acesso &agrave; sua Conta, bem como a n&atilde;o permitir o uso de sua Conta por terceiros, sendo o Usu&aacute;rio o &uacute;nico respons&aacute;vel por quaisquer solicita&ccedil;&otilde;es de presta&ccedil;&atilde;o de Servi&ccedil;os que sejam feitas por meio de sua Conta;</p>

<p>(b) obriga-se a fornecer informa&ccedil;&otilde;es ver&iacute;dicas e exatas em seu Cadastro, sendo o &uacute;nico e exclusivo respons&aacute;vel pelo conte&uacute;do informado, comprometendo-se, ainda, a manter seu Cadastro atualizado a todo tempo, principalmente em rela&ccedil;&atilde;o ao endere&ccedil;o de entrega;</p>

<p>(c) n&atilde;o utilizar a Plataforma para realizar atos contr&aacute;rios &agrave; moral, a lei, a ordem p&uacute;blica e os bons costumes contra o Operador, Fornecedor ou de terceiros;</p>

<p>(d) obriga-se a n&atilde;o:&nbsp;<em>I-</em>&nbsp;interferir nos Servi&ccedil;os;&nbsp;<em>II-</em>&nbsp;tentar solicitar os Servi&ccedil;os por outro meio que n&atilde;o a Plataforma e/ou em desconformidade com o disposto nestes termos;&nbsp;<em>III-</em>&nbsp;interferir e/ou interromper os Servi&ccedil;os e/ou servidores e/ou redes conectadas aos Servi&ccedil;os, incluindo, mas sem limita&ccedil;&atilde;o, por meio de transmiss&atilde;o de worms, v&iacute;rus, spyware, malware ou qualquer outro c&oacute;digo de natureza destrutiva ou disruptiva; e&nbsp;<em>IV-</em>&nbsp;n&atilde;o inserir conte&uacute;do e/ou c&oacute;digo ou, ent&atilde;o, alterar ou interferir na forma como qualquer p&aacute;gina &eacute; disponibilizada na Plataforma;</p>

<p>(e) obriga-se a n&atilde;o copiar, modificar, distribuir, fazer engenharia reversa, tentar extrair o c&oacute;digo fonte, vender e/ou alugar qualquer parte da Plataforma, Servi&ccedil;os ou quaisquer outros softwares, documentos e/ou informa&ccedil;&otilde;es neles disponibilizados, nem poder&aacute; fazer engenharia reversa ou tentar extrair o c&oacute;digo fonte da Plataforma e/ou dos softwares;</p>

<p>(f) expressamente reconhece e concorda que o COMPREAQUI DELIVERY, a seu exclusivo crit&eacute;rio, poder&aacute; fornecer a terceiros interessados, a t&iacute;tulo gratuito ou oneroso, dados e informa&ccedil;&otilde;es gerais obtidos a partir do seu banco de dados, incluindo, sem limita&ccedil;&atilde;o, informa&ccedil;&otilde;es a respeito de padr&otilde;es de comportamento, h&aacute;bitos de consumo e outras estat&iacute;sticas relacionadas &agrave; Plataforma. Referidos dados e informa&ccedil;&otilde;es em nenhuma hip&oacute;tese indicar&atilde;o dados e informa&ccedil;&otilde;es que possam ser utilizadas para identificar ou individualizar os Usu&aacute;rios; e</p>

<p>(g) declara que os dados por ele indicados no momento de seu cadastro s&atilde;o v&aacute;lidos e verdadeiros e autoriza expressamente que as entregas dos Pedidos por ele realizados na Plataforma possam vir a ser realizadas em endere&ccedil;os distintos do que consta no seu cadastro nacional de pessoas jur&iacute;dicas perante a Receita Federal.</p>

<p>(h) em geral adotar todas aquelas condutas necess&aacute;rias para a execu&ccedil;&atilde;o do neg&oacute;cio jur&iacute;dico, tais como: I) a recep&ccedil;&atilde;o dos produtos solicitados, II) exibir a identifica&ccedil;&atilde;o em caso de compra de produtos de uso restrito ou de outros produtos, III) verificar no momento da valida&ccedil;&atilde;o que os produtos selecionados correspondem aos requeridos, IV)&nbsp; informar-se sobre as instru&ccedil;&otilde;es de uso e consumo dos produtos.</p>

<ol>
	<li><strong>OBRIGA&Ccedil;&Otilde;ES DO </strong><strong>COMPREAQUI DELIVERY</strong></li>
</ol>

<p>O COMPREAQUI DELIVERY compromete-se a prestar os Servi&ccedil;os e a disponibilizar a Plataforma para que, ap&oacute;s a efetiva cria&ccedil;&atilde;o de sua Conta, o Usu&aacute;rio possa fazer Pedidos e a disponibilizar os meios de pagamento online para pagamento dos Pedidos. O COMPREAQUI DELIVERY trabalhar&aacute; ao m&aacute;ximo para que os Servi&ccedil;os e a Plataforma estejam dispon&iacute;veis o maior tempo poss&iacute;vel, entretanto, poder&atilde;o ocorrer situa&ccedil;&otilde;es em que o Servi&ccedil;os e a Plataforma ficar&atilde;o momentaneamente indispon&iacute;veis pelos mais diversos motivos, incluindo, sem limita&ccedil;&atilde;o, manuten&ccedil;&otilde;es agendadas ou de emerg&ecirc;ncia, atualiza&ccedil;&otilde;es, reparos emergenciais, falhas na infraestrutura, servidores, equipamentos ou links de telecomunica&ccedil;&atilde;o.</p>

<p>O COMPREAQUI DELIVERY assume, por meio destes Termos, a obriga&ccedil;&atilde;o de proteger, por meio de armazenamento em servidores ou quaisquer outros meios magn&eacute;ticos de alta seguran&ccedil;a, a confidencialidade de todas as informa&ccedil;&otilde;es e cadastros relativos as informa&ccedil;&otilde;es do Usu&aacute;rio, assim como valores atinentes &agrave;s opera&ccedil;&otilde;es financeiras decorrentes da presta&ccedil;&atilde;o dos Servi&ccedil;os e dos Pedidos.</p>

<p>O COMPREAQUI DELIVERY n&atilde;o responder&aacute; pela repara&ccedil;&atilde;o de preju&iacute;zos que possam ser derivados de apreens&atilde;o e coopta&ccedil;&atilde;o de dados por parte de terceiros que, rompendo os sistemas de seguran&ccedil;a, consigam acessar as informa&ccedil;&otilde;es na Plataforma.</p>

<ol>
	<li><strong>DAS CAMPANHAS PROMOCIONAIS</strong></li>
</ol>

<p>O COMPREAQUI DELIVERY poder&aacute; realizar campanhas promocionais que garantem ao Consumidores desconto no valor da compra, por meio de c&oacute;digos promocionais ou outros meios. O regulamento de tais campanhas &eacute; definido &uacute;nica e exclusivamente pelo COMPREAQUI DELIVERY, podendo ser alterado ou encerrado a qualquer momento.</p>

<p>Sobre essas campanhas, fica a crit&eacute;rio do COMPREAQUI DELIVERY definir, entre outras coisas: (1) Consumidores que est&atilde;o eleg&iacute;veis a participar, (2) ofertas que est&atilde;o eleg&iacute;veis a receber descontos adicionais, (3) regras espec&iacute;ficas para ativa&ccedil;&atilde;o de descontos, como valor m&iacute;nimo da compra e quantidade de cupons, (4) valor do desconto, (5) quantidade dispon&iacute;vel de c&oacute;digos promocionais.</p>

<ol>
	<li><strong>CANAL DE COMUNICA&Ccedil;&Atilde;O E D&Uacute;VIDAS</strong></li>
</ol>

<p>Se voc&ecirc; tiver algum questionamento, solicita&ccedil;&otilde;es, reclama&ccedil;&otilde;es ou d&uacute;vidas com rela&ccedil;&atilde;o aos Servi&ccedil;os, a estes Termos ou &agrave; Pol&iacute;tica de Privacidade do COMPREAQUI DELIVERY ou qualquer pr&aacute;tica descrita aqui, entre em contato conosco pelo chat dispon&iacute;vel no Aplicativo COMPREAQUI DELIVERY, nosso n&uacute;mero de Whatsapp (64) 99296-1918 (n&atilde;o recebe liga&ccedil;&otilde;es) ou por meio do e-mail&nbsp;<a href="mailto:atendimentocompreaquidelivery@gmail.com">atendimentocompreaquidelivery@gmail.com</a><u>.</u></p>

<p>O Usu&aacute;rio se compromete a manter o endere&ccedil;o eletr&ocirc;nico e telefone para contato indicados em seu Cadastro devidamente atualizados, j&aacute; que ambos ser&atilde;o os meios a serem utilizados para as comunica&ccedil;&otilde;es entre o Usu&aacute;rio e o COMPREAQUI DELIVERY.</p>

<ol>
	<li><strong>ALTERA&Ccedil;&Otilde;ES DOS TERMOS DE USO</strong></li>
</ol>

<p>Os presentes Termos poder&atilde;o ser alterados, no todo ou em parte, pelo COMPREAQUI DELIVERY a qualquer tempo, podendo ter seu conte&uacute;do modificado para adequa&ccedil;&otilde;es, inser&ccedil;&otilde;es e/ou exclus&otilde;es, visando aprimorar os Servi&ccedil;os. Em caso de mudan&ccedil;as relevantes, os Usu&aacute;rios ser&atilde;o avisados por meio da Plataforma e uma nova vers&atilde;o destes Termos ser&aacute; disponibilizada para sua avalia&ccedil;&atilde;o.</p>

<p>Caso tenha alguma obje&ccedil;&atilde;o &agrave; altera&ccedil;&atilde;o, voc&ecirc; dever&aacute; manifestar oposi&ccedil;&atilde;o por escrito, o que resultar&aacute; no cancelamento de sua Conta e na impossibilidade de solicitar nova presta&ccedil;&atilde;o de Servi&ccedil;os. A continuidade do uso da Plataforma ap&oacute;s a publica&ccedil;&atilde;o do aviso na Plataforma e da nova vers&atilde;o dos Termos e Condi&ccedil;&otilde;es implicar&aacute; no seu consentimento com as mudan&ccedil;as e aceita&ccedil;&atilde;o plena da nova vers&atilde;o dos Termos e Condi&ccedil;&otilde;es.</p>

<ol>
	<li><strong>LIMITA&Ccedil;&Atilde;O DE RESPONSABILIDADES:</strong></li>
</ol>

<p>Todos os materiais e servi&ccedil;os disponibilizados na PLATAFORMA s&atilde;o fornecidos &ldquo;como est&atilde;o&rdquo; e &ldquo;como dispon&iacute;vel&rdquo; sem garantia de qualquer tipo, expressa ou impl&iacute;cita, incluindo, mas n&atilde;o limitado a, garantias impl&iacute;citas de adequa&ccedil;&atilde;o a um prop&oacute;sito espec&iacute;fico ou as dadas diretamente pelos FORNECEDORES. A Operadora n&atilde;o pode garantir que:</p>

<p>(a) os servi&ccedil;os satisfa&ccedil;am completamente &agrave;s necessidades do Consumidor;</p>

<p>(b) os servi&ccedil;os sejam ininterruptos, oportunos, seguros ou isentos de erros. A Operadora realiza os melhores esfor&ccedil;os para manter a PLATAFORMA em opera&ccedil;&atilde;o, mas em nenhum caso garante a disponibilidade e continuidade permanente da PLATAFORMA;</p>

<p>(c) os resultados esperados pelos Consumidores que possam ser obtidos atender&atilde;o &agrave;s suas expectativas ou estar&aacute; livre de erros, ou defeitos.</p>

<p>O uso dos servi&ccedil;os ou do download por meio da PLATAFORMA &eacute; feito ao pr&oacute;prio crit&eacute;rio e risco do Consumidor e com o seu acordo de que ser&aacute; o &uacute;nico respons&aacute;vel por quaisquer danos ao seu sistema de computador ou perda de dados resultantes de tais atividades.&nbsp; O Consumidor tamb&eacute;m entende e concorda que a Operadora n&atilde;o tem controle sobre redes de terceiros que possam ser acessadas durante o uso da PLATAFORMA, portanto, atrasos e interrup&ccedil;&otilde;es de outras transmiss&otilde;es de rede est&atilde;o completamente fora do controle da Operadora. Tamb&eacute;m n&atilde;o se pode imputar a Operadora por quaisquer casos de atos fortuitos ou de for&ccedil;a maior, que venham a causar danos a quaisquer das Partes. Em nenhum caso, a Operadora ser&aacute; respons&aacute;vel perante o USU&Aacute;RIO ou terceiros por quaisquer danos, incluindo, sem limita&ccedil;&atilde;o, aqueles resultantes de perda de dados, servi&ccedil;os de terceiros oferecidos por meio da PLATAFORMA, ou no caso de quaisquer atos dos Transportadores.&nbsp;Em nenhum momento a Operadora solicitar&aacute; ao USU&Aacute;RIO informa&ccedil;&otilde;es que N&Atilde;O forem necess&aacute;rias para seu v&iacute;nculo com o Mandat&aacute;rio ou para a facilita&ccedil;&atilde;o do pagamento.&nbsp;</p>

<ol>
	<li><strong>LEGISLA&Ccedil;&Atilde;O APLIC&Aacute;VEL E FORO</strong></li>
</ol>

<p>Os presentes Termos ser&atilde;o regidos e interpretados de acordo com a legisla&ccedil;&atilde;o da Rep&uacute;blica Federativa do Brasil.</p>

<p>Fica eleito como foro da comarca de Catal&atilde;o, Estado de Goi&aacute;s como competente para dirimir eventuais d&uacute;vidas, controv&eacute;rsias decorrentes da interpreta&ccedil;&atilde;o e cumprimento destes Termos.</p>

<ol>
	<li><strong>ACEITA&Ccedil;&Atilde;O TOTAL DOS TERMOS</strong></li>
</ol>

<p>O Consumidor manifesta expressamente ter a capacidade legal para usar a Plataforma e para celebrar as transa&ccedil;&otilde;es comerciais que possam ser geradas com os Fornecedores. Assim, manifesta ter fornecido informa&ccedil;&atilde;o real, veraz e fidedigna. Portanto, de&nbsp;<strong>forma expressa e inequ&iacute;voca</strong>&nbsp;declara ter lido, que entende e que aceita a totalidade das situa&ccedil;&otilde;es reguladas nestes Termos e Condi&ccedil;&otilde;es de Uso da Plataforma, dando o seu CONSENTIMENTO, pelo que se compromete ao cumprimento total dos deveres, obriga&ccedil;&otilde;es, a&ccedil;&otilde;es e omiss&otilde;es aqui expressadas. Em caso de USU&Aacute;RIOS de outros pa&iacute;ses utilizarem a Plataforma, ficam completamente sujeitos ao disposto nestes termos. Declara ainda que teve a possibilidade de sanar quaisquer d&uacute;vidas em rela&ccedil;&atilde;o a este TERMO E CONDI&Ccedil;&Otilde;ES pelo canal de Suporte ao Usu&aacute;rio.</p>

<address>&nbsp;</address>
 """,
              )
            ],
          ),
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
              child: new Text("Continuar"),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      );
    },
  );
  Future<Login> _desconectar(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    return Login();
  }
}
