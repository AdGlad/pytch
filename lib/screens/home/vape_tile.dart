import 'package:flutter/material.dart';
import 'package:pytch/models/vape.dart';

class VapeTile extends StatelessWidget {
  final Vape vape;
  VapeTile({this.vape});

  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.blue[vape.strength],
            backgroundImage: AssetImage('assets/atomizer.png'),
            ),
            title: Text(vape.name ,
                 style: TextStyle(
                 fontSize: 15,
                 fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
            ), 
            subtitle: Text('Started vaping on ${vape.startdate}. Spends \$${vape.dailyspend} a day and vapes about ${vape.frequency} times daily. ${vape.whyquit} is my motivation to quit'),
            ),
            )
      );
  }
}
