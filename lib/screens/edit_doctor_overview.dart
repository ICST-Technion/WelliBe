import 'package:flutter/material.dart';
import 'package:wellibe_proj/screens/card_viewer.dart';
import 'package:wellibe_proj/screens/something_went_wrong.dart';
import 'package:wellibe_proj/assets/wellibe_colors.dart';
import 'package:wellibe_proj/services/database.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


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
        await ref.putData(pngBytes);
        var database = DatabaseService(uid:_auth.getCurrentUser()?.uid);
        database.updateUserProfilePhoto(fileName);

        print("uploaded");

      } catch (e) {
        print('error');
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);

    Size size = MediaQuery
        .of(context)
        .size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Container(
              height: size.height*0.4,
              padding: EdgeInsets.only(bottom: 10),
              color: Colors.teal[300],
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
                              onPressed: (){print("gallery");
                              _getFromGallery();
                              setState(() {});},
                              child:
                              CircleAvatar(
                                backgroundImage: NetworkImage("https://i.pinimg.com/564x/0b/67/66/0b6766991e4e6934fd22b1d8a2abdea1.jpg"),
                                radius: 20,
                              ),
                            )
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
                            offset: Offset(0, 3),),],
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
                                  onChanged: (text) => {name = text},
                                  style: TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.bold),);}
                              else {
                                return Text(" ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),);
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
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Container(
                  height: size.height*0.6,
                  color: AppColors.mainWhite,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: Text(
                            "התחמחות:",
                            style: TextStyle(color: AppColors.textGreen, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: StreamBuilder<String>(
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
                        ),
                        //Spacer(),
                        Container(
                          child: Text(
                            "תפקידים:",
                            style: TextStyle(color: AppColors.textGreen, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: StreamBuilder<String>(
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
                        ),
                        //Spacer(),
                        Container(
                          child: Text(
                            "שפות:",
                            style: TextStyle(color: AppColors.textGreen, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: StreamBuilder<String>(
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
                        ),
                        //Spacer(),

                        Container(
                          child: Text(
                            "על עצמי:",
                            style: TextStyle(color: AppColors.textGreen, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: StreamBuilder<String>(
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
                        ),
                        //Spacer(),
                        Center(
                          child: Container(
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
                            ),
                          ),
                        )],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
      ),
    );
  }
}



