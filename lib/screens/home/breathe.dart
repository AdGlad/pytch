import 'package:flutter/material.dart';
import 'dart:math';

class BreathPage extends StatefulWidget {
  @override
  _BreathPageState createState() => _BreathPageState();
}

class _BreathPageState extends State<BreathPage> with TickerProviderStateMixin{
  AnimationController _breathingController;
  var _breathe =0.0;

  @override
  void initState() { 
    super.initState();

      _breathingController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
        _breathingController.addStatusListener((status) {
          if(status == AnimationStatus.completed){
            _breathingController.reverse();

          } else if (status == AnimationStatus.dismissed){  
            _breathingController.forward();
          }
        });

        _breathingController.addListener(() {
          setState(() {
            _breathe =_breathingController.value;
          });
        });
        _breathingController.forward();

           }
      
  @override
  Widget build(BuildContext context) {
    final size = 300.0 -200.0 * _breathe;
    return Scaffold(
            appBar: AppBar(
        title: Text('Breathing Tool'),
        //backgroundColor: Colors.redAccent,
      ),
      body: Container (
        decoration: BoxDecoration(
            image: DecorationImage(
              //image: AssetImage('assets/pytchbg.png'),
              image: AssetImage('assets/breathebg.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        child: Center(
        child: Container(
          height: size,
          width:size,
          child: Material(
            borderRadius: BorderRadius.circular(size/100),
            color: Colors.white,
            child: 
              Image.asset('assets/icon.png')
            //ImageIcon(  
            //              new AssetImage(
             //                 "assets/icon.png"),
                          //size: 24.0, 
                         // color: Colors.white
             //            )
           // Icon(
           //   Icons.home,
           //   size:100,
           //   color:Colors.white,
           // ),

          ),
        ),
      ),
      ),
    );
  }
}