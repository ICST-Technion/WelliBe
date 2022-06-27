import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:wellibe_proj/services/auth.dart';
import 'package:wellibe_proj/services/database.dart';

class MockUser extends Mock implements User {
  String uid = "";
}

class MockUserCredential extends Mock implements UserCredential {
  MockUser? user;
}

class MAuth extends Mock implements FirebaseAuth {
  Map<String, String> users = Map();

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    users[email] = password;

    MockUserCredential mockUser = MockUserCredential();
    mockUser.user = MockUser();
    mockUser.user!.uid = email + password;
    return Future.delayed(Duration.zero, () {
      return mockUser;
    });
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    MockUserCredential mockUser = MockUserCredential();
    if(users.containsKey(email) && users[email] == password) {
      mockUser.user = MockUser();
      mockUser.user!.uid = email + password;
      return Future.delayed(Duration.zero, () {
        return mockUser;
      });
    }
    else {
      mockUser.user = null;
      return Future.delayed(Duration.zero, () {
        return mockUser;
      });
    }
  }

  @override
  Future<void> signOut() async {
    return Future.delayed(Duration.zero, () {
      return true;
    });
  }
}

void main() async {
  var fakeFirestore = FakeFirebaseFirestore();
  final mockUsersInfo = fakeFirestore.collection('usersInfo');
  final mockDoctorsInfo = fakeFirestore.collection('doctorsInfo');
  MAuth mockAuth = MAuth();

  final AuthService auth = AuthService(authMock: mockAuth,
      usersInfoMock: mockUsersInfo,
      doctorsInfoMock: mockDoctorsInfo);

  group("auth tests", () {
    group("user tests", () {
      test("create accounts", () async {
        await auth.registerWithEmailAndPassword(
            "user", "user@gmail.com", "123456");
      });

      test("good sign in", () async {
        expect(
            await auth.signInWithEmailAndPassword("user@gmail.com", "123456"),
            isNot(null)
        );
      });

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

      test("sign out", () async {
        expect(
            await auth.signOut(),
            true
        );
      });
    });

    group("doctor tests", () {
      test("create accounts", () async {
        await auth.doctorRegisterWithEmailAndPassword(
            "doctor", "doctor@gmail.com", "123456", "position", "speciality");
      });

      test("good sign in", () async {
        expect(
            await auth.signInWithEmailAndPassword("doctor@gmail.com", "123456"),
            isNot(null)
        );
      });
    });
  });

  group("database tests", () {
    final userUid = "user@gmail.com" + "123456";
    DB mockDB = DB(mockUsersInfo, mockDoctorsInfo, uid: userUid);

    group("user tests", () {
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

    group("doctor tests", () {
      String doctorEmail = "doctor@gmail.com";
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