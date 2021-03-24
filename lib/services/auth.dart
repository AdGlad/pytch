import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pytch/models/user.dart';
import 'package:pytch/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Create user object based on FirebaseUser

  User _userFromFirebaseUser(FirebaseUser user){
    return user !=null ? User(uid: user.uid) : null;
  }
  // Stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
    .map(_userFromFirebaseUser);

  }

Future registerWithEmailAndPassword(String email, String password) async
{ 
  try {
    AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    await DatabaseService(uid: user.uid).updateUserData('firstname', 'lastname', 'nickname', 'M' );
    return _userFromFirebaseUser(user);
  }
  catch(e) {
    print(e.toString());
    return null;
  }

}
Future signInWithEmailAndPassword(String email, String password) async
{ 
  try {
    AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return _userFromFirebaseUser(user);
  }
  catch(e) {
    print(e.toString());
    return null;
  }

}

Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
}
}
  // Anon signin
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;

    }
  }
}
