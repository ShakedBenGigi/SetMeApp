import 'package:firebase_auth/firebase_auth.dart';

import '../module/user.dart';

class AuthMethods {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid, name: user.displayName,
        bio: "", email: user.email, status: "", photoUrl: user.photoUrl) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword
        (email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    }
    catch(e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword
        (email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    }catch (e) {
      //pop massage email is already in use
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }
}