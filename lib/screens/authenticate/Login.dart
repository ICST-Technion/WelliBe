import 'package:flutter/material.dart';

import 'package:wellibe_proj/assets/wellibe_colors.dart';
import 'package:wellibe_proj/services/auth.dart';

class LoginScreen extends StatefulWidget {
  final Function toggleView;
  String error;
  LoginScreen({required this.toggleView, this.error = ''});

  @override
  _LoginScreen createState() => _LoginScreen(toggleView: this.toggleView, error: this.error);
}

class _LoginScreen extends State<LoginScreen> {
  final Function toggleView;
  String error;

  _LoginScreen({required this.toggleView, this.error = ''});

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
          Center(
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
                        "התחברות",
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
                          setState( () => error = '');
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
                        setState( () => error = '');
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
                              color: Colors.indigo.shade900,
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
                              setState( () => error = 'שם משתמש או סיסמא לא נכונים');
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
                              color: Colors.teal[300],
                          ),
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            "התחבר",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainWhite
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      error,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonRed
                      ),
                    ),                    Container(
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
                              color: Colors.indigo.shade900
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }

}