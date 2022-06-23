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
  final fakeFirestore = FakeFirebaseFirestore();
  final mockUsersInfo = fakeFirestore.collection('usersInfo');
  final mockDoctorsInfo = fakeFirestore.collection('doctorsInfo');
  MAuth mockAuth = MAuth();

  final AuthService auth = AuthService(authMock: mockAuth, usersInfoMock: mockUsersInfo, doctorsInfoMock: mockDoctorsInfo);

  group("auth tests", () {
    group("user tests", () {
      test("create accounts", () async {
        await auth.registerWithEmailAndPassword("user", "user@gmail.com", "123456");
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
        await auth.doctorRegisterWithEmailAndPassword("doctor", "doctor@gmail.com", "123456", "position", "speciality");
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

    test("update profile picture", () async {
      await mockDB.updateUserProfilePhoto('new_profile_picture');
      expect(
          (await mockUsersInfo.doc(userUid).get())['url'],
        'new_profile_picture'
      );
    });


  });
}