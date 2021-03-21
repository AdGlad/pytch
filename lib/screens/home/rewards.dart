
import 'package:flutter/material.dart';

class Rewards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rewards'),
        //backgroundColor: Colors.redAccent,
      ),
             body: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Image(
                          image: AssetImage('assets/Rewards.png'),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }