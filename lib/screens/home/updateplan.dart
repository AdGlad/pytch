
import 'package:flutter/material.dart';
import 'package:pytch/screens/home/plan_form.dart';


class Updateplan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Plan '),
        //backgroundColor: Colors.redAccent,
      ),
             body: Container(
               decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pytchbg.png'),
              fit: BoxFit.cover,
            ),
          ),
                //margin: EdgeInsets.all(50),
                //margin: EdgeInsets.only(right: 100),
                //margin: EdgeInsets.only(top: 10),
                //margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                 child: 
                 Container( margin: EdgeInsets.all(50),
                 child: PlanForm() ),
              ),
            );
          }
        }