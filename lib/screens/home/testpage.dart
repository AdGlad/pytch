import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

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