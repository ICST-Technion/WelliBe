import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:wellibe_proj/screens/authenticate/authenticate.dart';
import 'package:wellibe_proj/screens/histoy_qr.dart';
import 'package:wellibe_proj/screens/home/admin_home.dart';
import 'package:wellibe_proj/screens/patients_page.dart';
import 'package:wellibe_proj/screens/security.dart';
import 'package:wellibe_proj/screens/view_page.dart';
import 'package:wellibe_proj/models/user.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'package:wellibe_proj/services/database.dart';

import 'doctor_overview.dart';

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
  Widget build(BuildContext context) {
    final user = Provider.of<UserClass?>(context);
    if (user == null){
      return const Authenticate();
      //return sign in page.
    }else{
      return Security();
    }
  }
}
