import 'package:flutter/material.dart';
import 'package:pytch/models/event.dart';
class EventDataTile extends StatelessWidget {
  final EventData event;
  EventDataTile({this.event});

  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundImage: AssetImage('assets/atomizer.png'),
            ),
            title: Text(event.eventname ,
                 style: TextStyle(
                 fontSize: 15,
                 fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
            ), 
            subtitle: Text('Event ${event.eventname}.'),
            ),
            )
      );
  }
}
