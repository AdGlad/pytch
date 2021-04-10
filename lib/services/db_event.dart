import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//import 'package:pytch/models/event.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:pytch/models/event.dart';
import 'dart:convert';

class DbEventService {

final String uid;
DbEventService({this.uid});

   final CollectionReference eventCollection = FirebaseFirestore.instance.collection('events');

      Future<void> updateEventoffer(
                               String offertype,
                               String offersdp,
                               ) async {

      return await eventCollection..doc(uid).update({'offer': {'type': offertype,'sdp':  offersdp}})
    //  .update({'offer': FieldValue.arrayUnion([{'type': offertype,'sdp':  offersdp} ]) })
    //   set({
    //     'offer': {
    //       'type': offertype,
    //       'sdp':  offersdp
    //     }
    // })
    //.update({'field': FieldValue.delete()})
   // .update({'offer': FieldValue.arrayUnion(["world"])})
    .then((value) => print("Offer Property updated"))
    .catchError((error) => print("Failed to update offer property: $error"));      
        // 'offer': {
        //   'type': offertype,
        //   'sdp':  offersdp
        // },

 }
       Future<void> updateEventanswer(
                               String answertype,
                               String answersdp,
                               ) async {
        var ans = ['answer0'];
        print('starting update');
        //  String answerstring = '{"answers": [  {"sdp": "sdp json1", "candidate": "candidate json1"}, {"sdp": "sdp json2", "candidate": "candidate json2"}]}';
        //  var answerlist = jsonDecode(answerstring)["answers"] as List;
        //  List<Answer> answers = answerlist.map( (answerjson) => Answer.fromJson(answerjson) ).toList();     
      // return await eventCollection.document(uid).updateData({
      //   'answer': {
      //     'type': answertype,
      //     'sdp':  answersdp
      //   },
      // 
      return await eventCollection..doc(uid).update(
        {'answer': FieldValue.arrayUnion([{'type': answertype,'sdp':  answersdp}])}
        //{'answer': {'type': answertype,'sdp':  answersdp}}
        )
    //   return await eventCollection.doc('data')
    //.update({'field': FieldValue.delete()})
   // .update({'answer': FieldValue.arrayUnion(["answer"])})
    .then((value) => print("Answer Property updated"))
    .catchError((error) => print("Failed to update answer property: $error"));  

      // eventCollection.doc(uid).updateData({
      //   //'answer': FieldValue.arrayUnion(answers)
      //     'answer': FieldValue.arrayUnion(['answers'])
      //  return await eventCollection.document(uid).setData({
        //'answer': FieldValue.arrayUnion(answers)
        //  'answer': FieldValue.arrayUnion(['answers1','answers2','answers3'])}, merge: true);
        //  'answer': FieldValue.arrayUnion(ans)});
        //  "answer": FieldValue.arrayRemove(ans)}

       //}).then((value) => print("Event updated with answer")).catchError((error) => print("Failed to update answer: $error"))

          //'answer': FieldValue.arrayUnion(['answers1','answers2','answers3'])});
      //;
 }
        Future<void> updateEventcandidate(
                               String candidatetype,
                               String candidatesdp,
                               ) async {
      return await eventCollection.doc('data')
    //.update({'field': FieldValue.delete()})
    .update({'candidate': FieldValue.arrayUnion(["candidate"])})
    .then((value) => print("candidate Property updated"))
    .catchError((error) => print("Failed to update candidate: $error"));
      
      //eventCollection.doc(uid).updateData({
      //  'candidate': {
      //    'type': candidatetype,
      //    'sdp':  candidatesdp
      //  },
   // }).then((value) => print("Event updated with candidate")).catchError((error) => print("Failed to update candidate: $error"));
 }


//         Future<void> createEventData(
//                                String eventname,
//                                String userid,
//                                ) async {
//       return await eventCollection.document(uid).setData({
//         'eventname': eventname,
//         'userid': userid,
//         'offer': {'type': '','sdp': ''} ,
//         'answer': {'type': '','sdp': ''} ,
//         'candidate': {'type': '','sdp': ''} ,        
//         }).then((value) => print("Event Added")).catchError((error) => print("Failed to add event: $error"));
//  }
        Future<void> createEventData(
                               String eventname,
                               String userid,
                               ) async {
      return  await 
      eventCollection
    .doc(uid).set({
        'eventname': eventname,
        'userid': userid,
        'offer': {'type': '','sdp': ''} ,
        'answer': {'type': '','sdp': ''} ,
        'candidate': {'type': '','sdp': ''} , 
    })
    .then((value) => print("Event Property created"))
    .catchError((error) => print("Failed to delete user's property: $error"));
      
      
      
      
      await eventCollection.add({
        'eventname': eventname,
        'userid': userid,
        'offer': {'type': '','sdp': ''},}).then((value) => print("Event Added")).catchError((error) => print("Failed to add event: $error"));
      
      
      // eventCollection.doc(uid).setData({
      //   'eventname': eventname,
      //   'userid': userid,
      //   'offer': {'type': '','sdp': ''} ,      
      //   }).then((value) => print("Event Added")).catchError((error) => print("Failed to add event: $error"));
 }

// List of Events
 List<EventData> _eventdataListFromSnapshot(QuerySnapshot snapshot) {
   return snapshot.docs.map((doc){
     return EventData(
       id: doc.reference.id,
       eventname: doc.data()['eventname'] ?? '',
       offer: doc.data()['offer']['sdp'] ?? '',
    //   answer: doc.data['answer']['sdp']  ?? '',
    //   candidate: doc.data['candidate']['sdp']  ?? '',
       );
   }).toList();
 }



  Stream<List<EventData>> get events {
    return eventCollection.snapshots().map(_eventdataListFromSnapshot);
  }

//    Stream<QuerySnapshot> get eventlist {
//   final Query eventQuery = FirebaseFirestore.instance.collection('events');

//   return eventQuery.get().asStream();
// }



//Eventdata from snapshot

EventData _eventDataFromSnapshot(DocumentSnapshot snapshot) {
  return EventData(
    id: uid,
    eventname: snapshot.data()['eventname'],
    offer: snapshot.data()['offer']['sdp']  ?? '',
   // answer: snapshot.data['answer']['sdp']  ?? '',
   // candidate: snapshot.data['candidate']['sdp']  ?? '',
    );
}

  Stream<EventData> get eventData { 
    
    return eventCollection.doc(uid).snapshots().map(_eventDataFromSnapshot);
  }

 // Stream<EventData> get answerswebrtc {
 //   return eventCollection.doc(uid).snapshots().map(_eventDataFromSnapshot);
 // }

}   

