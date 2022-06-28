import 'package:flutter/material.dart';

import 'package:wellibe_proj/assets/wellibe_colors.dart';
import 'package:wellibe_proj/services/auth.dart';

class ForgotPassScreen extends StatelessWidget {
  final Function toggleView;
  ForgotPassScreen({required this.toggleView});

  String email = "";

  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body:
        Container(
          color: AppColors.mainWhite,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "שחזור סיסמה",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 36
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                SizedBox(height: size.height * 0.03),

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
                      email = val.trim();
                    },
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 20),
                  child: Text(
                    "במידה והמייל לא מופיע בתיבת הדואר יש לבדוק בתיבת הספאם",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade900
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () async { //
                      if (_formKey.currentState!.validate()){
                        _auth.sendResetEmail(email);
                        toggleView(1); // toggle view to the sign in page after password reset

                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                        primary: Colors.white,
                        padding: const EdgeInsets.all(0)),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: size.width * 0.5,
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          color: Colors.teal[300],
                      ),
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "שלח סיסמה למייל",
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
                  margin: EdgeInsets.only(right: 20, top: 30),
                  child: GestureDetector(
                    onTap: (){
                      toggleView(2); // toggle view to the register page
                    },
                    child: Text(
                      "אין חשבון? הירשם",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade900
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GestureDetector(
                    onTap: (){
                      toggleView(1); // toggle view back to the sign in page
                    },
                    child: Text(
                      "נזכרת בסיסמה? חזור להתחברות",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade900
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),

      ),
    );
  }
}