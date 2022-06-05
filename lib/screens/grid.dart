import 'package:flutter/material.dart';
import 'package:wellibe_proj/screens/authenticate/Login.dart';
import 'package:wellibe_proj/screens/authenticate/Register.dart';
import 'package:wellibe_proj/screens/authenticate/forgot_pass.dart';
import 'package:wellibe_proj/screens/authenticate/sign_in.dart';
import 'package:wellibe_proj/screens/home/admin_home.dart';

//the the sign in and registration screen


class Grid extends StatefulWidget {
  const Grid({Key? key}) : super(key: key);

  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
         automaticallyImplyLeading: false, // remove back button in appbar.

         title: Row(
         children: [
           IconButton(
             icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHome())); },
           ),
         ],
       )
     ),
   );
  }
}
