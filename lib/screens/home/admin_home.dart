import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellibe_proj/assets/wellibe_colors.dart';

import 'package:wellibe_proj/screens/authenticate/authenticate.dart';
import 'package:wellibe_proj/screens/histoy_qr.dart';
import 'package:wellibe_proj/screens/hospitals_view/doctors_grid.dart';
import 'package:wellibe_proj/screens/patients_page.dart';
import 'package:wellibe_proj/screens/something_went_wrong.dart';
import 'package:wellibe_proj/screens/view_page.dart';
import 'package:wellibe_proj/models/user.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'package:wellibe_proj/services/database.dart';

import '../grid.dart';

//wraps the home screen and returns us back to sign in if logged out
class AdminHome extends StatefulWidget {

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    print(_auth.getCurrentUser()?.uid);
    Size size = MediaQuery.of(context).size;
    DatabaseService _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // remove back button in appbar.
        backgroundColor: AppColors.mainTeal,
        elevation: 0,
        title: Align(
          alignment: Alignment.centerRight,
          child: FlatButton(
            child: const Text('התנתק', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () async {
              await _auth.signOut();
              print("sign out");
              //Navigator.push(context, MaterialPageRoute(builder: (context) => Authenticate())); //NEED TO FIX THIS PROBLEM!

          },
          ),
        ),
      ),
      body: Container(
        color: AppColors.mainWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9), bottomRight: Radius.circular(9)),
                    color: AppColors.mainTeal,
                ),
                //padding: const EdgeInsets.all(30.0),
                //color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                              alignment: Alignment.center,
                              child: Container(
                                child: StreamBuilder<String>(
                                    stream: _data.getUrlInner(),
                                    builder: (context, snapshot) {
                                      if(snapshot.hasData){
                                        return GestureDetector(
                                          onTap: (){
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 50,
                                              backgroundColor: Colors.black,
                                              child: CircleAvatar(
                                                radius: 45,
                                                backgroundImage: NetworkImage(snapshot.data!),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return SomethingWentWrong();
                                    }
                                ),
                              )
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'שלום בית חולים,',
                                    style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.w700), //Colors.indigo.shade900),
                                    textAlign: TextAlign.justify,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                  ),
                                ]
                            ),
                          ),
                        ]
                    ),
                  ],
                ),
              ),
            ),

            Expanded (
              flex: 2,
                child: Container(
                  padding: EdgeInsets.all(20),
                  color: AppColors.mainWhite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        color: AppColors.mainWhite,
                        child: ElevatedButton(
                          onPressed: () {
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                              primary: Colors.white,
                              padding: const EdgeInsets.all(0)),
                          child: Container(
                            alignment: Alignment.center,
                            height: 60.0,
                            width: size.width,
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(80.0),
                              color: AppColors.buttonBlue,
                            ),
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              "הוספת רופא",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.mainWhite
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Container(
                        color: AppColors.mainWhite,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorsGrid()));
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                              primary: Colors.white,
                              padding: const EdgeInsets.all(0)),
                          child: Container(
                            alignment: Alignment.center,
                            height: 60.0,
                            width: size.width,
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(80.0),
                              color: AppColors.buttonBlue,
                            ),
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              "צפייה ברופאים",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.mainWhite
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Container(
                        color: AppColors.mainWhite,
                        child: ElevatedButton(
                          onPressed: () {
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                              primary: Colors.white,
                              padding: const EdgeInsets.all(0)),
                          child: Container(
                            alignment: Alignment.center,
                            height: 60.0,
                            width: size.width,
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(80.0),
                              color: AppColors.buttonBlue,
                            ),
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              "צפייה במטופלים",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.mainWhite
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //alignment: Alignment.topRight,
                )
            ),
          ],
        ),
      ),
    );
  }
}
