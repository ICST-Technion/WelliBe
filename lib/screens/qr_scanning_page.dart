import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import 'package:wellibe_proj/assets/wellibe_colors.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'package:wellibe_proj/services/database.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/cupertino.dart';
import '../assets/wellibe_colors.dart';

const String yourDoctorIsString = 'המטפל/ת שלך הוא/היא';

class DoctorInfoPage extends StatelessWidget {
  final String doctorEmail;
  final DateTime day;
  final String hour;

  DoctorInfoPage(
      {required this.doctorEmail, required this.day, required this.hour});

  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    DatabaseService _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);

    return Material(
      child: Container(
        color: Colors.teal[300],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  yourDoctorIsString,
                  style: TextStyle(fontSize: 20),
                ),
              ),

              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.mainWhite,
                    ),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 3,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 1.5,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: StreamBuilder<String>(
                              stream: DatabaseService.getDoctorUrlInner(
                                  doctorEmail),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return CircleAvatar(
                                    radius: 60,
                                    backgroundImage: NetworkImage(
                                        snapshot.data!),
                                  );
                                }
                                else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              }
                          ),
                        ),
                        StreamBuilder<String>(
                            stream: DatabaseService.getDoctorNameInner(
                                doctorEmail),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                    snapshot.data!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20));
                              }
                              else {
                                return Text(
                                    " ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20));
                              }
                            }
                        ),
                        StreamBuilder<String>(
                            stream: DatabaseService.getDoctorPosition(
                                doctorEmail),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!,
                                  style: TextStyle(fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                              else {
                                return Text(
                                  " ",
                                  style: TextStyle(fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                            }
                        ),
                      ],
                    ),
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    primary: Colors.indigo.shade900,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.favorite),
                ),
              ),

              Container(
                color: AppColors.mainTeal,
                padding: EdgeInsets.only(left: size.width*0.2, right:size.width*0.2),
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.grey[300],
                  height: size.height * 0.09,
                  width: size.width,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                        onChanged: (String value) {
                          _data.updateMsg(value, day, hour, doctorEmail);
                        },
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

