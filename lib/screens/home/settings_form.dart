import 'package:provider/provider.dart';
import 'package:pytch/models/user.dart';
import 'package:pytch/services/db_user.dart';
import 'package:flutter/material.dart';
import 'package:pytch/shared/loading.dart';


class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}


class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  String _currentfirstname;
  String _currentlastname;
  String _currentnickname;
  String _currentsex; 

  @override
  Widget build(BuildContext context) {
  UserLocal user = Provider.of<UserLocal>(context);
    return StreamBuilder<UserData>(
      stream: DbUserService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          UserData userData = snapshot.data;
          return Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget> [
                        Text(
                          'Update your user settings.',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          style: TextStyle(fontSize: 14.0),
                          initialValue: userData.firstname,
                          decoration: InputDecoration(
                               labelText: 'Enter your firstname',
                              ),
                          validator: (val) => val.isEmpty ? 'Please enter a firstname' : null,
                          onChanged: (val) => setState(() => _currentfirstname = val),
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          style: TextStyle(fontSize: 14.0),
                          initialValue: userData.lastname,
                          decoration: InputDecoration(
                               labelText: 'Please enter a lastname',
                              ),
                          validator: (val) => val.isEmpty ? 'Please enter a lastname' : null,
                          onChanged: (val) => setState(() => _currentlastname = val),
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          style: TextStyle(fontSize: 14.0),
                          initialValue: userData.lastname,
                          decoration: InputDecoration(
                               labelText: 'Please enter a nickname',
                              ),
                          validator: (val) => val.isEmpty ? 'Please enter a nickname' : null,
                          onChanged: (val) => setState(() => _currentnickname = val),
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          style: TextStyle(fontSize: 14.0),
                          initialValue: userData.lastname,
                          decoration: InputDecoration(
                               labelText: 'Please enter sex (Optional)',
                              ),
                          validator: (val) => val.isEmpty ? 'Please enter sex' : null,
                          onChanged: (val) => setState(() => _currentsex = val),
                        ),
                        SizedBox(height: 2.0),
                        TextButton(
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if(_formKey.currentState.validate()){
                              await DbUserService(uid: user.uid).updateUserData(
                                _currentfirstname ?? snapshot.data.firstname, 
                                _currentlastname ?? snapshot.data.lastname, 
                                _currentnickname ?? snapshot.data.nickname, 
                                _currentsex ?? snapshot.data.sex, 
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