import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:intl/date_symbol_data_http_request.dart';
import 'package:wellibe_proj/models/user.dart';
import 'package:wellibe_proj/screens/something_went_wrong.dart';
import 'package:provider/provider.dart';
import 'package:wellibe_proj/screens/view_page.dart';
import 'package:wellibe_proj/screens/wrapper.dart';
import 'package:wellibe_proj/services/auth.dart';
//import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbol_data_local.dart';

void main(){initializeDateFormatting().then((_) => runApp(const MyApp()));}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<UserClass?>.value(
            initialData: null,
            value: AuthService().user,
            child: MaterialApp(
              home: Wrapper(),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return SomethingWentWrong();
      },
    );

  }
}