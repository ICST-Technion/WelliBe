import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wellibe_proj/assets/wellibe_colors.dart';
import 'package:wellibe_proj/screens/doctor_overview.dart';
import 'package:wellibe_proj/screens/home/admin_home.dart';
import 'package:wellibe_proj/screens/something_went_wrong.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'package:wellibe_proj/services/database.dart';
import 'hospital_doctor_overview.dart';


class DoctorsGrid extends StatefulWidget {
  const DoctorsGrid({Key? key}) : super(key: key);

  @override
  _DoctorsGridState createState() => _DoctorsGridState();
}

AuthService _auth = AuthService();


//wraps the home screen and returns us back to sign in if logged out
class _DoctorsGridState extends State<DoctorsGrid> {
  final Future<List> dlist = DatabaseService(uid: _auth.getCurrentUser()?.uid).getDocs();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9), bottomRight: Radius.circular(9)),
                color: AppColors.mainTeal,
              ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back), onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHome())); },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Center(
                                child: Text("רשימת רופאים",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9), bottomRight: Radius.circular(9)),
                                color: AppColors.mainTeal,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
            Expanded(
              flex: 4,
              child: Container(
                color: AppColors.mainWhite,
                child: FutureBuilder(
                  future: dlist,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return Container(
                          padding: EdgeInsets.all(12.0),
                          child: GridView.builder(
                            itemCount: (snapshot.data as List).length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 2.0,
                                mainAxisSpacing: 2.0
                            ),
                            itemBuilder: (BuildContext context, int index){
                              print((snapshot.data as List)[index]);
                              return DoctorsBox(key: Key(DateTime.now().toLocal().toString()), arr: (snapshot.data as List)[index]);
                              // return DoctorsList(key: Key(DateTime.now().toLocal().toString()), counter: index, arr: lst[index]);
                            },
                          ));
                    }
                    return Center(child: SomethingWentWrong());
                  },
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}



class DoctorsBox extends StatefulWidget {
  final arr;
  DoctorsBox({required Key key, required this.arr}) : super(key: key);

  @override
  _DoctorsBoxState createState() => _DoctorsBoxState(arr);
}

class _DoctorsBoxState extends State<DoctorsBox> {
  var arr;
  _DoctorsBoxState(this.arr);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HospitalDoctorOverview(email: arr['email'])));
        },
      child: FutureBuilder(
        future: DatabaseService.getImageOfUser(arr['email']),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return Container(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(snapshot.data as String),
                  ),
                  Text(arr['name']),
                ],
              ),
            );
          }
          else {
            return Container(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                  ),
                  Text(arr['name']),
                ],
              ),
            );
          }
        }
      )
    );
  }

}

