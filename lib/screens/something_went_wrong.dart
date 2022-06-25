import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//wraps the home screen and returns us back to sign in if logged out
class SomethingWentWrong extends StatefulWidget {

  @override
  State<SomethingWentWrong> createState() => _SomethingWentWrong();
}

class _SomethingWentWrong extends State<SomethingWentWrong> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: CircularProgressIndicator(
          value: 0.8,
        ),
    );
  }
}
