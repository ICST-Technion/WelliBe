// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:wellibe_proj/screens/hospitals_view/doctors_grid.dart';
import 'package:wellibe_proj/screens/something_went_wrong.dart';
import 'package:wellibe_proj/services/database.dart';
import 'package:wellibe_proj/assets/wellibe_colors.dart';
import 'package:wellibe_proj/screens/qr_scanning_page.dart';
import 'package:wellibe_proj/services/auth.dart';
import '../view_page.dart';

final AuthService _auth = AuthService();

class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TestAdminHome(),
    );
  }
}

class TestAdminHome extends StatefulWidget {
  const TestAdminHome({Key? key}) : super(key: key);
  @override
  _TestAdminHome createState() => _TestAdminHome();
}

class _TestAdminHome extends State<TestAdminHome> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DatabaseService _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);
    String? img = 'https://image.shutterstock.com/image-vector/profile-photo-vector-placeholder-pic-600w-535853263.jpg';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainTeal,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
              child: const Text('התנתק', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () async {
                await _auth.signOut();
                print("sign out");
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Container(
              height: size.height * 0.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9), bottomRight: Radius.circular(9)),
                  color: AppColors.mainTeal
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                Text(
                                  'שלום,',
                                  style: TextStyle(fontSize: 20.0, color: Colors.black), //Colors.indigo.shade900),
                                  textAlign: TextAlign.justify,
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  'בית חולים',
                                  style: TextStyle(fontSize: 20.0, color: Colors.black), //Colors.indigo.shade900),
                                  textAlign: TextAlign.justify,
                                  textDirection: TextDirection.rtl,
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                              ]
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.only(right: 15),
                              child: StreamBuilder<String>(
                                  stream: _data.getUrlInner(),
                                  builder: (context, snapshot) {
                                    if(snapshot.hasData) {
                                      img = snapshot.data;
                                    }
                                    else{
                                      return SomethingWentWrong();
                                    }
                                    return GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorsGrid()));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.black,
                                          child: CircleAvatar(
                                            radius: 45,
                                            backgroundImage: NetworkImage(img!),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            )
                        ),
                      ]
                  ),
                ],
              ),
            ),
            Expanded (
                child: Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
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






// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:wellibe_proj/assets/wellibe_colors.dart';
//
// import 'package:wellibe_proj/screens/authenticate/authenticate.dart';
// import 'package:wellibe_proj/screens/histoy_qr.dart';
// import 'package:wellibe_proj/screens/hospitals_view/doctors_grid.dart';
// import 'package:wellibe_proj/screens/patients_page.dart';
// import 'package:wellibe_proj/screens/something_went_wrong.dart';
// import 'package:wellibe_proj/screens/view_page.dart';
// import 'package:wellibe_proj/models/user.dart';
// import 'package:wellibe_proj/services/auth.dart';
// import 'package:wellibe_proj/services/database.dart';
//
// import '../grid.dart';
//
// //wraps the home screen and returns us back to sign in if logged out
// class AdminHome extends StatefulWidget {
//
//   @override
//   State<AdminHome> createState() => _AdminHomeState();
// }
//
// class _AdminHomeState extends State<AdminHome> {
//   AuthService _auth = AuthService();
//
//   @override
//   Widget build(BuildContext context) {
//     print(_auth.getCurrentUser()?.uid);
//     Size size = MediaQuery.of(context).size;
//     DatabaseService _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);
//     return Scaffold(
//       appBar: AppBar(
//         //automaticallyImplyLeading: false,
//         backgroundColor: AppColors.mainTeal,
//         elevation: 0,
//         title: FlatButton(
//           child: const Text('התנתק', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           onPressed: () async {
//             await _auth.signOut();
//             print("sign out");
//           },
//         ),
//       ),
//       body: Container(
//         color: AppColors.mainWhite,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget> [
//             Expanded(
//               flex: 1,
//               child: Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9), bottomRight: Radius.circular(9)),
//                     color: AppColors.mainTeal,
//                 ),
//                 //padding: const EdgeInsets.all(30.0),
//                 //color: Colors.white,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         //crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Align(
//                               alignment: Alignment.center,
//                               child: Container(
//                                 child: StreamBuilder<String>(
//                                     stream: _data.getUrlInner(),
//                                     builder: (context, snapshot) {
//                                       if(snapshot.hasData){
//                                         return GestureDetector(
//                                           onTap: (){
//                                           },
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: CircleAvatar(
//                                               radius: 50,
//                                               backgroundColor: Colors.black,
//                                               child: CircleAvatar(
//                                                 radius: 45,
//                                                 backgroundImage: NetworkImage(snapshot.data!),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       }
//                                       return CircularProgressIndicator();
//                                     }
//                                 ),
//                               )
//                           ),
//                           Align(
//                             alignment: Alignment.center,
//                             child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     'שלום בית חולים,',
//                                     style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.w700), //Colors.indigo.shade900),
//                                     textAlign: TextAlign.justify,
//                                     textDirection: TextDirection.rtl,
//                                   ),
//                                   const Padding(
//                                     padding: EdgeInsets.only(bottom: 10),
//                                   ),
//                                 ]
//                             ),
//                           ),
//                         ]
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             Expanded (
//               flex: 2,
//                 child: Container(
//                   padding: EdgeInsets.all(20),
//                   color: AppColors.mainWhite,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Container(
//                         color: AppColors.mainWhite,
//                         child: ElevatedButton(
//                           onPressed: () {
//                           },
//                           style: ElevatedButton.styleFrom(
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
//                               primary: Colors.white,
//                               padding: const EdgeInsets.all(0)),
//                           child: Container(
//                             alignment: Alignment.center,
//                             height: 60.0,
//                             width: size.width,
//                             decoration: new BoxDecoration(
//                               borderRadius: BorderRadius.circular(80.0),
//                               color: AppColors.buttonBlue,
//                             ),
//                             padding: const EdgeInsets.all(0),
//                             child: Text(
//                               "הוספת רופא",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.mainWhite
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(padding: EdgeInsets.all(5)),
//                       Container(
//                         color: AppColors.mainWhite,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorsGrid()));
//                           },
//                           style: ElevatedButton.styleFrom(
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
//                               primary: Colors.white,
//                               padding: const EdgeInsets.all(0)),
//                           child: Container(
//                             alignment: Alignment.center,
//                             height: 60.0,
//                             width: size.width,
//                             decoration: new BoxDecoration(
//                               borderRadius: BorderRadius.circular(80.0),
//                               color: AppColors.buttonBlue,
//                             ),
//                             padding: const EdgeInsets.all(0),
//                             child: Text(
//                               "צפייה ברופאים",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.mainWhite
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(padding: EdgeInsets.all(5)),
//                       Container(
//                         color: AppColors.mainWhite,
//                         child: ElevatedButton(
//                           onPressed: () {
//                           },
//                           style: ElevatedButton.styleFrom(
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
//                               primary: Colors.white,
//                               padding: const EdgeInsets.all(0)),
//                           child: Container(
//                             alignment: Alignment.center,
//                             height: 60.0,
//                             width: size.width,
//                             decoration: new BoxDecoration(
//                               borderRadius: BorderRadius.circular(80.0),
//                               color: AppColors.buttonBlue,
//                             ),
//                             padding: const EdgeInsets.all(0),
//                             child: Text(
//                               "צפייה במטופלים",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.mainWhite
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   //alignment: Alignment.topRight,
//                 )
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
