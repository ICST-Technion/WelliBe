import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:wellibe_proj/services/auth.dart';
import 'package:wellibe_proj/services/database.dart';

class MockUser extends Mock implements User {
  String uid = ""; // User's uid is not settable, so we define it as a field in our MockUser
}

class MockUserCredential extends Mock implements UserCredential {
  MockUser? user; // MockUserCredential has our MockUser as its user field
}

class MAuth extends Mock implements FirebaseAuth {
  Map<String, String> users = Map(); // a map to save tests' user data

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email, // test email
    required String password, // test password
  }) async {
    users[email] = password; // save user data in a global map

    MockUserCredential mockUser = MockUserCredential(); // create mock user credentials
    mockUser.user = MockUser();
    mockUser.user!.uid = email + password; // create a fake and unique uid
    return Future.delayed(Duration.zero, () { // return a future to override firebase's function
      return mockUser;
    });
  }

  // mock sign in option with email and password
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email, // test email
    required String password, // test password
  }) async {
    MockUserCredential mockUser = MockUserCredential(); // create a mock user using our mock user
    // to simulate sign in, save credentials in a global map
    if(users.containsKey(email) && users[email] == password) {
      mockUser.user = MockUser(); // add a user mock user to the credential "after" sign in
      mockUser.user!.uid = email + password; // create a fake and unique uid
      return Future.delayed(Duration.zero, () { // override firebase's by returning future
        return mockUser;
      });
    }
    else {
      mockUser.user = null; // the sign in is not successful, return null as the user for our DB
      return Future.delayed(Duration.zero, () { // override firebase's by returning future
        return mockUser;
      });
    }
  }

  @override
  Future<void> signOut() async {
    return Future.delayed(Duration.zero, () { // nothing to do here
      return true;
    });
  }
}

void main() async {
  var fakeFirestore = FakeFirebaseFirestore(); // fake firestore to simulate firestore accesses
  final mockUsersInfo = fakeFirestore.collection('usersInfo'); // fake users collection
  final mockDoctorsInfo = fakeFirestore.collection('doctorsInfo'); // fake doctors collection
  MAuth mockAuth = MAuth(); // our mock authentication class

  final AuthService auth = AuthService(authMock: mockAuth,
      usersInfoMock: mockUsersInfo,
      doctorsInfoMock: mockDoctorsInfo);

  // tests for the authentication of users and doctors
  group("auth tests", () {
    // auth tests that focus on the user side
    group("user tests", () {
      // creating a new account
      test("create accounts", () async {
        await auth.registerWithEmailAndPassword(
            "user", "user@gmail.com", "123456");
      });

      // testing a successful sign in
      test("good sign in", () async {
        expect(
            await auth.signInWithEmailAndPassword("user@gmail.com", "123456"),
            isNot(null)
        );
      });

      // testing an unsuccessful sign in
      test("bad sign in", () async {
        expect(
            await auth.signInWithEmailAndPassword("other", "123456"),
            null
        );
        expect(
            await auth.signInWithEmailAndPassword("user@gmail.com", "other"),
            null
        );
      });

      // testing a user sign out
      test("sign out", () async {
        expect(
            await auth.signOut(),
            true
        );
      });
    });

    // auth tests that focus on the doctor side
    group("doctor tests", () {
      // test creation of a doctor account
      test("create accounts", () async {
        await auth.doctorRegisterWithEmailAndPassword(
            "doctor", "doctor@gmail.com", "123456", "position", "speciality");
      });

      // test a successful sign in
      test("good sign in", () async {
        expect(
            await auth.signInWithEmailAndPassword("doctor@gmail.com", "123456"),
            isNot(null)
        );
      });
    });
  });

  // tests for database functions
  group("database tests", () {
    // fake user id the database requires
    final userUid = "user@gmail.com" + "123456";
    DB mockDB = DB(mockUsersInfo, mockDoctorsInfo, uid: userUid);

    // database tests the focus on the user functions
    group("user tests", () {
      // update user details with many functions
      test("update details", () async {
        await mockDB.updateUserProfilePhoto('new_profile_picture');
        expect(
            (await mockUsersInfo.doc(userUid).get())['url'],
            'new_profile_picture'
        );

        await mockDB.updateUserGender('new_gender');
        expect(
            (await mockUsersInfo.doc(userUid).get())['gender'],
            'new_gender'
        );

        await mockDB.updateUserName("new_name");
        expect(
            (await mockUsersInfo.doc(userUid).get())['name'],
            'new_name'
        );

        await mockDB.updateUserAge("22");
        expect(
            (await mockUsersInfo.doc(userUid).get())['age'],
            '22'
        );
      });

      // output all users and check database function
      test("get all users", () async {
        List ls = [];
        QuerySnapshot querySnapshot = await mockUsersInfo.get();
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          var a = querySnapshot.docs[i].data();
          ls.add(a);
        }
        expect(
            await mockDB.getUsers(),
            ls
        );
      });
    });

    // database tests the focus on the doctor functions
    group("doctor tests", () {
      // fake doctor email
      String doctorEmail = "doctor@gmail.com";
      // update doctor details with many functions
      test("update details", () async {
        await mockDB.updateDoctorName('new_doctor_name', doctorEmail);
        expect(
            (await mockDoctorsInfo.doc(doctorEmail).get())['name'],
            'new_doctor_name'
        );

        await mockDB.updateDoctorAbout('new_about', doctorEmail);
        expect(
            (await mockDoctorsInfo.doc(doctorEmail).get())['additional_info'],
            'new_about'
        );

        await mockDB.updateDoctorLang('new_languages', doctorEmail);
        expect(
            (await mockDoctorsInfo.doc(doctorEmail).get())['languages'],
            'new_languages'
        );

        await mockDB.updateDoctorPos('new_position', doctorEmail);
        expect(
            (await mockDoctorsInfo.doc(doctorEmail).get())['position'],
            'new_position'
        );

        await mockDB.updateDoctorSpeciality('new_speciality', doctorEmail);
        expect(
            (await mockDoctorsInfo.doc(doctorEmail).get())['speciality'],
            'new_speciality'
        );
      });

      // get all doctors and compare to the fake firestore output
      test("get all doctors", () async {
        List ls = [];
        QuerySnapshot querySnapshot = await mockDoctorsInfo.get();
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          var a = querySnapshot.docs[i].data();
          ls.add(a);
        }
        expect(
            await mockDB.getDocs(),
            ls
        );
      });
    });
  });
}