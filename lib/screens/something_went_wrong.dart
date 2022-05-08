import 'package:flutter/material.dart';
import 'package:wellibe_proj/screens/authenticate/sign_in.dart';

//the the sign in and registration screen


class SomethingWentWrong extends StatefulWidget {
  @override
  _SomethingWentWrongState createState() => _SomethingWentWrongState();
}


class _SomethingWentWrongState extends State<SomethingWentWrong>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('something went wrong', textDirection: TextDirection.ltr,),
    );
  }
}
