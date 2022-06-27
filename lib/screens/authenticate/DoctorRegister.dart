import 'package:flutter/material.dart';
import 'package:wellibe_proj/screens/home/admin_home.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'package:wellibe_proj/services/database.dart';
import '../../assets/wellibe_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Login.dart';

class DRegisterScreen extends StatelessWidget {
  DRegisterScreen();

  final AuthService _auth = AuthService();

  String firstName = "";

  String familyName = "";
  String positionName = "";
  String speciality = "";

  String email = "";

  String password = "";

  String passwordAuth = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final DatabaseService _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);

    Size size = MediaQuery
        .of(context)
        .size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.mainWhite,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.mainWhite,
            leading: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHome())); },
              ),
            ),
          ),
          body:
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: size.height*0.07),
                color: Colors.white,
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              "הרשמה",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 36
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: "שם פרטי"
                              ),
                              validator: (val) {
                                if(val==null || val.trim().isEmpty){
                                  return 'הכנס שם פרטי';
                                }
                                if(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(val.trim()))
                                  return 'שם לא חוקי';
                                return null;
                              },
                              onChanged: (val) {
                                firstName = val.trim();
                              },
                            ),
                          ),

                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: "שם משפחה"
                              ),
                              validator: (val) {
                                if(val == null || val.trim().length == 0){
                                  return  'הכנס שם משפחה';
                                }
                                if(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(val.trim()))
                                  return 'שם לא חוקי';

                                return null;
                              },
                              onChanged: (val) {
                                familyName = val.trim();
                              },
                            ),
                          ),


                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: TextFormField(
                              textDirection: TextDirection.ltr,
                              decoration: const InputDecoration(
                                  labelText: "כתובת מייל"
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return "הכנס כתובת מייל";
                                }
                                String pattern = r'\w+@\w+\.\w+';
                                if (!RegExp(pattern).hasMatch(val.trim())) {
                                  return 'כתובת מייל לא חוקית';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                email = val;
                              },
                            ),
                          ),

                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: "סיסמה"
                              ),
                              validator: (val){
                                if(val==null){
                                  return null;
                                }
                                if(val.trim().isEmpty)
                                  return 'הכנס סיסמה';
                                if(val.trim().length < 6)
                                  return 'הסיסמה חייבת להיות באורך 6 תווים לפחות';
                                for(int i=0; i< val.trim().length; i++){
                                  if(val.trim()[i] == '\'' || val.trim()[i] == '\;' || val.trim()[i] == ' ')
                                    return 'הוכנס תו לא חוקי בסיסמה';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                password = val.trim();
                              },
                              obscureText: true,
                            ),
                          ),

                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText: "אימות סיסמה"
                              ),
                              validator: (val){
                                return (password != passwordAuth)? "סיסמה לא תואמת" : null;
                              },
                              onChanged: (val) => passwordAuth = val.trim()
                              ,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: "תפקיד"
                              ),
                              validator: (val) {
                                if(val == null || val.trim().length == 0){
                                  return  'הכנס תפקיד';
                                }
                                if(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(val.trim()))
                                  return 'שם תפקיד לא חוקי';

                                return null;
                              },
                              onChanged: (val) {
                                positionName = val.trim();
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: "מומחיות (אופציונלי)"
                              ),
                              validator: (val) {
                                if(val == null || val.trim().length == 0){
                                  return null;
                                }
                                if(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(val.trim()))
                                  return 'תיאור מומחיות לא חוקי';
                                return null;
                              },
                              onChanged: (val) {
                                speciality = val.trim();
                              },
                            ),
                          ),


                          SizedBox(height: size.height * 0.03),

                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()){
                                  print(_auth.getCurrentUser()?.email);
                                  dynamic result = await _auth.doctorRegisterWithEmailAndPassword(firstName+" "+familyName, email, password, positionName, speciality);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHome()));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                primary: Colors.white,
                                padding: const EdgeInsets.all(0),),
                              child: Container(
                                alignment: Alignment.center,
                                height: 50.0,
                                width: size.width * 0.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(80.0),
                                  color: Colors.teal[300],
                                ),
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  "הרשמה",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.mainWhite,
                                  ),
                                ),
                              ),
                            ),
                          ),


                        ]
                    )
                )
            ),
          ),
          )
      ),
    );
  }
}
