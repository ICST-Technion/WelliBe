import 'package:flutter/material.dart';
import 'package:wellibe_proj/assets/wellibe_colors.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'Register.dart';

class LoginScreen extends StatelessWidget {

  final Function toggleView;
  LoginScreen({required this.toggleView});

  String email = "";

  String password = "";

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
                      "התחברות",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA),
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

                  SizedBox(height: size.height * 0.03),

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
                        if(val.length < 6)
                          return 'הסיסמה חייבת להיות באורך 6 תווים לפחות';
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
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: GestureDetector(
                      onTap: (){
                        toggleView(3);
                      },
                      child: Text(
                        "שכחת סיסמה?",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2661FA)
                        ),
                      ),
                    ),

                  ),

                  SizedBox(height: size.height * 0.05),

                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()){
                          dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                          if(result==null){
                            print('could not sign in with credentials');
                          }
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
                            gradient: new LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 255, 136, 34),
                                  Color.fromARGB(255, 255, 177, 41)
                                ]
                            )
                        ),
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          "התחבר",
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
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: GestureDetector(
                      onTap: (){
                        toggleView(2);
                      },
                      child: Text(
                        "אין חשבון? הירשם",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2661FA)
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
      ),
    );
  }
}