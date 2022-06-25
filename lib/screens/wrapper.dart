import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wellibe_proj/screens/authenticate/authenticate.dart';
import 'package:wellibe_proj/screens/security.dart';
import 'package:wellibe_proj/screens/something_went_wrong.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'package:wellibe_proj/services/database.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _Wrapper createState() => _Wrapper();
}

AuthService _auth = AuthService();
DatabaseService _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);
//wraps the home screen and returns us back to sign in if logged out
class _Wrapper extends State<Wrapper> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Security();
        }
        else{
          return Authenticate();
        }
      },
    ),
  );
}
