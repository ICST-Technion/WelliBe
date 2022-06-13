import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:wellibe_proj/screens/view_page.dart';
import 'package:wellibe_proj/services/database.dart';
import 'package:wellibe_proj/services/auth.dart';

class CardSender extends StatefulWidget {
  final String email;
  const CardSender({required this.email});
  @override
  State<CardSender> createState() => _CardSenderState();
}

class _CardSenderState extends State<CardSender> {
  int index = 0;
  Color _color = Colors.black;
  String img = 'ABC';
  TextEditingController txt = TextEditingController();
  int selected_edit = 0;
  String content = "";
  var edibales = ["אדום", "שחור", "כחול", "ירוק"];
  var sizes = [123.0, 115.0, 121.0, 145.0]; //+- 50
  var selected = [true, false, false, false];
  var font = "Times New Roman";
  var weight = FontWeight.w400;
  String background = 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/White_square_50%25_transparency.svg/1200px-White_square_50%25_transparency.svg.png';
  double fontsize = 18.0;
  GlobalKey _globalKey = new GlobalKey();
  String doctor_id = "";

  void changetext(String str){
      if(str.split("\n").length > 9 * (13.0/fontsize) || str.length < txt.text.length){
        txt.text = content;
      }
      else{
      content = str;
    }
  }
  void menu(int idx)
  {
    setState(() {});

    selected_edit = idx;
    int last = selected.indexOf(true);
    selected[last] = false;
    selected[idx] = true;
    index = idx;
    //txt.text = sizes[index].toString();
  }
  void edit(int idx)
  {
    setState(() {});
    if(selected_edit == 0){
      var colors = [Colors.red, Colors.black, Colors.blue, Colors.green];
      //txt.text = '10';
      _color = colors[idx];
      //txt.text = _color.toString();
    }
    else if(selected_edit == 2){
      print(idx);
      if(idx == 0)
        {weight = FontWeight.w100;}
      else if(idx == 1)
        {weight = FontWeight.w600;}
      else
        {weight = FontWeight.w900;}
    }
  }
  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
      _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes!);
      print(pngBytes);
      print(bs64);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
      return Future.delayed(Duration.zero);
    }
  }

    void send() async{
    doctor_id = widget.email;
    final _auth = AuthService();
    //TODO: send card data to server here
    var png = await _capturePng();
    String? username = _auth.getCurrentUser()?.uid;
    var database = DatabaseService(uid:_auth.getCurrentUser()?.uid);
    String uname = "";
    if (username != null){
      uname = username;
    }
    print(uname + doctor_id);
    database.uploadFile(png, uname + doctor_id + DateTime.now().toString(), doctor_id, uname);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPage()));

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: Colors.white,
        leadingWidth: 85,
        toolbarHeight: 50,
          actions: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.redAccent,
            onPrimary: Colors.white,
            shadowColor: Colors.greenAccent,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          onPressed: send,
          child: Text('שלח', style:TextStyle(fontWeight: FontWeight.bold,)),
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: RepaintBoundary(
          key:_globalKey,
          child: Container(
            child: SizedBox(
              height:250,
              width:300,
              child:Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  child: Image.network(
                    background,
                    height: 350,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Image.network(
                    'https://www.iconsdb.com/icons/preview/white/circle-xxl.png',
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Theme(data: Theme.of(context).copyWith(splashColor: Colors.white),
                  child:SizedBox(
                      width:100,
                      height: 200,
                      child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 9,
                        textAlign: TextAlign.center,
                        onChanged: changetext,
                        controller: txt,
                        cursorColor: Colors.white,
                        style: TextStyle(color: _color, fontFamily: font,
                            fontSize: fontsize, fontWeight: weight),
                          maxLength: 100,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(

                              borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                            ),
                           ),
                        ),
                      )
                  )
                ),

                ],
            ),),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height:sizes[index],
        width:double.infinity,
        child: Column(
          children:<Widget>[
            Visibility(
              child: BottomNavigationBar(
                onTap: edit,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedItemColor: Colors.brown,
                unselectedItemColor: Colors.brown,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.square, color: Colors.red),
                    label: 'אדום',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.square, color:Colors.black),
                    label: 'שחור',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.square, color:Colors.blue),
                    label: 'כחול',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.square, color:Colors.green),
                    label: 'ירוק',
                  ),
                ],
              ),
              visible: selected[0],
            ),
            Visibility(
              child: Slider(
                max: 50.0,
                min:5.0,
                value: fontsize,
                label: fontsize.round().toString(),
                onChanged: (double x){
                  setState(() {});
                  if(txt.text.split("\n").length <= 9 *(13.0/fontsize) || x <= fontsize){
                    fontsize = x;
                  }},
              ),
              visible: selected[1],
            ),
            Visibility(
              child: BottomNavigationBar(

                onTap: edit,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.black,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(null),
                    label: 'Slim',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(null),
                    label: 'Medium',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(null),
                    label: 'Bold',
                  ),


                ],
              ),
              visible: selected[2],
            ),
            Visibility(
              child: BottomAppBar(
                color: Colors.white70,
                child: Row(
                  children:<Widget>[
                    Expanded(
                        child:GestureDetector(
                          onTap: (){
                            setState(() {});
                            background = 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/White_square_50%25_transparency.svg/1200px-White_square_50%25_transparency.svg.png';
                          },
                          child: FittedBox(
                            fit: BoxFit.contain, // otherwise the logo will be tiny
                            child: Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/White_square_50%25_transparency.svg/1200px-White_square_50%25_transparency.svg.png',
                              height: 10,
                              width: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )

                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain, // otherwise the logo will be tiny
                        child: Icon(null)
                      ),
                    ),
                    Expanded(
                        child:GestureDetector(
                          onTap: (){
                            setState(() {});
                            background = 'https://i.pinimg.com/736x/89/89/07/898907211ca96f26deea690de0ae8b69.jpg';
                          },
                          child: FittedBox(
                            fit: BoxFit.contain, // otherwise the logo will be tiny
                            child: Image.network(
                              'https://i.pinimg.com/736x/89/89/07/898907211ca96f26deea690de0ae8b69.jpg',
                              height: 10,
                              width: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )

                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain, // otherwise the logo will be tiny
                        child: Icon(null)
                      ),
                    ),
                    Expanded(
                      child:GestureDetector(
                          onTap: (){
                            setState(() {});
                            background = 'https://i.pinimg.com/originals/f2/bf/de/f2bfdebf65b9eac60cbcd208600bc6d5.jpg';
                          },
                          child: FittedBox(
                            fit: BoxFit.contain, // otherwise the logo will be tiny
                            child: Image.network(
                              'https://i.pinimg.com/originals/f2/bf/de/f2bfdebf65b9eac60cbcd208600bc6d5.jpg',
                              height: 10,
                              width: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                      )

                    ),
                  ],
                )
              ),
              visible: selected[3],
            ),
            //add here more menu options

            BottomNavigationBar(
              onTap: menu,
              type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.orange,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.brush),
                label: 'צבע',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_back_outlined),
                label: 'גודל',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.font_download_outlined),
                label: 'פונט',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.filter_frames_outlined),
                label: 'רקע',
              ),

              ],
            ),

        ],
        ),
      ),

    );
  }
}
