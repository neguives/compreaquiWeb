import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';

class AuthService extends Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
    user = Observable(_auth.onAuthStateChanged);

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

      FirebaseUser result =
          await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: (await account.authentication).idToken,
        accessToken: (await account.authentication).accessToken,
      ));

      if (result.uid == null)
        return false;
      else {
//        print(result.uid + "aew ");

        verificarCadastro(result.uid, result.displayName, result.displayName,
            result.email, result.photoUrl);
        notifyListeners();
        return true;
      }
    } catch (e) {
      print("Erro Login");
      return false;
    }
  }

  void updateUserData(FirebaseUser user) async {}

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error logging out");
    }
  }
}

final AuthService authService = AuthService();
// ignore: missing_return
Future<bool> verificarCadastro(
    String id, String nome, String apelido, String email, String photo) async {
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
