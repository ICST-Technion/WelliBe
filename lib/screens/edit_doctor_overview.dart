import 'package:flutter/material.dart';
import 'package:wellibe_proj/screens/card_viewer.dart';
import 'package:wellibe_proj/screens/something_went_wrong.dart';

import 'package:wellibe_proj/screens/view_page.dart';
import 'package:wellibe_proj/assets/wellibe_colors.dart';
import 'package:wellibe_proj/services/database.dart';
import 'package:wellibe_proj/services/auth.dart';


class EditDoctorOverview extends StatefulWidget {
  final String email;
  const EditDoctorOverview({required this.email});

  @override
  State<EditDoctorOverview> createState() => _EditDoctorOverviewState();
}

class _EditDoctorOverviewState extends State<EditDoctorOverview> {
  String? name;
  String? speciality;
  String? position;
  String? languages;
  String? about;
  String? url;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    var _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: AppColors.mainYellow,
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<Object>(
                      stream: _data.getEmailInner(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
                              child: IconButton(
                                icon: Icon(Icons.arrow_back), onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CardViewer(email: snapshot.data as String)));
                              },
                              ),
                            ),
                          );
                        }
                        return SomethingWentWrong();
                      }
                    ),
                    Center(
                      child: Stack(
                          children: [
                            StreamBuilder<String>(
                                stream: DatabaseService.getDoctorUrlInner(widget.email),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData) {
                                    return CircleAvatar(
                                      backgroundImage: NetworkImage(snapshot.data!),
                                      radius: 90,
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
                                backgroundImage: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Circle-icons-heart.svg/1024px-Circle-icons-heart.svg.png"),
                                radius: 30,
                              ),
                            ),
                          ]
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                            color: AppColors.mainWhite,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Column(
                            children: [
                              StreamBuilder<String>(
                                  stream: DatabaseService.getDoctorNameInner(widget.email),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return TextField(
                                        controller: TextEditingController()..text = snapshot.data!,
                                        onChanged: (text) => {
                                          name = text
                                        },
                                        style: TextStyle(fontSize: 18,
                                            fontWeight: FontWeight.bold),
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
                              StreamBuilder<String>(
                                  stream: DatabaseService.getDoctorPosition(widget.email),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return TextField(
                                        controller: TextEditingController()..text = snapshot.data!,
                                        onChanged: (text) => {
                                          position = text
                                        },
                                        style: TextStyle(fontSize: 18,
                                            fontWeight: FontWeight.bold),
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
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                color: AppColors.mainWhite,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "התחמחות:",
                          style: TextStyle(color: AppColors.textGreen, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        StreamBuilder<String>(
                            stream: DatabaseService.getDoctorSpeciality(widget.email),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return TextField(
                                  controller: TextEditingController()..text = snapshot.data!,
                                  onChanged: (text) => {
                                    speciality = text
                                  },
                                  style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                              else {
                                return Text(
                                  " ",
                                  style: TextStyle(fontSize: 18),
                                );
                              }
                            }
                        ),
                        Spacer(),
                        Text(
                          "תפקידים:",
                          style: TextStyle(color: AppColors.textGreen, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        StreamBuilder<String>(
                            stream: DatabaseService.getDoctorPosition(widget.email),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return TextField(
                                  controller: TextEditingController()..text = snapshot.data!,
                                  onChanged: (text) => {
                                    position = text
                                  },
                                  style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                              else {
                                return Text(
                                  " ",
                                  style: TextStyle(fontSize: 18),
                                );
                              }
                            }
                        ),
                        Spacer(),
                        Text(
                          "שפות:",
                          style: TextStyle(color: AppColors.textGreen, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        StreamBuilder<String>(
                            stream: DatabaseService.getDoctorLanguages(widget.email),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return TextField(
                                  controller: TextEditingController()..text = snapshot.data!,
                                  onChanged: (text) => {
                                    languages = text
                                  },
                                  style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                              else {
                                return Text(
                                  " ",
                                  style: TextStyle(fontSize: 18),
                                );
                              }
                            }
                        ),
                        Spacer(),

                        Text(
                          "על עצמי:",
                          style: TextStyle(color: AppColors.textGreen, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        StreamBuilder<String>(
                            stream: DatabaseService.getDoctorAdditional(widget.email),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return TextField(
                                  controller: TextEditingController()..text = snapshot.data!,
                                  onChanged: (text) => {
                                    about = text
                                  },
                                  style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                              else {
                                return Text(
                                  " ",
                                  style: TextStyle(fontSize: 18),
                                );
                              }
                            }
                        ),
                        Spacer(),
                        ElevatedButton(
                          child: Text(
                            "החל שינויים",
                            style: TextStyle(color: AppColors.mainWhite, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(AppColors.buttonRed),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
                          ), onPressed: () {
                            // apply the changes
                          //url = DatabaseService.getDoctorUrlInner(widget.email) as String;
                          if(name!=null) {
                            _data.updateDoctorName(name!, widget.email);
                          }
                          if(position!=null) {
                            _data.updateDoctorPos(position!, widget.email);
                          }
                          if(speciality!=null) {
                            _data.updateDoctorSpeciality(speciality!, widget.email);
                          }
                          if(languages!=null) {
                            _data.updateDoctorLang(languages!, widget.email);
                          }
                          if(about!=null) {
                            _data.updateDoctorAbout(about!, widget.email);
                          }
                            // return to the main doctor page
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => CardSender(email: widget.email)));
                        },
                        )],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
