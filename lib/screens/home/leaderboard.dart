import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pytch/models/leader.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:hexcolor/hexcolor.dart';

class LeaderHomePage extends StatefulWidget {
  @override
  _LeaderHomePageState createState() {
    return _LeaderHomePageState();
  }
}

class _LeaderHomePageState extends State<LeaderHomePage> {
  List<charts.Series<Leader, String>> _seriesPieData;
  List<Leader> mydata;
  _generateData(mydata) {
    _seriesPieData = List<charts.Series<Leader, String>>();
    _seriesPieData.add(
      charts.Series(
        domainFn: (Leader leader, _) => leader.name,
        measureFn: (Leader leader, _) => leader.score,
        colorFn: (Leader leader, _) =>
           //charts.ColorUtil.fromDartColor(Colors.blue),
            charts.ColorUtil.fromDartColor(Color(int.parse(leader.colorVal))),
           //charts.ColorUtil.fromDartColor(Color(HexColor.fromHex('#aabbcc'))),
           //fromDartColor(Color(HexColor('#aabbcc')),
        id: 'leaders',
        data: mydata,
        labelAccessorFn: (Leader row, _) => "${row.score}",
      ),
    );
  }     
        
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Leaders')),
      body: Container( decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pytchbg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: _buildBody(context)),
    );
  } 
    Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('vapes').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<Leader> leader = snapshot.data.documents
              .map((documentSnapshot) => Leader.fromMap(documentSnapshot.data))
              .toList();
          return _buildChart(context, leader);
        }
      },
    );
  }
   Widget _buildChart(BuildContext context, List<Leader> leaderdata) {
    mydata = leaderdata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Leading Vapers',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.PieChart(_seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 5),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                            charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 2,
                        cellPadding:
                            new EdgeInsets.only(right: 4.0, bottom: 4.0,top:4.0),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 18),
                      )
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 100,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                              labelPosition: charts.ArcLabelPosition.inside)
                        ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}