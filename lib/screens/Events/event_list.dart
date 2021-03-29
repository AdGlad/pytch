import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pytch/models/event.dart';
import 'package:pytch/screens/home/event_list.dart';
import 'package:pytch/services/db_event.dart';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<EventData>>.value(
          value: DbEventService().events,
          child:Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () => Navigator.of(context).pop(), 
            icon: Icon(Icons.home), 
            label: Text('Home'))
        ],
      ),
      body: Container(
           decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pytch_1125-1240.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: EventsList()
        ),
        )
    );
}
}