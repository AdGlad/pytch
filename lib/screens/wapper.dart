import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pytch/models/user.dart';
import 'package:pytch/screens/home/home.dart';
import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserLocal>(context);
    print(user);
    if (user == null) {
       return Authenticate();
    } 
    else {
       return Home();
    }

  }

}
