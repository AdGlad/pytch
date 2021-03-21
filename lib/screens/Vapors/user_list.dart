import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pytch/models/vape.dart';
import 'package:pytch/screens/home/vape_list.dart';
import 'package:pytch/services/database.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Vape>>.value(
          value: DatabaseService().vapes,
          child:Scaffold(
      appBar: AppBar(
        title: const Text('Vepos Users'),
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
              image: AssetImage('assets/pytchbg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: VapeList()
        ),
        )
    );
}
}