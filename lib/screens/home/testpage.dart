import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pytch/models/eventanswer.dart';
import 'package:pytch/services/db_event.dart';
import 'package:uuid/uuid.dart';



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
          .doc("h5BKsA58r7ozoVKF3lV7").collection("subCollection").doc("message2").set({"password": "password"})
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

Future<void> createPC (var eventid) async {
      String pcid ;
      var uuid = Uuid();
      pcid = uuid.v4();
      var _collectionReference = FirebaseFirestore.instance.collection('Event');

       return _collectionReference
          .doc(eventid).collection("PeerCollection").doc(pcid).set({
            'offer': {'type': '','sdp': ''} ,
            'answer': {'type': '','sdp': ''} ,
            'candidate': {'type': '','sdp': ''} , 
            'connected': 'N' ,})
          .then((value) => print("PeerCollection Added"))
          .catchError((error) => print("Failed to add PeerCollection: $error"));

    }

Future<void> QuerySubCollections(var refl) {
     //final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    //var ref = FirebaseFirestore.instance.collection("data_collection");

    //Query ref = FirebaseFirestore.instance.collection('data_collection').doc("h5BKsA58r7ozoVKF3lV7").collection("subCollection").doc("message8");
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

    //Query ref = FirebaseFirestore.instance.collection('data_collection').doc("h5BKsA58r7ozoVKF3lV7").collection("subCollection").doc("message5");
    DocumentSnapshot ref = await  FirebaseFirestore.instance.collection('data_collection').doc("h5BKsA58r7ozoVKF3lV7").collection("subCollection").doc("message3").get();
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
  
  // FirebaseFirestore.instance.collection('events').where(FieldPath.documentId,isEqualTo: 'eventid').where('connected',isEqualTo: 'N').snapshots().listen((event) {
  // Listen for Broadcaster event subscriptions
  //  FirebaseFirestore.instance.collection('events').where(FieldPath.documentId,isEqualTo: 'eventid').snapshots().listen((event) {
  //    print('Test Event for eventid updated');
  //  });

   FirebaseFirestore.instance.collection('events').where('userid',isEqualTo: '1234').snapshots().listen((event) {
     print('Event subscriptions for user 123456');
   });
  // FirebaseFirestore.instance.collection('events').doc('eventid').collection('subCollection').doc('message6').snapshots().listen((event) { 
  //   print('New peer connection for user 1234');
  // });

    FirebaseFirestore.instance.collection('events').doc('eventid').collection('subCollection').where('offerCreated',isEqualTo: 'N').snapshots().listen((event) {
        print('New peer connection for event eventid');
        print('create Offer');

    });

    FirebaseFirestore.instance.collection('events').doc('eventid').collection('subCollection').doc('message6').snapshots().listen((event) {
        print('Monitor peer connection for connection updates');

        //print(event.toString());
        //print(event.data().toString());
         print(event['connected']);
         print(event.data()['offerCreated']);
         print(event.data()['answerCreated']);
         print(event.data()['candidatesCreated']);
         print(event.data()['remoteDescAssigned']);
         print(event.data()['candidateAssigned']);

         if (event.data()['offerCreated']=='Y') {
             print('offerCreated');
             print('Create Answer');
             
         }
    });

  // FirebaseFirestore.instance.collection('subCollection').where('eventname',isEqualTo: 'eventid').snapshots().listen((event) 
  // { 
  //  print('New peer connection for user 1234');
  // });

// FirebaseFirestore.instance.collection('events')doc('eventid').collection('subCollection').doc('message6').snapshots().listen((event) { 
//   print('New peer connection for user 1234');
// });


  //  FirebaseFirestore.instance.collection('events').where('userid',isEqualTo: '1234').collection('subCollection').snapshots().listen((event) {
  //    print('Event subscriptions for user 1234');
  //  });



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
      // DbEventService(uid: eventid).eventConnection.listen((event) {
      //   print('eventConnection');
      //    print(event);
      //    print('answer');
      //    //print(event.answer);
      //    print('Value from eventConnection: event');
      //    event.docs.forEach((doc) {
      //       print('looping');
      //       print(doc["connection"]);
      //   });

      //  });

  // 
     super.initState();
   }


   deleteEvent () async
   {
  print('deleteEvent');
        //await FirebaseFirestore.instance.collection('events').doc('eventid').collection('subCollection').doc('message8').delete();
        await FirebaseFirestore.instance.collection('events').doc('eventid').delete();
        //await FirebaseFirestore.instance.collection('subCollection').doc('message9').delete();

}
   deletePeerConnection () async
   {
  print('deletePeerConnection');
        await FirebaseFirestore.instance.collection('events').doc('eventid').collection('subCollection').doc('message6').delete();
        //await FirebaseFirestore.instance.collection('events').doc('eventid').delete();
        //await FirebaseFirestore.instance.collection('subCollection').doc('message6').delete();

}

createEvent () async
{
  print('createEvent');
      await DbEventService(uid: 'eventid').createEventData('Manly round 5', '1234');

}

createPeerConnection () async
{
    print('createPeerConnection: Create Peer Connection for event id');
          await FirebaseFirestore.instance.collection('events').doc('eventid').collection("subCollection").doc("message6").
          set({
          'eventname': 'eventid',
          //'userid': userid,
          'offer': {'type': '', 'sdp': ''},
          'answer': {'type': '', 'sdp': ''},
          'candidate': {'type': '', 'sdp': ''},
          'connected': 'N',
          'offerCreated': 'N',
          'answerCreated': 'N',
          'candidatesCreated': 'N',
          'remoteDescAssigned': 'N',
          'candidateAssigned': 'N',
        })
           .then((value) => print("User Added"))
           .catchError((error) => print("Failed to add user: $error"));

}
createOffer () async
{
    print('createOffer');
          await FirebaseFirestore.instance.collection('events').doc('eventid').collection("subCollection").doc("message6").update({'offerCreated': 'Y'});
}
createAnswer () async
{
    print('createAnswer');
    await FirebaseFirestore.instance.collection('events').doc('eventid').collection("subCollection").doc("message6").update({'answerCreated': 'Y'});

}
createCandidate () async
{
    print('createCandidate');
    await FirebaseFirestore.instance.collection('events').doc('eventid').collection("subCollection").doc("message6").update({'candidatesCreated': 'Y'});

}
createRemoteDescription () async
{
    print('createRemoteDescription');
    await FirebaseFirestore.instance.collection('events').doc('eventid').collection("subCollection").doc("message6").update({'remoteDescAssigned': 'Y'});

}
updateCandidate () async
{
    print('updateCandidate');
    await FirebaseFirestore.instance.collection('events').doc('eventid').collection("subCollection").doc("message6").update({'candidateAssigned': 'Y'});

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
                 child: Text('deleteEvent'),
                     onPressed: () {
                        deleteEvent();
                      },
             ),
              TextButton(
                 child: Text('deletePeerConnection'),
                     onPressed: () {
                        deletePeerConnection();
                      },
             ),            TextButton(
                 child: Text('createEvent'),
                     onPressed: () {
                        createEvent();
                      },
             ),
             TextButton(
                 child: Text('Create Peer Connection listenEvent'),
                     onPressed: () {
                        createPeerConnection();
                      },
             ),
             TextButton(
                 child: Text('createOffer'),
                     onPressed: () {
                        createOffer();
                      },
             ),
             TextButton(
                 child: Text('createAnswer'),
                     onPressed: () {
                        createAnswer();
                      },
             ),
             TextButton(
                 child: Text('createCandidate'),
                     onPressed: () {
                        createCandidate();
                      },
             ), 
              TextButton(
                 child: Text('createRemoteDescription'),
                     onPressed: () {
                        createRemoteDescription();
                      },
             ), 
              TextButton(
                 child: Text('updateCandidate'),
                     onPressed: () {
                        updateCandidate();
                      },
             ),                        
            //  TextButton(
            //      child: Text('updateField'),
            //          onPressed: () {
            //             updateField(ref);
            //           },
            //  ),
            //   TextButton(
            //      child: Text('removeField'),
            //          onPressed: () {
            //             removeField(ref);
            //           },
            //  ),
            //   TextButton(
            //      child: Text('QueryCollection'),
            //          onPressed: () {
            //             QueryCollections(ref);
            //           },
            //  ),
            //  TextButton(
            //      child: Text('QueryEvents'),
            //          onPressed: () {
            //             QueryEvents(ref);
            //           },
            //  ),
            //   TextButton(
            //      child: Text(' Create SubCollection'),
            //          onPressed: () {
            //             SubCollection(ref);
            //           },
            //  ),
            //   TextButton(
            //      child: Text('QuerySubCollections'),
            //          onPressed: () {
            //             QuerySubCollections(ref);
            //           },
            //  ),
            //  TextButton(
            //      child: Text('QuerySubCollectionDoc'),
            //          onPressed: () {
            //             QuerySubCollectionDoc(ref);
            //           },
            //  ),
            //  TextButton(
            //      child: Text('createPC record'),
            //          onPressed: () {
            //             createPC('ref');
            //           },
            //  ),
             
             
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