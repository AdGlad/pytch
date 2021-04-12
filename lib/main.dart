import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pytch/screens/home/testpage.dart';
import 'screens/wapper.dart';
import 'services/auth.dart';
import 'models/user.dart';
import 'package:firebase_core/firebase_core.dart';

void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  
  // @override
  // void initState() {
  //   Firebase.initializeApp().whenComplete(() { 
  //     print("completed");
  //    // setState(() {});
  //   });
  //   super.initState();

  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
    child: new FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
         // show loading while waiting for real data
        return CircularProgressIndicator();
     }
        // Check for errors
        if (snapshot.hasError) {
          print('SomethingWentWrong()');
       //   return print('SomethingWentWrong()');
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          
          return StreamProvider<UserLocal>.value(
      value: AuthService().user,
          child: MaterialApp(
            theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
            debugShowCheckedModeBanner: false,
            home: Wrapper(),
           // home: TestPage(),
              )    // 
      ); //Value

        } //if
        } //builder
    ) //FutureBuilder
    );
    } //Widget
} //class
