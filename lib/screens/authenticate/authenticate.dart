import 'package:flutter/material.dart';

import 'package:wellibe_proj/screens/authenticate/Login.dart';
import 'package:wellibe_proj/screens/authenticate/Register.dart';
import 'package:wellibe_proj/screens/authenticate/forgot_pass.dart';

// the first screen users see when they enter the app
class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate>{
  int showSignIn = 1;

  // toggle views between the sign-in page, sign-up page, and forgot-password page
  void toggleView(int nextView) {
    if(nextView >= 1 || nextView <= 3)
      setState(()=> showSignIn = nextView);
  }


  @override
  Widget build(BuildContext context) {
    if(showSignIn == 1){
      return LoginScreen(toggleView: toggleView);
    }
    if(showSignIn == 2){
      return RegisterScreen(toggleView: toggleView);
    }
    else{
      return ForgotPassScreen(toggleView: toggleView);
    }
  }
}
