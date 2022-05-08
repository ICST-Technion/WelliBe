import 'doctor.dart';

class UserClass {
  final String uid;
  String? url = 'https://www.shareicon.net/data/128x128/2015/09/24/106425_man_512x512.png';
  String? name = "אנונימי";
  List<DoctorClass> doctors = [];
  //maybe list of doctors and times they checked
  UserClass({required this.uid, required this.url, required this.name});

}

class UserData {
  final String? uid;
  String url = 'https://www.shareicon.net/data/128x128/2015/09/24/106425_man_512x512.png';
  String name = "אנונימי";
  List<DoctorClass> doctors = [];

  UserData({required this.uid, required this.url, required this.name});
}