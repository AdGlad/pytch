import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

updatefirestore()
{
  print("heeellloooo");
var ref = Firestore.instance.document("data_collection/data");
ref.setData({
  "field": FieldValue.arrayUnion(["World"]),
});
  print("finish");
}

class testpage extends StatefulWidget {
  @override
  _testpageState createState() => _testpageState();
}

class _testpageState extends State<testpage> {
  @override
Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Woolha.com Flutter Tutorial'),
        ),
        body: Center(
          child: TextButton(
            child: Text('Woolha.com'),
            onPressed: () {
              updatefirestore();
            },
          ),
        ),
      );
}
}