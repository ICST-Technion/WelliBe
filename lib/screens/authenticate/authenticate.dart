import 'package:flutter/material.dart';
import 'package:wellibe_proj/screens/authenticate/sign_in.dart';

//the the sign in and registration screen


class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate>{
  @override
  Widget build(BuildContext context) {
    return const SignIn();
  }
}
