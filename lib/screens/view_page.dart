// ignore: import_of_legacy_library_into_null_safe
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:wellibe_proj/screens/doctor_overview.dart';
import 'package:wellibe_proj/screens/patients_page.dart';
import 'package:wellibe_proj/screens/something_went_wrong.dart';
import 'package:wellibe_proj/services/database.dart';
import 'package:wellibe_proj/screens/qr_scanning_page.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'package:wellibe_proj/screens/card.dart';

import '../assets/wellibe_colors.dart';

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
  final _key = GlobalKey<ScaffoldState>();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  int a = 0;
  Uint8List _image = Uint8List(0);

  //List<DoctorsList> doctorsList = [];
  List<DoctorsList> buildList(List docs, DateTime day){
    List<DoctorsList> doctorsList = [];
    if (docs == null) {
      doctorsList.add(DoctorsList(key: Key("100"), counter: -100, arr: docs, day: day));
      return doctorsList;
    }
    for(int i = 0; i < docs.length; i++) {
      doctorsList.add(DoctorsList(key: Key(DateTime.now().toLocal().toString()), counter: i, arr: docs[i], day: day));
    }
    return doctorsList;
  }

  Future<void> scanQR(List dlist) async {
    bool exists = false;
    var result = await BarcodeScanner.scan();
    DatabaseService _data = DatabaseService(uid: _auth
        .getCurrentUser()
        ?.uid);
    print(result.type); // The result type (barcode, cancelled, failed)
    for(int i =0; i<dlist.length; i++){
      if(result.rawContent == dlist[i]['email']){
        exists = true;
      }
    }

    if (result.type == ResultType.Barcode && exists == true) {
        DateTime time = DateTime.now().toLocal();
        String hour = time.hour.toString() + ":" + time.minute.toString();
        print(time);
        _data.addMap(time.day, time.month, time.year, hour, result.rawContent);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              DoctorInfoPage(
                  doctorEmail: result.rawContent, day: _selectedDay, hour: hour)),
        );
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            QRErrorPage()),
      );
    }
  }

  String getmail(){
    String s = "";
    if(_auth.getCurrentUser()!.email != null) {
      s = _auth.getCurrentUser()!.email!;
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DatabaseService _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);
    final Future<List> dlist = DatabaseService(uid: _auth.getCurrentUser()?.uid).getDocs();
    String? img = 'https://image.shutterstock.com/image-vector/profile-photo-vector-placeholder-pic-600w-535853263.jpg';
    String? name = "אנונימי";
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: const Text('התנתק', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () async {
                await _auth.signOut();
                print("sign out");
              },
            ),
            FutureBuilder<Object>(
              future: dlist,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return Tooltip(
                    message: 'לחץ לסריקת הרופא',
                    showDuration: const Duration(seconds: 2),
                    waitDuration: const Duration(seconds: 1),
                    child: IconButton(
                      icon: const Icon(Icons.qr_code_2, color: Colors.black,),
                      iconSize: 40,
                      onPressed: () async {
                        scanQR(snapshot.data as List);
                      },
                    ),
                  );
                }
                else{
                  return Center(child: SomethingWentWrong());
                }
              }
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.teal[300],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9), bottomRight: Radius.circular(9)),
                color: Colors.white
              ),
              //padding: const EdgeInsets.all(30.0),
              //color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                              Text(
                                'שלום,',
                                style: TextStyle(fontSize: 20.0, color: Colors.black), //Colors.indigo.shade900),
                                textAlign: TextAlign.justify,
                                textDirection: TextDirection.rtl,
                              ),
                              StreamBuilder<String>(
                                stream: _data.getUserNameInner(),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData) {
                                    name = snapshot.data;
                                  }
                                  else{
                                    return SomethingWentWrong();
                                  }
                                  return Text(
                                    name!,
                                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black), //Colors.indigo.shade900),
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
                        child: Tooltip(
                          message: "צפייה בפרופיל",
                          showDuration: const Duration(seconds: 2),
                          waitDuration: const Duration(seconds: 1),
                          child: Container(
                            padding: const EdgeInsets.only(right: 15),
                            child: StreamBuilder<String>(
                              stream: _data.getUrlInner(),
                              builder: (context, snapshot) {
                                if(snapshot.hasData) {
                                  img = snapshot.data;
                                  if(!snapshot.data!.contains('http')) {
                                    return FutureBuilder(
                                      future: FirebaseStorage.instance.ref().child('profile/' + getmail()).getDownloadURL(),
                                      builder: (context, snapshot) {
                                        if(snapshot.hasData) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PatientOverview()));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  8.0),
                                              child: CircleAvatar(
                                                radius: 50,
                                                backgroundColor: Colors.black,
                                                child: CircleAvatar(
                                                  radius: 45,
                                                  backgroundImage: NetworkImage(
                                                      snapshot.data as String),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        else {
                                          return CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.black,
                                            child: CircleAvatar(
                                              radius: 45,
                                            ),
                                          );
                                        }
                                      }
                                    );
                                  }
                                  else {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PatientOverview()));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.black,
                                          child: CircleAvatar(
                                            radius: 45,
                                            backgroundImage: NetworkImage(img!),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                                else {
                                  return Center(child: CircularProgressIndicator());
                                }
                              }
                            ),
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
                    headerVisible: true,
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: Colors.teal[300],
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.teal[100],
                      )
                    ),
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
                  padding: EdgeInsets.only(top:10),
                  color: Colors.teal[300],
                  child: StreamBuilder(
                    stream: _data.fromDateToList(_selectedDay.day, _selectedDay.month, _selectedDay.year),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        List l = snapshot.data as List;
                        return ListView(
                          children: buildList(l, _selectedDay),
                        );
                      }
                      else{
                        return Center(
                          child: Text(
                            'לא היו פגישות בתאריך זה'
                            , style: TextStyle(fontSize: 20),),
                        );
                      }
                    }
                  ),
                )
            ),
            BottomAppBar(
                color: Colors.transparent,
                child: Align(
                  child:  Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    showDuration: const Duration(seconds: 2),
                    waitDuration: const Duration(seconds: 1),
                    message: 'לחץ ארוך על סמלים להצגת מידע',
                    child: const Icon(Icons.help, color: Colors.black,),
                  ),
                )
            )
          ],
        ),
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
            VerticalDivider(
              color: Colors.grey[400],
              thickness: 1,
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
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 6,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
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
  final day;
  DoctorsList({required Key key, required this.counter, required this.arr, required this.day}) : super(key: key);

  @override
  _DoctorsListState createState() => _DoctorsListState(arr, counter, day);
}

class _DoctorsListState extends State<DoctorsList> {
  var arr;
  var counter;
  var day;
  _DoctorsListState(this.arr, this.counter, this.day);


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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    var list = arr[0];
    var email = list[0];
    var msg = list[1];
    var hour = arr[1];

    return Column(
      children: [
              StreamBuilder<Object>(
              stream: DatabaseService.getDoctorNameInner(email),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  name = snapshot.data as String;
                }
                else{
                  return SomethingWentWrong();
                }
                return StreamBuilder<Object>(
                  stream: DatabaseService.getDoctorUrlInner(email),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      url = snapshot.data as String;
                    }
                    else{
                      return SomethingWentWrong();
                    }
                    return StreamBuilder<Object>(
                      stream: _data.getDoctorPosInner(email),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          pos = snapshot.data as String;
                        }
                        else{
                          return SomethingWentWrong();
                        }
                        return TextButton(
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
            height: size.height*0.2,
            padding: const EdgeInsets.only(left: 15, right: 15),
            color: Colors.transparent,
            child: Container(
                height: size.height*0.2,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.all(6),
                          color: Colors.grey[200],
                          height: size.height*0.09,
                          width: size.width,
                          // child: TextField(
                          // textAlign: TextAlign.right,
                          // style: TextStyle(
                          //     fontSize: 14,
                          //             fontWeight: FontWeight.w700),
                          // decoration: InputDecoration(
                          //     labelText: msg
                          // ),
                          // onChanged: (String value) {
                          //   setState(() => msg = value);
                          //   },
                          //   ),
                        child: AutoSizeText(msg, maxFontSize: 25, maxLines: 4, textAlign: TextAlign.right, textDirection: TextDirection.rtl,),
                      ),
                      // Container(
                      //   color: AppColors.mainTeal,
                      //   height: size.height*0.03,
                      //   child: FlatButton(
                      //     color: AppColors.mainTeal,
                      //     onPressed: () {
                      //       _data.updateMsg(msg, day, hour, email);
                      //     },
                      //     child:
                      //     Text("אישור",
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CardSender(email: email)));
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
                            TextButton(
                              onPressed: () {
                                //navigate to doctors page
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorOverview(email: email,)));
                              },
                              child: Text(
                                "צפייה בפרופיל",
                                style: TextStyle(
                                  color: Colors.grey.shade900,
                                  fontSize: 17,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ), visible: _isVisible,),
        Text("")
      ],
    );
  }
}



