//sign in page
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wellibe_proj/services/auth.dart';

//sign in anonymously. needs to be changed to proper sign in.
class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}


class _SignInState extends State<SignIn>{
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String pass = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          backgroundColor: Colors.brown[50],
          elevation: 0.0,
          title: Text('sign in to WelliBe'),
        ),
        body: Container(
          child: Column(
            children: [
              RaisedButton(
                  child: Text('Sign in anon'),
                  onPressed: () async{
                    dynamic result = await _auth.signInAnon();
                    if (result == null){
                      print('error signing in');
                    }
                    else{
                      print('signed in');
                      print(result.uid);
                    }
                  }
              ),
              Form(
                key: _formKey, //key for validation of form.
                child: Column(
                  children: <Widget> [
                    SizedBox(height: 20.0),
                    TextFormField(
                      onChanged: (val) {
                        setState(() => email=val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => pass=val);
                      },
                    ),
                    RaisedButton(
                      color: Colors.red,
                      child: Text("register"),
                      onPressed: () async {
                        dynamic result = await _auth.registerWithEmailAndPassword(email, pass);

                        },
                    )
                  ],
                )

              )
            ],
          )

        ),
      ),
    );
  }
}
