import 'package:flutter/material.dart';
import 'package:pytch/models/user.dart';
class UserDataTile extends StatelessWidget {
  final UserData user;
  UserDataTile({this.user});

  
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
            title: Text(user.firstname ,
                 style: TextStyle(
                 fontSize: 15,
                 fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
            ), 
            subtitle: Text('Nickname ${user.nickname}.'),
            ),
            )
      );
  }
}
