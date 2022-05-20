// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import 'package:wellibe_proj/screens/doctor_overview.dart';
import 'package:wellibe_proj/services/database.dart';
import 'package:wellibe_proj/assets/wellibe_colors.dart';
import 'package:wellibe_proj/screens/qr_scanning_page.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'package:wellibe_proj/screens/card.dart';

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
  List<DoctorsList> buildList(List docs){
    if (docs == null) {
      return [];
    }

    List<DoctorsList> doctorsList = [];
    for(int i = 0; i < docs.length; i++) {
      doctorsList.add(DoctorsList(counter: i, arr: docs[i]));
    }
    return doctorsList;
  }

  Future<void> scanQR() async {
    var result = await BarcodeScanner.scan();

    print(result.type); // The result type (barcode, cancelled, failed)
    if(result.type == ResultType.Barcode) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DoctorInfoPage(doctorEmail: result.rawContent)),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {

    DatabaseService _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);
    String? img = 'https://image.shutterstock.com/image-vector/profile-photo-vector-placeholder-pic-600w-535853263.jpg';
    String? name = "אנונימי";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainYellow,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
              child: const Text('התנתק', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () async {
                await _auth.signOut();
                print("sign out");
              },
            ),
            IconButton(
              icon: const Icon(Icons.qr_code_2, color: Colors.black,),
              iconSize: 40,
              onPressed: () async {
                scanQR();
              },
            ),
          ],
        ),
      ),
      body: Column(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /*Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                      padding: const EdgeInsets.fromLTRB(250, 30, 0, 0),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward), onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
                            },
                        ),
                      ),
                    ),*/
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            const Text(
                              'שלום,',
                              style: TextStyle(fontSize: 20.0, color: AppColors.header),
                              textAlign: TextAlign.justify,
                              textDirection: TextDirection.rtl,
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
                                  textAlign: TextAlign.justify,
                                  textDirection: TextDirection.rtl,
                                );
                              }
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10),
                            ),
                          ]
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
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
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundImage: NetworkImage(img!),
                                ),
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
                  //headerVisible: false,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  headerVisible: true,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarFormat: CalendarFormat.week,
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  availableCalendarFormats: {
                    CalendarFormat.month: 'חודש',
                    CalendarFormat.week: 'שבוע',
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                )
              ],
            ),
          ),

          Expanded (
              child: Container(
                color: Colors.white,
                child: StreamBuilder(
                  stream: _data.fromDateToList(_selectedDay.day, _selectedDay.month, _selectedDay.year),
                  builder: (context, snapshot) {
                    print(snapshot.data);
                    List l = snapshot.data as List;
                    //print(l);
                    return ListView(
                        //children: buildList(DateTime.now()),
                      children: buildList(l),
                    );
                  }
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


class DoctorsList extends StatefulWidget {
  final counter;
  final arr;
  DoctorsList({this.counter, this.arr});

  @override
  _DoctorsListState createState() => _DoctorsListState(arr);
}

class _DoctorsListState extends State<DoctorsList> {
  var arr;
  _DoctorsListState(this.arr);

  final DatabaseService _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);
  bool _isVisible = false;
  var name = "אנונימי";
  var url = 'https://image.shutterstock.com/image-vector/profile-photo-vector-placeholder-pic-600w-535853263.jpg';
  var pos = '';

  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }
  @override
  Widget build(BuildContext context) {
    var email = arr[0];
    var hour = arr[1];
    return Column(
      children: [
              StreamBuilder<Object>(
              stream: DatabaseService.getDoctorNameInner(email),
              builder: (context, snapshot) {
                print(snapshot.data);
                if(snapshot.hasData){
                  name = snapshot.data as String;
                }
                return StreamBuilder<Object>(
                  stream: DatabaseService.getDoctorUrlInner(email),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      url = snapshot.data as String;
                    }
                    return StreamBuilder<Object>(
                      stream: _data.getDoctorPosInner(email),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          pos = snapshot.data as String;
                        }
                        return FlatButton(
                            onPressed: showToast,
                            child: demoDoctorsToDate(url, name, pos, hour, context)
                        );
                      }
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CardSender()));
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorOverview(email: email,)));
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



