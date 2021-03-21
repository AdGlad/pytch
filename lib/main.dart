import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pytch/models/user.dart';
import 'package:pytch/screens/wapper.dart';
import 'package:pytch/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Wrapper(),
      ),
    );
  }
}
