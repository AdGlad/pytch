import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pytch/models/vape.dart';
import 'package:pytch/screens/home/vape_tile.dart';

class VapeList extends StatefulWidget {
  @override
  _VapeListState createState() => _VapeListState();
}

class _VapeListState extends State<VapeList> {
  @override
  Widget build(BuildContext context) {

    final vapes = Provider.of<List<Vape>>(context) ?? [];
    //print(vapes.documents);
    vapes.forEach((vape) { 
     print(vape.name);
     //print(vape.sex);
     //print(vape.dob);
     print(vape.strength);
     //print(vape.startdate);
     print(vape.frequency);
     //print(vape.dailyspend);
     //print(vape.whyquit);
    });
    
    return ListView.builder(
      itemCount: vapes.length,
      itemBuilder: (context,index){
        return VapeTile(vape: vapes[index]);
      },
      
    );
  }
}
