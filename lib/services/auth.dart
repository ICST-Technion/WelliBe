//firebase authentication backend communication
import 'package:firebase_auth/firebase_auth.dart';

import 'package:wellibe_proj/services/database.dart';
import 'package:wellibe_proj/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late UserClass? _currentUser = _userFromFirebaseUser(_auth.currentUser);
  //UserClass get currentUser => _currentUser;

  //create user object
  UserClass? _userFromFirebaseUser(User? user){
    return user != null ? UserClass(uid: user.uid, url: user.photoURL, name: user.displayName, role: 'user') : null;
  }

  DoctorClass? _doctorFromFirebaseUser(User? user, String email){
    return user != null ? DoctorClass(uid: email, url: user.photoURL, name: user.displayName, role: 'doctor') : null;
  }


  SystemUsers? _systemUserFromFirebase(User? user){
    return user != null ? SystemUsers(uid: user.uid, url: user.photoURL, name: user.displayName) : null;
  }

  //auth change user stream
  Stream<UserClass?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }


  //sign in anon- dont think we need this
  Future signInAnon() async{
    try{
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!)!;
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      //create a new document for the user with the uid
      //await DatabaseService(uid: user?.uid);
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
    }
    
  }

  //register with email and password
  //here we need to call the database service function updateUserData inorder to create new user in firebase
  Future registerWithEmailAndPassword(String name, String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      //create a new document for the user with the uid
      await DatabaseService(uid: user?.uid).updateUserData('https://st4.depositphotos.com/11634452/41441/v/1600/depositphotos_414416674-stock-illustration-picture-profile-icon-male-icon.jpg', name, email, password, 'user');
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
    }
  }

  Future doctorRegisterWithEmailAndPassword(String name, String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      //create a new document for the user with the uid
      await DatabaseService(uid: user?.uid).updateDoctorData('https://st4.depositphotos.com/11634452/41441/v/1600/depositphotos_414416674-stock-illustration-picture-profile-icon-male-icon.jpg', name, "", '', '', '', email);
      await DatabaseService(uid: user?.uid).updateUserData('https://st4.depositphotos.com/11634452/41441/v/1600/depositphotos_414416674-stock-illustration-picture-profile-icon-male-icon.jpg', name, email, password, 'doctor');
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
    }
  }
  //sign out
  Future signOut() async {
    try{
      //_auth.currentUser?.delete();
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  User? getCurrentUser(){
    return _auth.currentUser;
  }

  //supposed to be in database services
  String? returnUrl() {
    try{
      var u = _userFromFirebaseUser(_auth.currentUser);
      return u != null ? u.url : '';
    } catch(e){
      print(e.toString());
      return '';
    }
  }

  Future<void> sendResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('הסיסמה אותחלה ונשלחה');
    }
    catch (e) {
      print('כתובת מייל לא קיימת');
    }
  }

  // Future _populateCurrentUser(User user) async{
  //   DatabaseService _data = DatabaseService(uid: _auth.currentUser?.uid);
  //   if(user!=null){
  //     _currentUser = await _data.getUser(_auth.currentUser?.uid);
  //   }
  // }
}