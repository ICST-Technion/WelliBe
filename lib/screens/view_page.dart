// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wellibe_proj/screens/doctor_overview.dart';
import 'package:wellibe_proj/services/database.dart';
import '../assets/wellibe_colors.dart';
import '../services/auth.dart';
//import 'package:flutter_visibility_widget_demo/splash_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'histoy_qr.dart';

final AuthService _auth = AuthService();

class ViewPage extends StatelessWidget {
  const ViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  bool _isVisible = false;

  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }
  
  List<DoctorsList> doctorsList = [];
  List<DoctorsList> buildList(DateTime date){
    List<DoctorsList> doctorsList = [];
    int i = 0;
    for(int i=0; i<1; i++) {
      doctorsList.add(DoctorsList(counter: i,));
    }
    return doctorsList;
  }
  
  @override
  Widget build(BuildContext context) {

    DatabaseService _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);
    String? img = 'https://image.shutterstock.com/image-vector/profile-photo-vector-placeholder-pic-600w-535853263.jpg';
    String? name = "אנונימי";

    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          Container(
            //padding: const EdgeInsets.all(30.0),
            color: Colors.yellow[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                  Align(
                  alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward), onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
                      },
                      ),
                    ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            const Text(
                              ',שלום',
                              style: TextStyle(fontSize: 20.0, color: AppColors.header),
                            ),
                            StreamBuilder<String>(
                              stream: _data.getUserNameInner(),
                              builder: (context, snapshot) {
                                if(snapshot.hasData) {
                                  name = snapshot.data;
                                }
                                return Text(
                                  name!,
                                  style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: AppColors.header),
                                );
                              }
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10),
                            ),
                          ]
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.only(right: 15),
                        child: StreamBuilder<String>(
                          stream: _data.getUrlInner(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData) {
                              img = snapshot.data;
                            }
                            return CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                radius: 45,
                                backgroundImage: NetworkImage(img!),
                              ),
                            );
                          }
                        ),
                      )
                    ),
                  ]
                ),
                TableCalendar(
                  locale: "hebrew",
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay; // update `_focusedDay` here as well
                    });
                  },
                  calendarFormat: CalendarFormat.week,
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                )
              ],
            ),
          ),

          Expanded (
              child: Container(
                color: Colors.white,
                child: ListView(
                    //children: buildList(DateTime.now()),
                  children: buildList(_selectedDay),
                ),
                //alignment: Alignment.topRight,
              )
          ),
        ],
      ),
    );
  }
}


Widget demoDoctorsToDate(String image, String name, String description, String hour, BuildContext context) {
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              //alignment: Alignment.centerLeft,
              child: Column(
                  children: [
                    const Text(
                      "שעת ביקור",
                      style: TextStyle(
                        color: Color(0xff363636),
                        fontSize: 15,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      hour,
                      style: const TextStyle(
                        color: Color(0xff363636),
                        fontSize: 19,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]
              ),
            ),
            Container(
              //padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 7),
                      color: Colors.transparent,
                      width: 130,
                      height: 30,
                          child: AutoSizeText(
                            name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize:16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                  ),
                  Container(
                      color: Colors.transparent,
                      width: 130,
                      height: 50,
                      child: AutoSizeText(
                        description,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 6,
                          fontFamily: 'Roboto',
                          //fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      )
                  ),
                ],
              ),
            ),
            CircleAvatar(
                radius: 50,
                backgroundColor: Colors.black,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(image),
                ),
              ),
          ],
        ),
        height: 100,
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              offset: Offset(3, 2), // Shadow position
            ),
          ],
        ),
    );
}


class TableBasicsExample extends StatefulWidget {
  const TableBasicsExample({Key? key}) : super(key: key);

@override
_TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
    );
  }
}



class DoctorsList extends StatefulWidget {
  final counter;
  DoctorsList({this.counter});

  @override
  _DoctorsListState createState() => _DoctorsListState(counter);
}

class _DoctorsListState extends State<DoctorsList> {
  final counter;
  _DoctorsListState(this.counter);

  final DatabaseService _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);
  bool _isVisible = false;
  var name;
  var email;

  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }
  @override
  Widget build(BuildContext context) {
    print(counter);
    return Column(
      children: [
        StreamBuilder<Object>(
          stream: _data.getDocEmailFromCount(counter),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              //print(snapshot.data);
              email = snapshot.data;
            }
            return StreamBuilder<Object>(
              stream: _data.getDoctorNameInner(email),
              builder: (context, snapshot) {
                print('hey3');
                print(email);
                if(snapshot.hasData){
                  name = snapshot.data;
                }
                return FlatButton(
                    onPressed: showToast,
                    //child: demoDoctorsToDate('https://www.shareicon.net/data/128x128/2016/08/18/813847_people_512x512.png',name,"מתמחה במחלקה הכירורגית", "13:45", context)
                    child: demoDoctorsToDate('https://www.shareicon.net/data/128x128/2016/08/18/813847_people_512x512.png',"דר יסמין כרמי","מתמחה במחלקה הכירורגית", "13:45", context)
                );
              }
            );
          }
        ),
        Visibility(
          child: Container(
            height: 150,
            padding: const EdgeInsets.only(left: 15, right: 15),
            color: Colors.transparent,
            child: Container(
                height: 150,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2,
                      offset: Offset(3, 2), // Shadow position
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(6),
                        color: Colors.yellow[50],
                        height: 70,
                        width: 350,
                        child: const AutoSizeText("דר כרמי הגיעה לבדוק לשלומי ובבדיקת המדדים שביצעה נראה שהכל תקין",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                        )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          onPressed: () {
                            //navigate to the card making page
                          },
                          child: Text(
                            "הכנת כרטיס תודה",
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 17,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            //navigate to doctors page
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorOverview(uid: email,)));
                          },
                          child: const Text(
                            "צפייה בפרופיל",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
            ),
          ), visible: _isVisible,),
        Text("")
      ],
    );
  }
}



