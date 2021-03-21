import 'package:provider/provider.dart';
import 'package:pytch/models/user.dart';
import 'package:pytch/services/database.dart';
import 'package:pytch/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pytch/shared/loading.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class PlanForm extends StatefulWidget {
  @override
  _PlanFormState createState() => _PlanFormState();
}


class _PlanFormState extends State<PlanForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> hungerTip = ['Snack Bar','Chew Gum', 'Drink Water','Exercise','Other' ];
  final List<String> stressTip = ['Laugh','Chew Gum','Exercise','Write Journal', 'Take timeout' ];
  final List<String> boredomTip = ['New Hobbie','Read','Crossword','Team Sport', 'Binge Watch', 'New Challenge' ];
  final List<String> alcoholTip = ['Avoid Pub','Alcohol-free days','Exercise','Take-up Sport', 'Have A Soft Drink' ];
  final List<String> drivingTip = ['Chew Gum', 'Listen To Music', 'Nicotine Patch', 'Have A Soft Drink', 'Drink Water', 'Drive slowly'];
  final List<String> cravingTip = ['Chew Gum', 'Nicotine Patch', 'Write Journal', 'Think positively', 'Chocolate'];
    final List<String> justthereTip = ['Meditation','Chew Gum', 'Nicotine Patch', 'Write Journal', 'Think positively', 'Chocolate'];

  String _currentName;
  String _currentSex; 
  String _currentDob;
  int _currentStrength;
  String _currentWhyquit;
  int _currentDailyspend;
  String _currentStartdate;
  int _currentFrequency;
  String _currentcolorVal;

  String _currenthunger;
  String _currentstress;
  String _currentboredom;
  String _currentalcohol;
  String _currentdriving;
  String _currentcraving;
  String _currentjustthere;

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);


    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          UserData userData = snapshot.data;
          return Form(
                    key: _formKey,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget> [
                        Center( 
                          child: Text(
                          'Your Plan',
                          style: TextStyle(fontSize: 28.0),
                        ),
                        ),
                        Text(
                          'Triggers and Tips',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(height: 5),
                          DropdownButtonFormField(
                            value: _currenthunger?? userData.hunger,
                            decoration: InputDecoration(
                                labelText: 'Hunger trigger plan'
                               ),
                            items: hungerTip.map((hungerTip) {
                              return DropdownMenuItem(
                                value: hungerTip,
                                child: Center( child: Text('$hungerTip', style: TextStyle(fontSize: 14.0))),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _currenthunger = val ),
                          ),
                        SizedBox(height: 5.0),
                                                DropdownButtonFormField(
                            value: _currentstress ?? userData.stress,
                            decoration: InputDecoration(
                                labelText: 'Stress trigger plan'
                               ),
                            items: stressTip.map((stressTip) {
                              return DropdownMenuItem(
                                value: stressTip,
                                child: Text('$stressTip', style: TextStyle(fontSize: 14.0)),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _currentstress= val ),
                          ),
                        SizedBox(height: 5.0),
                                                DropdownButtonFormField(
                            value: _currentboredom ?? userData.boredom,
                            decoration: InputDecoration(
                                labelText: 'Boredom trigger plan'
                               ),
                            items: boredomTip.map((boredomTip) {
                              return DropdownMenuItem(
                                value: boredomTip,
                                child: Text('$boredomTip', style: TextStyle(fontSize: 14.0)),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _currentboredom = val ),
                          ),
                        SizedBox(height: 5.0),
                                                DropdownButtonFormField(
                            value: _currentalcohol ?? userData.alcohol,
                            decoration: InputDecoration(
                                labelText: 'Alcohol trigger plan'
                               ),
                            items: alcoholTip.map((alcoholTip) {
                              return DropdownMenuItem(
                                value: alcoholTip,
                                child: Text('$alcoholTip', style: TextStyle(fontSize: 14.0)),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _currentalcohol = val ),
                          ),
                        SizedBox(height: 5.0),
                                                DropdownButtonFormField(
                            value: _currentdriving ?? userData.driving,
                            decoration: InputDecoration(
                                labelText: 'Driving trigger plan'
                               ),
                            items: drivingTip.map((drivingTip) {
                              return DropdownMenuItem(
                                value: drivingTip,
                                child: Text('$drivingTip', style: TextStyle(fontSize: 14.0)),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _currentdriving = val ),
                          ),
                         SizedBox(height: 5.0),
                                                DropdownButtonFormField(
                            value: _currentcraving ?? userData.craving,
                            decoration: InputDecoration(
                                labelText: 'Craving trigger plan'
                               ),
                            items: cravingTip.map((cravingTip) {
                              return DropdownMenuItem(
                                value: cravingTip,
                                child: Text('$cravingTip', style: TextStyle(fontSize: 14.0)),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _currentcraving = val ),
                          ),
                          SizedBox(height: 5.0),
                          DropdownButtonFormField(
                            value: _currentjustthere ?? userData.justthere,
                            decoration: InputDecoration(
                                labelText: 'Enter you plan for justthere'
                               ),
                            items: justthereTip.map((justthereTip) {
                              return DropdownMenuItem(
                                value: justthereTip,
                                child: Text('$justthereTip', style: TextStyle(fontSize: 14.0)),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _currentjustthere = val ),
                          ),
                        SizedBox(height: 5.0),
                        RaisedButton(
                          color: Colors.pink[400],
                          child: Text(
                            'Update Plan',
                            style: TextStyle(color: Colors.white),
                          ),
                          
                          onPressed: () async {
                            if(_formKey.currentState.validate()){
                              await DatabaseService(uid: user.uid).updateUserData(
                               _currentName ?? snapshot.data.name, 
                                _currentSex ?? snapshot.data.sex, 
                                _currentDob ?? snapshot.data.dob,     
                                _currentStrength ?? snapshot.data.strength, 
                                _currentWhyquit ?? snapshot.data.whyquit, 
                                _currentDailyspend ?? snapshot.data.dailyspend,                                 
                                _currentStartdate ?? snapshot.data.startdate, 
                                _currentFrequency ?? snapshot.data.frequency,
                                _currentcolorVal ?? snapshot.data.colorVal,
                                 _currenthunger ?? snapshot.data.hunger,
                                _currentstress ?? snapshot.data.stress,
                                _currentboredom ?? snapshot.data.boredom,
                                _currentalcohol ?? snapshot.data.alcohol,
                                _currentdriving ?? snapshot.data.driving,
                                _currentcraving ?? snapshot.data.craving,
                                _currentjustthere ?? snapshot.data.justthere
                              );
                              Navigator.pop(context);
                                              }
                  }
                ),
              ],
            ),
          );
        } else {
          return Loading();
        }
      }
    );
  }
}