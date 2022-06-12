import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:wellibe_proj/screens/something_went_wrong.dart';

import 'package:wellibe_proj/services/database.dart';
import '../assets/wellibe_colors.dart';
import '../services/auth.dart';

final AuthService _auth = AuthService();
DatabaseService _data = DatabaseService(uid: _auth.getCurrentUser()?.uid);

class CardViewer extends StatefulWidget {
  final String email;
  const CardViewer({required this.email});

  @override
  State<CardViewer> createState() => _CardViewerState();
}

class _CardViewerState extends State<CardViewer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    DatabaseService _data = DatabaseService(uid: _auth
        .getCurrentUser()
        ?.uid);
    String? img = 'https://image.shutterstock.com/image-vector/profile-photo-vector-placeholder-pic-600w-535853263.jpg';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainTeal,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
              child: const Text('התנתק',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () async {
                await _auth.signOut();
                print("sign out");
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: size.height * 0.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(9),
                      bottomRight: Radius.circular(9)),
                  color: AppColors.mainTeal
              ),
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
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.black),
                                  //Colors.indigo.shade900),
                                  textAlign: TextAlign.justify,
                                  textDirection: TextDirection.rtl,
                                ),
                                StreamBuilder<String>(
                                    stream: _data.getUserNameInner(),
                                    builder: (context, snapshot) {
                                      String? name = ' ';
                                      if (snapshot.hasData) {
                                        name = snapshot.data;
                                      }
                                      else {
                                        return SomethingWentWrong();
                                      }
                                      return Text(
                                        name!,
                                        style: TextStyle(fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        //Colors.indigo.shade900),
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
                                    if (snapshot.hasData) {
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
                ],
              ),
            ),
            Expanded(
                child: Container(
                    child: FutureBuilder(
                        future: DatabaseService.getDoctorsCards(widget.email),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var urls = snapshot.data as List<String>;
                            print(urls);
                            return GalleryImage(
                              imageUrls: urls,
                              numOfShowImages: urls.length,
                            );
                          }
                          else {
                            return Center(child: CircularProgressIndicator(),);
                          }
                        }
                    )
                )
            ),
          ],
        ),
      ),
    );
  }
}