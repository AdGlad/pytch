import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pytch/screens/home/event_tile.dart';
import 'package:pytch/models/event.dart';

class EventsList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventsList> {
  @override
  Widget build(BuildContext context) {

    final events = Provider.of<List<EventData>>(context) ?? [];
    print(events);
    events.forEach((event) { 
     print('DDDDDDDDDDDDDDDDDDDD');
     print(event.id);
     print(event.eventname);
     print(event.offer);
     print(event.answer);
     print(event.candidate);
     print('DDDDDDDDDDDDDDDDDDDD');
    });
    
    return 
    ListView.builder(
      itemCount: events.length,
      itemBuilder: (context,index){
        return 
        EventDataTile(event: events[index]);
      },
    );
  }
}
