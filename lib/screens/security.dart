
import 'package:flutter/cupertino.dart';
import 'package:wellibe_proj/screens/home/admin_home.dart';
import 'package:wellibe_proj/screens/something_went_wrong.dart';
import 'package:wellibe_proj/screens/view_page.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'package:wellibe_proj/services/database.dart';
import 'package:wellibe_proj/screens/card_viewer.dart';
import '../assets/wellibe_colors.dart';
import 'authenticate/Login.dart';
import 'doctor_overview.dart';


class Security extends StatefulWidget {
  const Security({Key? key}) : super(key: key);

  @override
  _Security createState() => _Security();
}

//wraps the home screen and returns us back to sign in if logged out
class _Security extends State<Security> {
  AuthService _auth = AuthService();
  int showSignIn = 1;
  void toggleView(int nextView) {
    if(nextView >= 1 || nextView <= 3)
      setState(()=> showSignIn = nextView);
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);
    print(_auth.getCurrentUser()?.uid);
    return StreamBuilder(
        stream: _data.getRoleInner(),
        builder: (context, snapshot) {
          //better to retrieve ALL data here at once and then send to the pages.....
          if(snapshot.hasData) {
            print(snapshot.data);
            if(snapshot.data == 'user'){
              print("user");
              return ViewPage();
            }
            if(snapshot.data == 'doctor'){
              print("doctor");
              return StreamBuilder(
                  stream: _data.getEmailInner(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return CardViewer(email: snapshot.data as String);
                    }
                    return Container(
                      color: AppColors.mainWhite,
                      child: Center(
                        child: SomethingWentWrong(),
                      ),
                    );                  }
                  );
            }
            else{
              print("admin");
              return AdminHome();
            }
          }
          //return LoginScreen(toggleView: toggleView, error: 'לא קיים משתמש כזה');
          return Center(child: SomethingWentWrong());
        }
    );
  }
}
