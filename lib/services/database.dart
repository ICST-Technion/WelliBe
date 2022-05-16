import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:wellibe_proj/models/user.dart';
import 'package:wellibe_proj/screens/authenticate/authenticate.dart';
import 'package:wellibe_proj/services/auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;



class DatabaseService {
  final String? uid;
  DatabaseService({required this.uid});
  AuthService _auth = AuthService();
  //creates users collection in firebase
  final CollectionReference usersInfoCollection = FirebaseFirestore.instance.collection(
      'usersInfo');
  final CollectionReference doctorsInfoCollection = FirebaseFirestore.instance.collection('doctorsInfo');


  /////////////////////////////// users functions ////////////////////////////

  //adds user to users collection. needs to be called from sign up method.
  Future updateUserData(String url, String name, String email, String password) async {
    return await usersInfoCollection.doc(uid).set({
      'url' : url,
      'email' : email,
      'password' : password,
      'name' : name,
      'doctors' : " ",
  });
  }

  Future addDoctor() async {

  }


  //add map of date and doctor id
  Future addMap(int day, int month, int year, String time, String duid) async{
    String date = day.toString() + "-" + month.toString() + "-" + year.toString();
    return await usersInfoCollection.doc(uid).update({"doctors.$date.$duid" : time });
  }

  Stream<List> fromDateToList(int day, int month, int year){
    var date = day.toString() + "-" + month.toString() + "-" + year.toString();
    print(date);
     return usersInfoCollection.doc(uid).snapshots().map((doc) {
       var maps = doc['doctors'] as Map;
       List l = [];
       var values = maps[date].values;
       var keys = maps[date].keys;
       int i = 0;
       int j = 0;
       for (var v in values){
         for (var k in keys) {
           if (i == j)
            l.add([v, k]);
           j ++;
         }
         i++;
         j = 0;
       }
       return l;
    });
  }

  Stream<String> getUserNameInner() {
    return usersInfoCollection
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc['name'] is String &&
          (doc['name'] as String).isNotEmpty) {
        return doc['name'];
      } else {
        return 'אנונימי';
      }
    });
  }

  Stream<String> getUrlInner() {
    return usersInfoCollection
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc['url'] is String &&
          (doc['url'] as String).isNotEmpty) {
        return doc['url'];
      } else {
        return 'https://st4.depositphotos.com/11634452/41441/v/1600/depositphotos_414416674-stock-illustration-picture-profile-icon-male-icon.jpg';
      }
    });
  }


  ////////////////////////////// doctors functions //////////////////////////////////

  Future updateDoctorData(String url, String name, String spec, String pos, String lan, String add, String email) async {
    //updates firebases build in parameters
    //updates the parameters i added to firebase...
    return await doctorsInfoCollection.doc(email).set({
      'url' : url,
      'name' : name,
      'speciality' : spec,
      'position' : pos,
      'languages' : lan,
      'additional_info' : add,
      'email' : email,
      'cards' : [],
    });
  }

  // Stream<String> getDocEmailFromCount(int counter){
  //   var duid;
  //   return usersInfoCollection.doc(uid).snapshots().map((doc) {
  //     duid = doc['doctors'][counter]["email"];
  //     return duid;
  // });
  // }

  //return doctors name based on his unique value
  Stream<String> getDoctorNameInner(String email) {
    return doctorsInfoCollection
        .doc(email)
        .snapshots()
        .map((doc) {
      if (doc['name'] is String &&
          (doc['name'] as String).isNotEmpty) {
        return doc['name'];
      } else {
        return 'אנונימי';
      }
    });
  }

  Stream<String> getDoctorUrlInner(String email) {
    return doctorsInfoCollection
        .doc(email)
        .snapshots()
        .map((doc) {
      if (doc['url'] is String &&
          (doc['url'] as String).isNotEmpty) {
        return doc['url'];
      } else {
        return 'https://image.shutterstock.com/image-vector/profile-photo-vector-placeholder-pic-600w-535853263.jpg';
      }
    });
  }

  Stream<String> getDoctorPosInner(String email) {
    return doctorsInfoCollection
        .doc(email)
        .snapshots()
        .map((doc) {
      if (doc['position'] is String &&
          (doc['position'] as String).isNotEmpty) {
        return doc['position'];
      } else {
        return '';
      }
    });
  }




  //////////////////////// extras //////////////////////////////

  //snapshot of change in collection
  Stream<QuerySnapshot> get users {
    return usersInfoCollection.snapshots();
  }
  QuerySnapshot get user1 {
    return usersInfoCollection.snapshots() as QuerySnapshot;
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid : uid,
      url : snapshot.get('url'),
      name: snapshot.get('name'),
    );
  }

  //get user doc stream
  Stream<UserData> get userData {
    return usersInfoCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future uploadFile(Uint8List? photo, String path, String doctor_id, String username) async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    if (photo == null) return;
    final fileName = (path);
    final destination = 'files/';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(path);
      await ref.putData(photo);
      var d = {'photo': path, 'username': username};
      var l = [d];
      // TODO: change doctor mail to be adaptive
      doctorsInfoCollection.doc('r@gmail.com').update({"cards": FieldValue.arrayUnion(l)});

    } catch (e) {
      print('error occured');
    }
  }
}