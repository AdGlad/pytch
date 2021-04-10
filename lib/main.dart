import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pytch/screens/home/testpage.dart';
import 'screens/wapper.dart';
import 'services/auth.dart';
import 'models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocal>.value(
      value: AuthService().user,
          child: MaterialApp(
            theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
            debugShowCheckedModeBanner: false,
            home: Wrapper(),
            //home: TestPage(),
      ),
    );
  }
}
