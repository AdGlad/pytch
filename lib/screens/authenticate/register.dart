import 'package:flutter/material.dart';
import 'package:pytch/services/auth.dart';
import 'package:pytch/shared/constants.dart';
//import 'package:pytch/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();

}

class _RegisterState extends State<Register> {
    final AuthService _auth = AuthService();
    final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error='';
  bool loading = false;
  @override


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text('Sign up for pytch'),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: (){
                widget.toggleView();
            } ,
            icon: Icon(Icons.person), 
            label: Text('Sign In')),
        ],
      ),
      body: Container(
                decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pytch_1125-1240.png'),
              fit: BoxFit.cover,
            ),
          ),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: textInputDecoration.copyWith(hintText: 'Email',),
                //validator: (val) => val.isEmpty ? 'Enter Email' : null,
                onChanged: (val) {
                  setState(() => email=val);
                }
              ),            
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password',),
                //validator: (val) => val.length < 6 ? 'Enter a password 6+ chars' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password=val);
                }
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate())
                  {
                    setState(() => loading = true);
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                    if (result==null) {
                      setState(() {
                        error = 'Supply valid email ';
                        loading = false;
                      });
                    }
                  }
                }
                ),
                SizedBox(height: 12.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
            ],
          )
          )
      ),
    );
  }
}