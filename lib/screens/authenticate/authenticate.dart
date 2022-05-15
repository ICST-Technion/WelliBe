import 'package:flutter/material.dart';
import 'package:wellibe_proj/screens/authenticate/Login.dart';
import 'package:wellibe_proj/screens/authenticate/Register.dart';
import 'package:wellibe_proj/screens/authenticate/sign_in.dart';

//the the sign in and registration screen


class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate>{
  bool showSignIn = true;
  void toggleView() {
    setState(()=> showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return LoginScreen(toggleView: toggleView);
    }
    else{
      return RegisterScreen(toggleView: toggleView);
    }
  }
}
