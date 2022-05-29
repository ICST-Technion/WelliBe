
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wellibe_proj/screens/view_page.dart';
import 'package:wellibe_proj/assets/wellibe_colors.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'package:wellibe_proj/services/database.dart';
import 'package:wellibe_proj/screens/card.dart';

class PatientOverview extends StatefulWidget {

  @override
  State<PatientOverview> createState() => _PatientOverviewState();
}

class _PatientOverviewState extends State<PatientOverview> {
  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    DatabaseService _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        child: Container(
          padding: EdgeInsets.only(top: 40),
          color: Colors.teal[300],
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10),
                color: Colors.teal[300],
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back), onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewPage())); },
                      ),
                    ),
                    Center(
                      child: Stack(
                          children: [
                            StreamBuilder<String>(
                                stream: _data.getUrlInner(),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData) {
                                    return GestureDetector(
                                      onTap: (){

                                      },
                                      child: CircleAvatar(
                                        radius: 65,
                                        backgroundColor: Colors.black,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(snapshot.data!),
                                          radius: 60,
                                        ),
                                      ),
                                    );
                                  }
                                  else {
                                    return Center(child: CircularProgressIndicator());
                                  }
                                }
                            ),
                            Positioned(
                              bottom: 5,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage("https://i.pinimg.com/564x/0b/67/66/0b6766991e4e6934fd22b1d8a2abdea1.jpg"),
                                radius: 20,
                              ),
                            ),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(9), topLeft: Radius.circular(9)),
                    color: AppColors.mainWhite,
                  ),
                  //color: AppColors.mainWhite,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "שם:",
                            style: TextStyle(color: AppColors.textGreen, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          StreamBuilder<String>(
                              stream: _data.getUserNameInner(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return TextField(
                                    style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                        labelText: snapshot.data
                                    ),
                                    onChanged: (String value) {
                                      _data.updateUserName(value);
                                    },
                                  );
                                }
                                else {
                                  return Text(
                                    " ",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  );
                                }
                              }
                          ),

                          Text(
                            "גיל:",
                            style: TextStyle(color: AppColors.textGreen, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          StreamBuilder<String>(
                              stream: _data.getUserAgeInner(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return TextField(
                                    style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                        labelText: snapshot.data
                                    ),
                                    onChanged: (String value) {
                                      _data.updateUserAge(value);
                                    },
                                  );
                                }
                                else {
                                  return TextField(
                                    style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                        labelText: ''
                                    ),
                                    onChanged: (String value) {
                                      _data.updateUserAge(value);
                                    },
                                  );

                                }
                              }
                          ),

                          Text(
                            "מין:",
                            style: TextStyle(color: AppColors.textGreen, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          StreamBuilder<String>(
                              stream: _data.getUserGenderInner(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return TextField(
                                    style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                        labelText: snapshot.data
                                    ),
                                    onChanged: (String value) {
                                      _data.updateUserGender(value);
                                    },
                                  );
                                }
                                else {
                                  return TextField(
                                    style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                        labelText: ''
                                    ),
                                    onChanged: (String value) {
                                      _data.updateUserGender(value);
                                    },
                                  );

                                }
                              }
                          ),
                      ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
