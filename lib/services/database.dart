import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:wellibe_proj/models/user.dart';
import 'package:wellibe_proj/services/auth.dart';

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
  Future updateUserData(String url, String name, String email, String password, String role) async {
    return await usersInfoCollection.doc(uid).set({
      'url' : url,
      'email' : email,
      'password' : password,
      'name' : name,
      'doctors' : " ",
      'role' : role,
  });
  }


  Future updateUserName(String name) async{
    return await usersInfoCollection.doc(uid).update({'name' : name});
  }

  Future updateUserAge(String age) async{
    return await usersInfoCollection.doc(uid).update({'age' : age});
  }

  Future updateUserGender(String gender) async{
    return await usersInfoCollection.doc(uid).update({'gender' : gender});
  }

  Future updateUserUrl(String url) async{
    return await usersInfoCollection.doc(uid).update({url : url});
  }

  Future addDoctor(String email) async {

  }


  //add map of date and doctor id
  Future addMap(int day, int month, int year, String time, String duid) async{
    String date = day.toString() + "-" + month.toString() + "-" + year.toString();
    return await usersInfoCollection.doc(uid).update({"doctors.$date.$time" : duid });
  }

  Stream<List> fromDateToList(int day, int month, int year){
    var date = day.toString() + "-" + month.toString() + "-" + year.toString();
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
       print(l);
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

  Stream<String> getUserAgeInner() {
    return usersInfoCollection
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc['age'] is String &&
          (doc['age'] as String).isNotEmpty) {
        return doc['age'];
      } else {
        return '';
      }
    });
  }

  Stream<String> getUserGenderInner() {
    return usersInfoCollection
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc['gender'] is String &&
          (doc['gender'] as String).isNotEmpty) {
        return doc['gender'];
      } else {
        return '';
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

  Stream<String> getRoleInner() {
    return usersInfoCollection
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc['role'] is String &&
          (doc['role'] as String).isNotEmpty) {
        print(doc['role']);
        return doc['role'];
      } else {
        print(doc['role']);
        return "nothing";
      }
    });
  }

  Stream<String> getEmailInner(){
    return usersInfoCollection
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc['email'] is String &&
          (doc['email'] as String).isNotEmpty) {
        return doc['email'];
      } else {
        print(doc['email']);
        return "nothing";
      }
    });
  }

  ////////////////////////////// doctors functions //////////////////////////////////
  /// the uid entered doesnt matter in the doctors functions... as it only matters in the Users functions

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

  //return doctors name based on his unique value
  static Stream<String> getDoctorNameInner(String email) {
    return FirebaseFirestore.instance.collection('doctorsInfo')
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

  static Stream<String> getDoctorPosition(String email) {
    return FirebaseFirestore.instance.collection('doctorsInfo')
        .doc(email)
        .snapshots()
        .map((doc) {
      if (doc['position'] is String &&
          (doc['position'] as String).isNotEmpty) {
        return doc['position'];
      } else {
        return 'אין';
      }
    });
  }

  static Stream<String> getDoctorSpeciality(String email) {
    return FirebaseFirestore.instance.collection('doctorsInfo')
        .doc(email)
        .snapshots()
        .map((doc) {
      if (doc['speciality'] is String &&
          (doc['speciality'] as String).isNotEmpty) {
        return doc['speciality'];
      } else {
        return 'אין';
      }
    });
  }

  static Stream<String> getDoctorLanguages(String email) {
    return FirebaseFirestore.instance.collection('doctorsInfo')
        .doc(email)
        .snapshots()
        .map((doc) {
      if (doc['languages'] is String &&
          (doc['languages'] as String).isNotEmpty) {
        return doc['languages'];
      } else {
        return 'אין';
      }
    });
  }

  static Stream<String> getDoctorAdditional(String email) {
    return FirebaseFirestore.instance.collection('doctorsInfo')
        .doc(email)
        .snapshots()
        .map((doc) {
      if (doc['additional_info'] is String &&
          (doc['additional_info'] as String).isNotEmpty) {
        return doc['additional_info'];
      } else {
        return 'אין';
      }
    });
  }

  static Stream<String> getDoctorUrlInner(String email) {
    return FirebaseFirestore.instance.collection('doctorsInfo')
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

  Stream<String> getDoctorSpecialtyInner(String email) {
    return doctorsInfoCollection
        .doc(email)
        .snapshots()
        .map((doc) {
      if (doc['speciality'] is String &&
          (doc['speciality'] as String).isNotEmpty) {
        return doc['speciality'];
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



  Future uploadFile(Uint8List? photo, String path, String doctor_id, String username) async {
    // doctor_id is doctor's email
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
      doctorsInfoCollection.doc(doctor_id).update({"cards": FieldValue.arrayUnion(l)});

    } catch (e) {
      print('error occured');
    }
  }
}