import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pytch/models/user.dart';
import 'package:pytch/services/db_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Create user object based on FirebaseUser

  UserLocal _userFromFirebaseUser(User user){
    return user !=null ? UserLocal(uid: user.uid) : null;
  }
  // Stream
  Stream<UserLocal> get user {
    return _auth.authStateChanges()
    .map(_userFromFirebaseUser);

  }

Future registerWithEmailAndPassword(String email, String password) async
{ 
  try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = result.user;
    //FirebaseUser user = result.user;
    await DbUserService(uid: user.uid).updateUserData('firstname', 'lastname', 'nickname', 'M' );
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
    UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    User user = result.user;
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
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;

    }
  }
}
