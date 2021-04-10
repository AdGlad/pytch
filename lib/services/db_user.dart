import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
import 'package:pytch/models/user.dart';

class DbUserService {

final String uid;
DbUserService({this.uid});
   final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  // final CollectionReference userCollection = Firestore.instance.collection('users');
      Future<void> updateUserData(String firstname, 
                               String lastname,
                               String nickname,
                               String sex,
) async {
      return await 
      userCollection
    .doc(uid).set({
        'firstname': firstname,
        'lastname': lastname,
        'nickname': nickname,
        'sex': sex,
        // 'image': sex,
    })
    .then((value) => print("User's Property Deleted"))
    .catchError((error) => print("Failed to delete user's property: $error"));
      
      
      
    //   userCollection.doc(uid).setData({
    //     'firstname': firstname,
    //     'lastname': lastname,
    //     'nickname': nickname,
    //     'sex': sex,
    //     // 'image': sex,
    // });
 }
   

// List of Users
 List<UserData> _userdataListFromSnapshot(QuerySnapshot snapshot) {
   return snapshot.docs.map((doc){
    print('DDDDDDDDDDDDDDDDDDDDDDD');
     print(doc.data()['firstname']);
     return UserData(
       firstname: doc.data()['firstname'] ?? '',
       lastname: doc.data()['lastname'] ?? '',
       nickname: doc.data()['nickname'] ?? '',
       sex: doc.data()['sex'] ?? '',
       );
   }).toList();
  print('DDDDDDDDDDDDDDDDDDDDDDD');

 }



  Stream<List<UserData>> get vapes {
    return userCollection.snapshots().map(_userdataListFromSnapshot);
  }
//Userdata from snapshot

UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    print('DDDDDDDDDDDDDDDDDDDDDDD');
     print(snapshot.data()['firstname']);
  return UserData(
    //uid: uid,
    uid: snapshot.reference.id,
    firstname: snapshot.data()['firstname'],
    lastname: snapshot.data()['lastname'],
    nickname: snapshot.data()['nickname'],
    sex: snapshot.data()['sex'],
    );
}

  Stream<UserData> get userData { 
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}   
