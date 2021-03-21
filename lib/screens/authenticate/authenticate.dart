import 'package:flutter/material.dart';
import 'package:pytch/screens/authenticate/register.dart';
import 'package:pytch/screens/authenticate/sign_in.dart';
  
class Authenticate extends  StatefulWidget{

_AuthenticateState createState() =>  _AuthenticateState();

}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState( () => showSignIn = !showSignIn);
  }

  Widget build(BuildContext context) {


    if (showSignIn) {
       return  Register(toggleView: toggleView);
    } else
    {
        return SignIn(toggleView: toggleView);
    }
  }
}