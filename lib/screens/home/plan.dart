
import 'package:flutter/material.dart';

class Plan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Plan'),
        //backgroundColor: Colors.redAccent,
      ),
             body: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Image(
                          image: AssetImage('assets/Plan.png'),
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