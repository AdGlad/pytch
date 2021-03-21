import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pytch/models/vape.dart';
import 'package:pytch/models/user.dart';

class DatabaseService {

final String uid;
DatabaseService({this.uid});

   final CollectionReference vapeCollection = Firestore.instance.collection('vapes');
   
   Future<void> updateUserData(String name, 
                               String sex,
                               String dob,
                               int strength,
                               String whyquit,
                               int dailyspend,
                               String startdate,
                               int frequency,
                               String colorVal,
                               String hunger,
                               String stress,
                               String boredom,
                               String alcohol,
                               String driving,
                               String craving,
                               String justthere) async {
      return await vapeCollection.document(uid).setData({
        'name': name,
        'sex': sex,
        'dob': dob,
        'strength': strength,
        'startdate': startdate,
        'whyquit': whyquit,
        'dailyspend': dailyspend,
        'frequency': frequency,
        'score': frequency * strength,
        'colorVal': colorVal,
        'hunger': hunger,
        'stress': stress,
        'boredom': boredom,
        'alcohol': alcohol,
        'driving': driving,
        'craving': craving,
        'justthere': justthere
    });
 }

// List of Vapers
List<Vape> _vapeListFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.documents.map((doc){
    return Vape(
      name: doc.data['name'] ?? '',
      sex: doc.data['sex'] ?? '',
      dob: doc.data['dob'] ?? '',
      strength: doc.data['strength'] ?? 0,
      whyquit: doc.data['whyquit'] ?? '',
      dailyspend: doc.data['dailyspend'] ?? 0,
      startdate: doc.data['startdate'] ?? '',
      frequency: doc.data['frequency'] ?? 0,
      score: doc.data['score'] ?? 0,
      colorVal: doc.data['colorVal'] ?? '0xFF90A5F5',
      );
  }).toList();
}


  Stream<List<Vape>> get vapes {
    return vapeCollection.snapshots().map(_vapeListFromSnapshot);
  }
//Userdata from snapshot

UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
  return UserData(
    uid: uid,
    name: snapshot.data['name'],
    sex: snapshot.data['sex'],
    dob: snapshot.data['dob'],
    strength: snapshot.data['strength'],
    whyquit: snapshot.data['whyquit'],
    dailyspend: snapshot.data['dailyspend'],
    startdate: snapshot.data['startdate'],
    frequency: snapshot.data['frequency'],
    score: snapshot.data['score'],
    colorVal: snapshot.data['colorVal'],
    hunger: snapshot.data['hunger'],
    stress: snapshot.data['stress'],
    boredom: snapshot.data['boredom'],
    alcohol: snapshot.data['alcohol'],
    driving: snapshot.data['driving'],
    craving: snapshot.data['craving'],
    justthere: snapshot.data['justthere']
    );
}

  Stream<UserData> get userData { 
    return vapeCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}   
