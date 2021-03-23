import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
import 'package:pytch/models/user.dart';

class DatabaseService {

final String uid;
DatabaseService({this.uid});

   final CollectionReference userCollection = Firestore.instance.collection('users');

      Future<void> updateUserData(String firstname, 
                               String lastname,
                               String nickname,
                               String sex,
) async {
      return await userCollection.document(uid).setData({
        'firstname': firstname,
        'lastname': lastname,
        'nickname': nickname,
        'sex': sex,
        // 'image': sex,
    });
 }
   

// List of Users
 List<UserData> _userdataListFromSnapshot(QuerySnapshot snapshot) {
   return snapshot.documents.map((doc){
     return UserData(
       firstname: doc.data['firstname'] ?? '',
       lastname: doc.data['lastname'] ?? '',
       nickname: doc.data['nickname'] ?? '',
       sex: doc.data['sex'] ?? '',
       );
   }).toList();
 }



  Stream<List<UserData>> get vapes {
    return userCollection.snapshots().map(_userdataListFromSnapshot);
  }
//Userdata from snapshot

UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
  return UserData(
    uid: uid,
    firstname: snapshot.data['firstname'],
    lastname: snapshot.data['lastname'],
    nickname: snapshot.data['nickname'],
    sex: snapshot.data['sex'],
    );
}

  Stream<UserData> get userData { 
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}   
