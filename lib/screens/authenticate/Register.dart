import 'package:flutter/material.dart';
import 'package:wellibe_proj/screens/histoy_qr.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'package:wellibe_proj/services/database.dart';
import '../../assets/wellibe_colors.dart';
import 'Login.dart';

class RegisterScreen extends StatelessWidget {
  final Function toggleView;
  RegisterScreen({required this.toggleView});

  final AuthService _auth = AuthService();

  String firstName = "";

  String familyName = "";

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
          body:
          Container(
              color: AppColors.mainYellow,
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
                                color: Color(0xFF2661FA),
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
                              if(val==null){
                                return 'הכנס שם פרטי';
                              }
                              for(int i = 0; i< val.length;i++){
                                if(val.codeUnitAt(i) >= '0'.codeUnitAt(i) && val.codeUnitAt(i) <= '9'.codeUnitAt(i))
                                  return 'שם פרטי לא יכול להכיל מספר';
                              }
                              return null;
                              },
                            onChanged: (val) {
                              firstName = val;
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
                              if(val == null){
                                return  'הכנס שם משפחה';
                              }
                              for(int i = 0; i< val.length;i++){
                                if(val.codeUnitAt(i) >= '0'.codeUnitAt(i) && val.codeUnitAt(i) <= '9'.codeUnitAt(i))
                                  return 'שם משפחה לא יכול להכיל מספר';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              familyName = val;
                            },
                          ),
                        ),

                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: "כתובת מייל"
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "הכנס כתובת מייל";
                              }
                              String pattern = r'\w+@\w+\.\w+';
                              if (!RegExp(pattern).hasMatch(value)) {
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
                              if(val.isEmpty)
                                return 'הכנס סיסמה';
                              if(val.length <= 8)
                                return 'הסיסמה חייבת להיות באורך 8 תווים לפחות';
                              for(int i=0; i< val.length; i++){
                                if(val[i] == '\'' || val[i] == '\;' || val[i] == ' ')
                                  return 'הוכנס תו לא חוקי בסיסמה';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              password = val;
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
                              if(password != passwordAuth)
                                return "סיסמה לא תואמת";
                            },
                            onChanged: (val) {
                              passwordAuth = val;
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
                              //if (_formKey.currentState!.validate()){
                              dynamic result = await _auth.registerWithEmailAndPassword(firstName+" "+familyName, email, password);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryQr()));
                              //}
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
                                  gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 255, 136, 34),
                                        Color.fromARGB(255, 255, 177, 41)
                                      ]
                                  )
                              ),
                              padding: const EdgeInsets.all(0),
                              child: Text(
                                "הרשמה",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: GestureDetector(
                            onTap: ()
                            {
                              toggleView();
                            },
                            child: Text(
                              "כבר קיים חשבון? התחבר כאן",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2661FA),
                              ),
                            ),
                          ),
                        )
                      ]
                  )
              )
          )
      ),
    );
  }
}
