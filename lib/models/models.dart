// basic user class (includes doctors, users, and admin)
class SystemUsers {
  final String uid;
  String? url = 'https://www.shareicon.net/data/128x128/2015/09/24/106425_man_512x512.png';
  String? name = "אנונימי";

  SystemUsers({required this.uid, required this.url, required this.name});
}

// basic patient class
class UserClass {
  final String uid;
  String? url = 'https://www.shareicon.net/data/128x128/2015/09/24/106425_man_512x512.png';
  String? name = "אנונימי";
  List<DoctorClass> doctors = [];
  String role = 'user';

  UserClass({required this.uid,  this.url, this.name});
}

// basic doctor class that extends the basic system user
class DoctorClass extends SystemUsers {
  String speciality = "";
  String position = "";
  String languages = "";
  String additionalInfo = "";
  String role = 'doctor';

  DoctorClass({required String uid, required String? url, required String? name, required this.role}) : super(uid: uid, url: url, name: name);
}
