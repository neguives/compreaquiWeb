import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(listener) {
    // TODO: implement addListener
    super.addListener(listener);
    _loadCurrentUser();
  }

  DocumentReference get firestoreRef => Firestore.instance.document('users/');

  CollectionReference get cartReference => firestoreRef.collection('cart');

  CollectionReference get tokensReference => firestoreRef.collection('tokens');
  void signUp(
      {@required Map<String, dynamic> userData,
      String pass,
      @required VoidCallback onSucess,
      VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: pass)
        .then((user) async {
      firebaseUser = user;
      await _saveUserData(userData);
      onSucess();
      isLoading = false;
      notifyListeners();
      print("Deu certo");
    }).catchError((e) async {
      onFail();
      print("Deu errado" + userData.toString());
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  void signIn(
      {@required String email,
      @required String pass,
      @required VoidCallback onSucess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
      firebaseUser = user;
      await _loadCurrentUser();

      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  void recoverPass() {}

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("ConsumidorFinal")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) if (userData["nome"] == null) {
      DocumentSnapshot docUser = await Firestore.instance
          .collection("ConsumidorFinal")
          .document(firebaseUser.uid)
          .get();
      userData = docUser.data;
    }
    notifyListeners();
  }

  Future<void> saveToken() async {
    final token = await FirebaseMessaging().getToken();
    await tokensReference.document(token).setData({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
    });
    print("token $token");
  }
}
