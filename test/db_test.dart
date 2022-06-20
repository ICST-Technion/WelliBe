import 'package:test/test.dart';
import 'package:wellibe_proj/services/database.dart';

void main(){

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