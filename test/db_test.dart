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
}