import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:wellibe_proj/screens/authenticate/authenticate.dart';
import 'package:wellibe_proj/screens/histoy_qr.dart';
import 'package:wellibe_proj/screens/patients_page.dart';
import 'package:wellibe_proj/screens/view_page.dart';
import 'package:wellibe_proj/models/user.dart';

//wraps the home screen and returns us back to sign in if logged out
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserClass?>(context);
    if (user == null){
      return const Authenticate();
      //return sign in page.
    }else{
      return ViewPage();
    }
  }
}
