import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
import 'package:pytch/models/event.dart';

class DbEventService {

final String uid;
DbEventService({this.uid});

   final CollectionReference eventCollection = Firestore.instance.collection('events');

      Future<void> updateEventoffer(
                               String offertype,
                               String offersdp,
                               ) async {

      return await eventCollection.document(uid).updateData({
        'offer': {
          'type': offertype,
          'sdp':  offersdp
        },
    }).then((value) => print("Event updated with offer")).catchError((error) => print("Failed to update offer: $error"));
 }
       Future<void> updateEventanswer(
                               String answertype,
                               String answersdp,
                               ) async {
      return await eventCollection.document(uid).updateData({
        'answer': {
          'type': answertype,
          'sdp':  answersdp
        },
    }).then((value) => print("Event updated with answer")).catchError((error) => print("Failed to update answer: $error"));
 }
        Future<void> updateEventcandidate(
                               String candidatetype,
                               String candidatesdp,
                               ) async {
      return await eventCollection.document(uid).updateData({
        'candidate': {
          'type': candidatetype,
          'sdp':  candidatesdp
        },
    }).then((value) => print("Event updated with candidate")).catchError((error) => print("Failed to update candidate: $error"));
 }


        Future<void> createEventData(
                               String eventname,
                               String userid,
                               ) async {
      return await eventCollection.document(uid).setData({
        'eventname': eventname,
        'userid': userid,
        }).then((value) => print("Event Added")).catchError((error) => print("Failed to add event: $error"));
 }

// List of Events
 List<EventData> _eventdataListFromSnapshot(QuerySnapshot snapshot) {
   return snapshot.documents.map((doc){
     return EventData(
       id: doc.documentID,
       eventname: doc.data['eventname'] ?? '',
       offer: doc.data['offer']['sdp'] ?? '',
      // answer: doc.data['answer'] ?? '',
       );
   }).toList();
 }



  Stream<List<EventData>> get events {
    return eventCollection.snapshots().map(_eventdataListFromSnapshot);
  }
//Eventdata from snapshot

EventData _eventDataFromSnapshot(DocumentSnapshot snapshot) {
  return EventData(
    id: uid,
    eventname: snapshot.data['eventname'],
    offer: snapshot.data['offer']['sdp'],
   // answer: snapshot.data['answer'],
    );
}

  Stream<EventData> get eventData { 
    return eventCollection.document(uid).snapshots().map(_eventDataFromSnapshot);
  }
}   
