import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User1? _userFromFirebaseUser(User user) {
    return user != null ? User1(uid: user.uid) : null;
  }

  Future signInEmailAndPass(String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = authResult.user!;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e);
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = authResult.user!;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getUserId(String email) async {
    Stream userData = DatabaseService().getUserData();
    String userId = "";
  }
}
