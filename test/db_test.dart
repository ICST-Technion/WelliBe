import 'package:test/test.dart';
import 'package:wellibe_proj/services/database.dart';
import 'package:mockito/mockito.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:wellibe_proj/services/auth.dart';


class MDB extends Mock implements DB{

}
class MAuth extends Mock implements AuthService{
  //No usage in DB so no need of override here
}
// ask about how exactly to override user collections and override value return functions
class Users extends Mock {

}



void main(){

  //create MockDB and mock user collection and use them in testing





  group('admin tests', () {
    DatabaseService db = new DatabaseService(uid: 'hospital@gmail.com');
    test("name check", () => expect(db.getUserNameInner(), "admin"));
    test("role check", () => expect(db.getRoleInner(), "admin"));
    test("profile photo check", () => expect(db.getUrlInner(),
        "https://mssociety.org.il/wp-content/uploads/2017/08/%D7%9E%D7%A8%D7%9B%D"
            "7%96-%D7%A8%D7%A4%D7%95%D7%90%D7%99-%D7%9B%D7%A8%D7%9E%D7%9C.jpg"));
    test("email check", () => expect(db.getEmailInner(), "hospital@gmail.com"));
  });

  group('doctor tests', () {
    DatabaseService db = new DatabaseService(uid: 'mosheshahar@nana10.co.il');
    test("name check", () => expect(db.getUserNameInner(), "שחר משה"));
    test("role check", () => expect(db.getRoleInner(), "doctor"));
    test("profile photo check", () => expect(db.getUrlInner(),
        "https://st4.depositphotos.com/11634452/41441/v/1600/depositphotos_4144"
            "16674-stock-illustration-picture-profile-icon-male-icon.jpg"));
    test("email check", () => expect(db.getEmailInner(), "mosheshahar@nana10.co.il"));
  });

  
}