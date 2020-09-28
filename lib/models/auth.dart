import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/telas/geolocalizacaoUsuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService extends Model {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user;
  Observable<Map<String, dynamic>> profile;
  // ignore: close_sinks
  PublishSubject loading = PublishSubject();
  static AuthService of(BuildContext context) =>
      ScopedModel.of<AuthService>(context);

  @override
  void addListener(listener) {
    // ignore: todo
    // TODO: implement addListener
    super.addListener(listener);
    _loadCurrentUser();
  }

  Future<Null> _loadCurrentUser() async {}
  AuthService() {
    user = Observable(_firebaseAuth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection("ConsumidorFinal")
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
  }
  Future<bool> googleSignIn() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      if (account == null) return false;

      AuthResult result = await _firebaseAuth
          .signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: (await account.authentication).idToken,
        accessToken: (await account.authentication).accessToken,
      ));

      if (result.user.uid == null)
        return false;
      else {
//        print(result.uid + "aew ");

        verificarCadastro(result.user.uid, result.user.displayName,
            result.user.displayName, result.user.email, result.user.photoUrl);
        notifyListeners();
        return true;
      }
    } catch (e) {
      print("Erro Login");
      return false;
    }
  }

  Future signInWithApple(BuildContext context) async {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential _auth = result.credential;
        final OAuthProvider oAuthProvider =
            new OAuthProvider(providerId: "apple.com");

        final AuthCredential credential = oAuthProvider.getCredential(
            idToken: String.fromCharCodes(_auth.identityToken),
            accessToken: String.fromCharCodes(_auth.authorizationCode));

        await _firebaseAuth.signInWithCredential(credential);

        // update the user information
        if (_firebaseAuth != null) {
          FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
          _firebaseAuth.currentUser().then((value) async {
            print(firebaseUser.uid);
            UserUpdateInfo user = UserUpdateInfo();
            user.displayName =
                "${_auth.fullName.givenName} ${_auth.fullName.familyName}";
            await value.updateProfile(user);

            await verificarCadastroApple(
                firebaseUser.uid,
                firebaseUser.email,
                firebaseUser.email,
                firebaseUser.email,
                "https://firebasestorage.googleapis.com/v0/b/compreai-delivery.appspot.com/o/user.png?alt=media&token=cd7aea4b-4d19-4b10-adce-03008b277da7");
          });
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => GeolocalizacaoUsuario()));
        }
        break;
      case AuthorizationStatus.error:
        print("Erro no Login com a Apple");
        break;
      case AuthorizationStatus.cancelled:
        print("Login Cancelado");
        break;
    }
  }

  void updateUserData(FirebaseUser user) async {}

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print("Error logging out");
    }
  }
}

final AuthService authService = AuthService();
// ignore: missing_return
Future<bool> verificarCadastro(
    String id, String nome, String apelido, String email, String photo) async {
  print(id);
  final QuerySnapshot result = await Firestore.instance
      .collection('ConsumidorFinal')
      .where('uid', isEqualTo: id)
      .limit(1)
      .getDocuments();
  final List<DocumentSnapshot> documents = result.documents;

  if (documents.length <= 0) {
    Firestore.instance.collection('ConsumidorFinal').document(id).setData({
      'nome': nome,
      'apelido': apelido,
      'email': email,
      'uid': id,
      'telefone': "+55",
      'photo': photo,
    });
  } else {}
}

Future<bool> verificarCadastroApple(
    String id, String nome, String apelido, String email, String photo) async {
  print(id);
  final QuerySnapshot result = await Firestore.instance
      .collection('ConsumidorFinal')
      .where('uid', isEqualTo: id)
      .limit(1)
      .getDocuments();
  final List<DocumentSnapshot> documents = result.documents;

  if (documents.length <= 0) {
    Firestore.instance.collection('ConsumidorFinal').document(id).setData({
      'nome': nome,
      'apelido': apelido,
      'email': email,
      'uid': id,
      'telefone': "+55",
      'photo': photo,
    });
  } else {}
}
