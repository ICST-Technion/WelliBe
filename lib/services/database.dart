import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:wellibe_proj/models/user.dart';
import 'package:wellibe_proj/screens/authenticate/authenticate.dart';
import 'package:wellibe_proj/services/auth.dart';


class DatabaseService {
  final String? uid;
  DatabaseService({required this.uid});
  AuthService _auth = AuthService();
  //creates users collection in firebase
  final CollectionReference usersInfoCollection = FirebaseFirestore.instance.collection(
      'usersInfo');
  final CollectionReference doctorsInfoCollection = FirebaseFirestore.instance.collection('doctorsInfo');


  //adds user to users collection. needs to be called from sign up method.
  Future updateUserData(String url, String name, String email, String password) async {
    //updates firebases build in parameters
    _auth.getCurrentUser()?.updateProfile(displayName: name, photoURL: url); //changes the displayName but doesnt show up in firebase

    //updates the parameters i added to firebase...
    return await usersInfoCollection.doc(uid).set({
      'url' : url,
      'email' : email,
      'password' : password,
      'name' : name,
  });
  }

  Future addDoctor() async {

  }

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

  Stream<String> getDocEmailFromCount(int counter){
    var duid;
    return usersInfoCollection.doc(uid).snapshots().map((doc) {
      duid = doc['doctors'][counter]["email"];
      return duid;
  });
  }

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


}