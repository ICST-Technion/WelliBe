import 'package:flutter/material.dart';

import 'package:wellibe_proj/screens/view_page.dart';
import 'package:wellibe_proj/assets/wellibe_colors.dart';
import 'package:wellibe_proj/services/database.dart';
import 'package:wellibe_proj/screens/card.dart';

class DoctorOverview extends StatefulWidget {
  final String email;
  const DoctorOverview({required this.email});

  @override
  State<DoctorOverview> createState() => _DoctorOverviewState();
}

class _DoctorOverviewState extends State<DoctorOverview> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        child: Container(
          color: Colors.teal[300],
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.teal[300],
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back), onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewPage()));
                              },
                          ),
                        ),
                      ),
                      Center(
                        child: Stack(
                          children: [
                            StreamBuilder<String>(
                              stream: DatabaseService.getDoctorUrlInner(widget.email),
                              builder: (context, snapshot) {
                                if(snapshot.hasData) {
                                  return CircleAvatar(
                                    radius: 90,
                                    backgroundColor: Colors.black,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(snapshot.data!),
                                      radius: 84,
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
                              borderRadius: BorderRadius.all(Radius.circular(11)),
                            ),
                            child: Column(
                              children: [
                                StreamBuilder<String>(
                                  stream: DatabaseService.getDoctorNameInner(widget.email),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data!,
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
                                      if (snapshot.hasData && snapshot.data!='אין') {
                                        return Text(
                                          snapshot.data!,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: size.height*0.4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StreamBuilder<String>(
                                      stream: DatabaseService.getDoctorPosition(widget.email),
                                      builder: (context, snapshot) {
                                        var _isVis = false;
                                        var text = "";
                                        if (snapshot.hasData && snapshot.data!='') {
                                          _isVis = true;
                                          text = snapshot.data as String;
                                        }
                                        return Visibility(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "תפקידים:",
                                                style: TextStyle(color: AppColors.textGreen, fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                text,
                                                style: TextStyle(fontSize: 18,),
                                              ),
                                            ],
                                          ),
                                          visible: _isVis,
                                        );
                                      }
                                  ),
                                  StreamBuilder<String>(
                                      stream: DatabaseService.getDoctorSpeciality(widget.email),
                                      builder: (context, snapshot) {
                                        var _isVis = false;
                                        var text = "";
                                        if (snapshot.hasData && snapshot.data!='') {
                                          _isVis = true;
                                          text = snapshot.data as String;
                                        }
                                        return Visibility(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "התחמחות:",
                                                style: TextStyle(color: AppColors.textGreen, fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                text,
                                                style: TextStyle(fontSize: 18,),
                                              ),
                                            ],
                                          ),
                                          visible: _isVis,
                                        );
                                      }
                                  ),
                                  StreamBuilder<String>(
                                      stream: DatabaseService.getDoctorLanguages(widget.email),
                                      builder: (context, snapshot) {
                                        var _isVis = false;
                                        var text = "";
                                        if (snapshot.hasData && snapshot.data!='') {
                                          _isVis = true;
                                          text = snapshot.data as String;
                                        }
                                        return Visibility(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "שפות:",
                                                style: TextStyle(color: AppColors.textGreen, fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                text,
                                                style: TextStyle(fontSize: 18,),
                                              ),
                                            ],
                                          ),
                                          visible: _isVis,
                                        );
                                      }
                                  ),
                                  StreamBuilder<String>(
                                      stream: DatabaseService.getDoctorAdditional(widget.email),
                                      builder: (context, snapshot) {
                                        var _isVis = false;
                                        var text = "";
                                        if (snapshot.hasData && snapshot.data!='') {
                                          _isVis = true;
                                          text = snapshot.data as String;
                                        }
                                        return Visibility(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "על עצמי:",
                                                style: TextStyle(color: AppColors.textGreen, fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                text,
                                                style: TextStyle(fontSize: 18,),
                                              ),
                                            ],
                                          ),
                                          visible: _isVis,
                                        );
                                      }
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: ElevatedButton(
                                child: Text(
                                  "הכנת כרטיס הוקרת תודה",
                                  style: TextStyle(color: AppColors.mainWhite, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.indigo.shade900),
                                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
                                ), onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CardSender(email: widget.email)));
                              },
                              ),
                            ),
                          )
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
