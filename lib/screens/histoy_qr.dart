import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellibe_proj/assets/wellibe_colors.dart';
import 'package:wellibe_proj/models/user.dart';
import 'package:wellibe_proj/qr_scanning_page.dart';
import 'package:wellibe_proj/screens/patients_page.dart';
import 'package:wellibe_proj/screens/view_page.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'package:wellibe_proj/services/database.dart';
import 'package:provider/provider.dart';

class HistoryQr extends StatelessWidget {
  const HistoryQr({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    var _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);
    // _data.updateDoctorData("סתם", "רעות", "עיניים של ילדים", "רופאת עיניים", "עברית, אנגלית", "שונאת חתולים", "r@gmail.com");
    print(_auth.getCurrentUser()?.uid);

    return MaterialApp(
        home: Scaffold(
          backgroundColor: AppColors.mainYellow,
            body: Center(
                child: Column(children: <Widget>[
                  Material(
                    color: AppColors.mainYellow,
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: FlatButton.icon(
                            padding: const EdgeInsets.only(top: 40),
                            icon: const Icon(Icons.person),
                            label: const Text('logout'),
                            onPressed: () async {
                              await _auth.signOut();
                              print("sign out");
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            iconSize: 30,
                            padding: const EdgeInsets.only(top: 40, left: 260),
                            icon: Image.network('https://www.shareicon.net/data/128x128/2015/09/24/106425_man_512x512.png'),//_auth.returnUrl()),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PatientsPage()));
                               },
                          ),
                        ),
                      ]
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 180),
                    child: FlatButton(
                      child: const Text(
                        'History',
                        style: TextStyle(fontSize: 40.0),
                      ),
                      textColor: Colors.black,
                      onPressed: () {
                        //_auth.getCurrentUser()?.updatePhotoURL('https://www.shareicon.net/data/128x128/2015/09/24/106425_man_512x512.png');
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewPage()));
                      },
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          offset: Offset(3, 2), // Shadow position
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(90),
                    child: FlatButton(
                      child: const Text(
                        'QR',
                        style: TextStyle(fontSize: 40.0),
                      ),
                      textColor: Colors.black,
                      onPressed: () {
                        //navigate to shakeds qr page
                        Navigator.push(context, MaterialPageRoute(builder: (context) => QRScanningPage()));

                      },
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          offset: Offset(3, 2), // Shadow position
                        ),
                      ],
                    ),
                  ),
                ]))
         ),
    );
  }
}






