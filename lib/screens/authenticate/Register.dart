import 'package:flutter/material.dart';
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
    var agree = false;
    Size size = MediaQuery
        .of(context)
        .size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
          body:
              SafeArea(
          child: SingleChildScrollView(
            child: Container(
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

                          SizedBox(height: size.height * 0.03),
                          Row(
                            children: [
                              Checkbox(value: agree, onChanged: (value)
                              { agree = value ?? false;},
                              ),
                              Tooltip(
                                  triggerMode: TooltipTriggerMode.tap,
                                  showDuration: const Duration(seconds: 2),
                                  waitDuration: const Duration(seconds: 1),
                                  child: Text('לחץ לקריאת תנאי שימוש'),
                                  message: ('באפליקציה זו נשמר אך ורק מידע לגבי הצוות הרפואי אותו \n המשתמש סרק באמצעות באפליקציה, וההערות שנכתבות באמצעות המשתמש.\n צוות האפליקציה שומר את הנתונים במסד נתונים מאובטח \n אך אין ברצונו להתחייב לשמירת מידע ברמת חיסיון רפואי \n ועל כן המידע הנשמר באפליקציה הינו באחריות המשתמש בלבד.')
                              ),
                            ],
                          ),

                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate() && agree == true){
                                    dynamic result = await _auth.registerWithEmailAndPassword(firstName+" "+familyName, email, password);
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

                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: GestureDetector(
                              onTap: ()
                              {
                                toggleView(1);
                              },
                              child: Text(
                                "כבר קיים חשבון? התחבר כאן",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo.shade900,
                                ),
                              ),
                            ),
                          )
                        ]
                    )
                )
            ),
          ),
              ),
      ),
    );
  }
}
