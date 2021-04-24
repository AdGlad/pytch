import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pytch/models/eventanswer.dart';
import 'package:pytch/services/db_event.dart';


Future<void> addfirestore(var ref) {
      // Call the user's CollectionReference to add a new user
      //var ref = FirebaseFirestore.instance.collection("data_collection");
      //var ref = FirebaseFirestore.instance.collection("data_collection");

      return ref
          .add({
            'full_name': 'fullName', // John Doe
            'company': 'company', // Stokes and Sons
            'age': 'age' // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

updatefirestore()
{
  print("heeellloooo");
 //var ref = 
 //Firestore.instance.document("data_collection/data");
  //FirebaseFirestore.instance.collection("data_collection/data");
  
//  FirebaseFirestore.instance.collection("data_collection");
// ref.setData({
//   "field": FieldValue.arrayUnion(["World"]),
// });
  print("finish");
}

Future<void> deleteField(var ref) {
        //var ref = FirebaseFirestore.instance.collection("data_collection");

  return ref
    .doc('data')
    .update({'field': FieldValue.delete()})
    //.update({'field': FieldValue.delete(["world"])})
    .then((value) => print("User's Property Deleted"))
    .catchError((error) => print("Failed to delete user's property: $error"));
}

Future<void> updateField(var ref) {
        //var ref = FirebaseFirestore.instance.collection("data_collection");

  return ref
    .doc('data')
    //.update({'field': FieldValue.delete()})
    .update({'field': FieldValue.arrayUnion(["world"])})
    .then((value) => print("User's Property updated"))
    .catchError((error) => print("Failed to delete user's property: $error"));
}

Future<void> removeField(var ref) {
       // var ref = FirebaseFirestore.instance.collection("data_collection");

  return ref
    .doc('data')
    //.update({'field': FieldValue.delete()})
    .update({'field': FieldValue.arrayRemove(["world"])})
    .then((value) => print("User's Property updated"))
    .catchError((error) => print("Failed to delete user's property: $error"));
}

Future<void> QueryCollections(var refl) {
     //final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    //var ref = FirebaseFirestore.instance.collection("data_collection");

    Query ref = FirebaseFirestore.instance.collection('data_collection');
    print(ref.toString());
    print('ggggggggggggggggggggggggggggggg');
    ref.get().then((QuerySnapshot querySnapshot) {
         querySnapshot.docs.forEach((doc) {
            print('in loooooop');
            print(doc.data());
            //print(doc['data']['adam']);
    });
    });
    // print('ddddddddd');

    // print(userCollection.toString());
    // userCollection.get().then((querySnapshot)  {
    //       querySnapshot.docs.forEach(
    //         (document) {
    //         //print(document['age']);
    //         print(document);
    //       }
    //       );
    // });
    // 
}

Future<void> SubCollection(var ref) {
      return ref
          .doc("h5BKsA58r7ozoVKF3lV7").collection("subCollection").doc("message1").set({"password": "password"})
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

Future<void> QuerySubCollections(var refl) {
     //final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    //var ref = FirebaseFirestore.instance.collection("data_collection");

    //Query ref = FirebaseFirestore.instance.collection('data_collection').doc("h5BKsA58r7ozoVKF3lV7").collection("subCollection").doc("message1");
    Query ref = FirebaseFirestore.instance.collection('data_collection').doc("h5BKsA58r7ozoVKF3lV7").collection("subCollection").where("password", isEqualTo: "password");
    print(ref.toString());
    print('ggggggggggggggggggggggggggggggg');
    ref.get().then((QuerySnapshot querySnapshot) {
         querySnapshot.docs.forEach((doc) {
            print('in QuerySubCollections loooooop');
            print(doc.data());
            //print(doc['data']['adam']);
          });
          });

}

Future<void> QuerySubCollectionDoc(var refl) async {
     //final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    //var ref = FirebaseFirestore.instance.collection("data_collection");

    //Query ref = FirebaseFirestore.instance.collection('data_collection').doc("h5BKsA58r7ozoVKF3lV7").collection("subCollection").doc("message1");
    DocumentSnapshot ref = await  FirebaseFirestore.instance.collection('data_collection').doc("h5BKsA58r7ozoVKF3lV7").collection("subCollection").doc("message1").get();
    print(ref.data()['password']);
    print('ggggggggggggggggggggggggggggggg');
    // ref.get().then((QuerySnapshot querySnapshot) {
    //      querySnapshot.docs.forEach((doc) {
    //         print('in QuerySubCollections loooooop');
    //         print(doc.data());
    //         //print(doc['data']['adam']);
    //       });
    //       });

}


Future<void> QueryEvents(var refl) {
    //String uid = '3373f0ae-d20c-4d24-81e2-501cb8b59aa9';
    String uid = '751250a4-54a5-46cf-99ac-79c22be1aa4a';

    Query eventCollection = FirebaseFirestore.instance.collection('events');
    //eventCollection.where(FieldPath.documentId,isEqualTo: uid).where('connection',isEqualTo: 'N').snapshots().map(_eventdataListFromSnapshot);
    print(eventCollection.toString());
    print('ggggggggggggggggggggggggggggggg');
    //eventCollection.where(FieldPath.documentId,isEqualTo: uid)
    //eventCollection.where('sdpapp',isEqualTo: 'N')
    //eventCollection.where('userid',isEqualTo: '1234')
    eventCollection.where('connection',isEqualTo: 'N')
    .where(FieldPath.documentId,isEqualTo: uid)
                   // .where('sdpapp',isEqualTo: 'N')
                   // .where('connection',isEqualTo: 'N')
                   .get().then((QuerySnapshot querySnapshot) {
         querySnapshot.docs.forEach((doc) {
            print('in loooooop');
            print(doc.data()['answer']['sdpapp']);
            print(doc.data()['answer']['type']);
            //print(doc['data']['adam']);
    });});
    // print('ddddddddd');

    // print(userCollection.toString());
    // userCollection.get().then((querySnapshot)  {
    //       querySnapshot.docs.forEach(
    //         (document) {
    //         //print(document['age']);
    //         print(document);
    //       }
    //       );
    // });
    // 
}

// Future<void> removeFieldOld(var ref) {
//        // var ref = FirebaseFirestore.instance.collection("data_collection");

//   return ref
//     .document('data')
//     //.update({'field': FieldValue.delete()})
//     ..updateData({'field': FieldValue.arrayRemove(["world"])})
//     .then((value) => print("User's Property updated"))
//     .catchError((error) => print("Failed to delete user's property: $error"));
// }
class TestPage extends StatefulWidget {

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  var ref = FirebaseFirestore.instance.collection('data_collection');
  //var ref = Firestore.instance.collection("data_collection");

    // Set default `_initialized` and `_error` state to false
  // bool _initialized = false;
  // bool _error = false;

  //   void initializeFlutterFire() async {
  //   try {
  //     // Wait for Firebase to initialize and set `_initialized` state to true
  //     await Firebase.initializeApp();
  //     setState(() {
  //       _initialized = true;
  //     });
  //   } catch(e) {
  //     // Set `_error` state to true if Firebase initialization fails
  //     setState(() {
  //       _error = true;
  //     });
  //   }
  // }
  // @override
  // void initState() {
  //  // initializeFlutterFire();
  //   super.initState();
  // }
  // 

   @override
   void initState() {
  
     //String eventid = '58be842f-65d6-46c6-bd32-35ba1d5a6f4b';
     String eventid = '751250a4-54a5-46cf-99ac-79c22be1aa4a';

    //  QuerySnapshot querySnapshot;
    //    DbEventService(uid: eventid).eventData.listen((event) {
    //     print('event');
    //      print(event);
    //      print('answer');
    //      //print(event.answer);
    //      print('Value from controller: event');
    //    });
      DbEventService(uid: eventid).eventConnection.listen((event) {
        print('eventConnection');
         print(event);
         print('answer');
         //print(event.answer);
         print('Value from eventConnection: event');
         event.docs.forEach((doc) {
            print('looping');
            print(doc["connection"]);
        });

       });

  // 
     super.initState();
   }

  @override
Widget build(BuildContext context) {
  
      return Scaffold(
        appBar: AppBar(
          title: Text('Woolha.com Flutter Tutorial'),
        ),
        body: Container(
          child: Column(children: [
             TextButton(
                 child: Text('deleteField'),
                     onPressed: () {
                        deleteField(ref);
                      },
             ),
             TextButton(
                 child: Text('updateField'),
                     onPressed: () {
                        updateField(ref);
                      },
             ),
              TextButton(
                 child: Text('removeField'),
                     onPressed: () {
                        removeField(ref);
                      },
             ),
              TextButton(
                 child: Text('QueryCollection'),
                     onPressed: () {
                        QueryCollections(ref);
                      },
             ),
             TextButton(
                 child: Text('QueryEvents'),
                     onPressed: () {
                        QueryEvents(ref);
                      },
             ),
              TextButton(
                 child: Text(' Create SubCollection'),
                     onPressed: () {
                        SubCollection(ref);
                      },
             ),
              TextButton(
                 child: Text('QuerySubCollections'),
                     onPressed: () {
                        QuerySubCollections(ref);
                      },
             ),
             TextButton(
                 child: Text('QuerySubCollectionDoc'),
                     onPressed: () {
                        QuerySubCollectionDoc(ref);
                      },
             ),

             
            //   TextButton(
            //      child: Text('removeFieldOld'),
            //          onPressed: () {
            //             removeFieldOld(ref);
            //           },
            //  )
                       ],
          ),
          ),
      );
}
}