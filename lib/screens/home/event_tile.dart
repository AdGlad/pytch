import 'package:flutter/material.dart';
import 'package:pytch/models/event.dart';
import 'package:pytch/screens/home/listen.dart';
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
          //onTap: () {print('Heeellllllo');},
          onTap: () {
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => Listen(title: 'Pytch',event: event)));
          },
          leading: CircleAvatar(
            radius: 25.0,
            backgroundImage: AssetImage('assets/icon.png'),
            ),
            title: Text(event.eventname ,
                 style: TextStyle(
                 fontSize: 15,
                 fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
            ), 
            subtitle: Text('Event ${event.id}.'),
            ),
            )
      );
  }
}
