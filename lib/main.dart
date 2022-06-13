import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:wellibe_proj/screens/wrapper.dart';
import 'package:wellibe_proj/screens/something_went_wrong.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyA_Zdp072BLLclZQEcY6ADwuLRcUx4IFEI",
          appId: "1:262208643994:android:732fbe638a0b7d5d7d5023",
          projectId: "industrial-01",
          messagingSenderId: '262208643994',
          storageBucket: 'gs://industrial-01.appspot.com',
        ),
    ),
      builder: (context, snapshot) {
        // Check for errors
          if (snapshot.hasError) {
            return Center(child: SomethingWentWrong());
          }
          else if (!snapshot.hasData){
            return Center(child: SomethingWentWrong());
          }
          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              home: Wrapper(),
            );
          }
          // Otherwise, show something whilst waiting for initialization to complete
          return Center(child: SomethingWentWrong());
      }
    );

  }
}