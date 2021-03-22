
import 'package:flutter/material.dart';
import 'NewsListView.dart';

class Broadcast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Broadcast'),
        //backgroundColor: Colors.redAccent,
      ),
        body: 
        Container( 
            decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pytch_1125-1240.png'),
              fit: BoxFit.cover,
            ),
          ),
            child: Center(
               child: NewsListView()
              )
              ),
      );
      }
    }

 