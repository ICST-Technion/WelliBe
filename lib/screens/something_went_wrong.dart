import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:wellibe_proj/assets/wellibe_colors.dart';

import 'package:wellibe_proj/screens/authenticate/authenticate.dart';
import 'package:wellibe_proj/screens/histoy_qr.dart';
import 'package:wellibe_proj/screens/patients_page.dart';
import 'package:wellibe_proj/screens/something_went_wrong.dart';
import 'package:wellibe_proj/screens/view_page.dart';
import 'package:wellibe_proj/models/user.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'package:wellibe_proj/services/database.dart';

//wraps the home screen and returns us back to sign in if logged out
class SomethingWentWrong extends StatefulWidget {

  @override
  State<SomethingWentWrong> createState() => _SomethingWentWrong();
}

class _SomethingWentWrong extends State<SomethingWentWrong> {
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    DatabaseService _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);
    return Container(
        color: Colors.transparent,
        child: CircularProgressIndicator(
          value: 0.8,
        ),
    );
  }
}
