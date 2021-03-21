import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pytch/services/auth.dart';
import 'package:pytch/shared/constants.dart';
import 'package:pytch/shared/loading.dart';


class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
_SignInState createState() => _SignInState();

}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = '';
  String password = '';
  String error='';
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text('Sign in to pytch'),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: (){
              widget.toggleView();
            } ,
            icon: Icon(Icons.person), 
            label: Text('Sign-in')),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/signin.png'),
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
                decoration: textInputDecoration.copyWith(hintText: 'Email',),
                validator: (val) => val.isEmpty ? 'Enter Email' : null,
                onChanged: (val) {
                  setState(() => email=val); 
                } 
              ),            
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password',),
                validator: (val) => val.length < 6 ? 'Enter a password 6+ chars' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password=val);
                }
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Sign in',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                if (_formKey.currentState.validate())
                  {
                    setState(() => loading = true);
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if (result==null) {
                      setState(() {
                      error = 'Could not sign into pytch with credentials ';
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