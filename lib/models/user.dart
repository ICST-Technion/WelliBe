import 'doctor.dart';

class SystemUsers{
  final String uid;
  String? url = 'https://www.shareicon.net/data/128x128/2015/09/24/106425_man_512x512.png';
  String? name = "אנונימי";
  SystemUsers({required this.uid, required this.url, required this.name});
}
class UserClass extends SystemUsers{
  List<DoctorClass> doctors = [];
  String role = 'user';
  UserClass({required String uid, required String? url, required String? name, required this.role}) : super(uid: uid, url: url, name: name);
  //maybe list of doctors and times they checked

}

class DoctorClass extends SystemUsers{ //url is email
  String speciality = "";
  String position = "";
  String languages = "";
  String additionalInfo = "";
  String role = 'doctor';

  DoctorClass({required String uid, required String? url, required String? name, required this.role}) : super(uid: uid, url: url, name: name);

}