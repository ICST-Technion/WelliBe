import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:wellibe_proj/screens/view_page.dart';
import 'package:wellibe_proj/assets/wellibe_colors.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'package:wellibe_proj/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;



class PatientOverview extends StatefulWidget {

  @override
  State<PatientOverview> createState() => _PatientOverviewState();
}

class _PatientOverviewState extends State<PatientOverview> {
  AuthService _auth = AuthService();
  Uint8List _image = Uint8List(0);
  bool isFirstOpen = true;

  String getmail(){
    String s = "";
    if(_auth.getCurrentUser()!.email != null) {
      s = _auth.getCurrentUser()!.email!;
    }
    return s;
  }

  Future getFirstImage(DatabaseService _data) async {
    var image = await _data.getProfileImage(getmail());
    setState(() { _image = image!; });
    return Future.delayed(Duration.zero);
  }

  _getFromGallery() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      var pngBytes = await imageFile.readAsBytes();
      setState(() { _image = pngBytes; });
      //upload and put image at user image location ('profile/username.png')
      firebase_storage.FirebaseStorage storage =
              firebase_storage.FirebaseStorage.instance;

      final fileName = getmail();
      final destination = 'profile/';

      try {
        final ref = storage
            .ref(destination)
            .child(fileName);
        //await ref.putData(pngBytes as Uint8List);
        //var d = {'profile': destination, 'username': getmail()};
        //var l = [d];
        await ref.putData(pngBytes);
        var database = DatabaseService(uid:_auth.getCurrentUser()?.uid);
        await database.updateUserProfilePhoto(fileName);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  String age = "";
  String gender = "";
  String name = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    DatabaseService _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.teal[300],
          leading: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewPage()));
            },
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10),
                color: Colors.teal[300],
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Stack(
                          children: [
                            StreamBuilder<String>(
                                stream: _data.getUrlInner(),
                                builder: (context, snapshot) {
                                if(snapshot.hasData) {
                                  if(!snapshot.data!.contains('http')) {
                                    if(isFirstOpen) {
                                      isFirstOpen = false;
                                      return FutureBuilder(
                                        future: getFirstImage(_data),
                                        builder: (context, snapshot) {
                                          if(snapshot.hasData) {
                                            return CircleAvatar(
                                              radius: 65,
                                              backgroundColor: Colors.black,
                                              child: CircleAvatar(
                                                backgroundImage: MemoryImage(_image),
                                                radius: 60,
                                              ),
                                            );
                                          }
                                          else {
                                            return CircleAvatar(
                                              radius: 65,
                                              backgroundColor: Colors.black,
                                              child: CircleAvatar(
                                                radius: 60,
                                              ),
                                            );
                                          }
                                        });
                                    }
                                    return CircleAvatar(
                                      radius: 65,
                                      backgroundColor: Colors.black,
                                      child: CircleAvatar(
                                        backgroundImage: MemoryImage(_image),
                                        radius: 60,
                                      ),
                                    );
                                  }
                                }
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
                            ),
                            Positioned(
                              bottom: 5,
                              child: TextButton(
                                onPressed: (){
                                  _getFromGallery();
                                  setState(() {});
                                },
                                child:
                                  CircleAvatar(
                                    backgroundImage: NetworkImage("https://i.pinimg.com/564x/0b/67/66/0b6766991e4e6934fd22b1d8a2abdea1.jpg"),
                                    radius: 20,
                                  ),
                              )
                            ),
                          ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                        setState(()=> name = value);

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
                                        setState(()=> age = value);
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
                                        setState(()=> gender = value);

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
              ),
              Expanded(
                child: Center(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: size.width*0.2, right:size.width*0.2, bottom: 10),
                    child: ElevatedButton(
                        child: Text(
                          "החל שינויים",
                          style: TextStyle(color: AppColors.mainWhite, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(AppColors.buttonBlue),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
                        ), onPressed: () {
                      if(name!=""){
                        _data.updateUserName(name);
                      }
                      if(gender!=""){
                        _data.updateUserGender(gender);
                      }
                      if(age!=""){
                        _data.updateUserAge(age);
                      }
                      // apply the changes
                      //url = DatabaseService.getDoctorUrlInner(widget.email) as String;
                    }
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
