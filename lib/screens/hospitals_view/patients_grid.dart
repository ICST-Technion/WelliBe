import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wellibe_proj/assets/wellibe_colors.dart';
import 'package:wellibe_proj/screens/home/admin_home.dart';
import 'package:wellibe_proj/screens/patients_page.dart';
import 'package:wellibe_proj/screens/something_went_wrong.dart';
import 'package:wellibe_proj/screens/view_page.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'package:wellibe_proj/services/database.dart';
import 'hospital_doctor_overview.dart';

List removeDocs(List arr){
  print(arr);
  List temp = [];
  for(int i=0; i<arr.length; i++){
    if(arr[i]['role']=="user"){
      temp.add(arr[i]);
    }
  }
  return temp;
}

class PatientsGrid extends StatefulWidget {
  const PatientsGrid({Key? key}) : super(key: key);

  @override
  _PatientsGridState createState() => _PatientsGridState();
}

AuthService _auth = AuthService();


//wraps the home screen and returns us back to sign in if logged out
class _PatientsGridState extends State<PatientsGrid> {
  final Future<List> dlist = DatabaseService(uid: _auth.getCurrentUser()?.uid).getUsers();
  @override
  Widget build(BuildContext context) {
    DatabaseService _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);
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
                              child: Text("רשימת מטופלים",
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
                        var ar = snapshot.data as List;
                        List newlist = removeDocs(ar);
                        return Container(
                            padding: EdgeInsets.all(12.0),
                            child: GridView.builder(
                              itemCount: newlist.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 2.0,
                                  mainAxisSpacing: 2.0
                              ),
                              itemBuilder: (BuildContext context, int index){
                                return UsersBox(key: Key(DateTime.now().toLocal().toString()), arr: (newlist)[index]);
                              },
                            ));
                      }
                      return SomethingWentWrong();
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



class UsersBox extends StatefulWidget {
  final arr;
  UsersBox({required Key key, required this.arr}) : super(key: key);

  @override
  _UsersBoxState createState() => _UsersBoxState(arr);
}

class _UsersBoxState extends State<UsersBox> {
  var arr;
  _UsersBoxState(this.arr);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(arr['url']),
            ),
            Text(arr['name']),
          ],
        ),
      ),
    );
  }

}

