import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellibe_proj/services/auth.dart';

import '../../services/database.dart';
import '../histoy_qr.dart';

//the screen after you've already signed in once...
//history_qr is my home screen!

class Home extends StatelessWidget {
  final db = FirebaseFirestore.instance;
  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
      return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return Center(
            child: StreamBuilder<DocumentSnapshot>(
                stream: db.collection('users').doc(_auth.getCurrentUser()?.uid).snapshots(),
                builder: (context, snapshot){
                    Map data = snapshot.data?.data as Map;
                    return Container(
                        child: HistoryQr(),
                    );
                }
                )
          );
        }
      );
    }
}
