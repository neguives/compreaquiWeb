import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/introducao.dart';
import 'package:compreaidelivery/models/auth.dart';
import 'package:compreaidelivery/telas/geolocalizacaoUsuario.dart';
import 'package:compreaidelivery/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:compreaidelivery/style/theme.dart' as Theme;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _Login createState() => new _Login();
}

class _Login extends State<Login> with SingleTickerProviderStateMixin {
  bool _isLoggedIn = false;

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final _nameController = TextEditingController();
  final _apelidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _senhaRepetidaController = TextEditingController();
  final _telefoneController = TextEditingController();
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
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  PageController _pageController;
  final telefoneController = TextEditingController();
  Color left = Colors.black;
  Color right = Colors.white;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
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
                  overflow: Overflow.visible,
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
                                email: _emailController.text.trim(),
                                pass: _senhaController.text.trim(),
                                onSucess: _onSucess,
                                onFail: _onFail);
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
                            onPressed: () {
                              _loginGoogle();
                            },
                            child: Image.asset(
                              'assets/gmail.png',
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        child: FlatButton(
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            disabledColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            color: Colors.transparent,
                            onPressed: () {},
                            child: Image.asset(
                              'assets/fb.png',
                            )),
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
                  overflow: Overflow.visible,
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
                                      top: 20.0,
                                      bottom: 10.0,
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
                            colors: [
                              Theme.Colors.loginGradientEnd,
                              Theme.Colors.loginGradientStart
                            ],
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
                                            "apelido": _apelidoController.text.trim(),
                                            "email": _emailController.text.trim(),
                                            "telefone": telefoneController.text.trim(),
                                            "cidade": _cidadeController.text.trim(),
                                            "latitude": "-12.117111",
                                            "logintude": "-38.430454",
                                            "tipoPerfil": "Consumidor"
                                          };

                                          model.signUp(
                                              userData: userData,
                                              pass: _senhaController.text,
                                              onSucess: _onSucessRegister,
                                              onFail: _onFailRegister);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }

                          _showDialogTelefone(context);

                          ;
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

  void _onSucessRegister() {
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

  void _onSucess() {
    Future.delayed(Duration(seconds: 1)).then((_) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => GeolocalizacaoUsuario()));
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Sua senha está errada."),
      backgroundColor: Colors.blueGrey,
      duration: Duration(seconds: 2),
    ));
  }

  void _onFailRegister() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Houve algum erro ao tentar fazer seu registro."),
      backgroundColor: Colors.blueGrey,
      duration: Duration(seconds: 2),
    ));
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
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

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

  _loginGoogle() async {
    AuthService authService = AuthService();
    bool res = await authService.googleSignIn();
    if (!res) {
      print("Erro ao fazer o login com o Google");
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => GeolocalizacaoUsuario()));
    }
  }
}
