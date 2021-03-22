import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pytch/screens/home/user_tile.dart';
import 'package:pytch/models/user.dart';

class VapeList extends StatefulWidget {
  @override
  _VapeListState createState() => _VapeListState();
}

class _VapeListState extends State<VapeList> {
  @override
  Widget build(BuildContext context) {

    final users = Provider.of<List<UserData>>(context) ?? [];
    users.forEach((user) { 
     print(user.firstname);
     print(user.lastname);
     print(user.nickname);
    });
    
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context,index){
        return UserDataTile(user: users[index]);
      },
      
    );
  }
}
