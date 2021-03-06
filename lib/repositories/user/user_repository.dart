import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:squabble/models/userprofile/user_profile_model.dart';
import 'package:squabble/models/userprofile/user_profile_singleton.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserProfile userProfile = UserProfile(
    UserProfileSingleton().fullName,
    UserProfileSingleton().firstName,
    UserProfileSingleton().lastName,
    UserProfileSingleton().email,
    // UserProfileSingleton().password,
    UserProfileSingleton().description,
    UserProfileSingleton().location,
    UserProfileSingleton().hobbies,
  );

  UserRepository({
    FirebaseAuth? firebaseAuth
  }) :  _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> signInWithCredentials(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // userProfile.password = password;
    userProfile.email = email;
    User user = userCredential.user!;
    await FirebaseFirestore.instance
      .collection('userProfile')
      .doc(user.uid)
      .update({
        // "password": password,
        "email": email,
      });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String description,
    required String location,
    required String hobbies,
  }) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User user = userCredential.user!;
    user.updateDisplayName(firstName);

    userProfile.email = email;
    // userProfile.password = password;
    userProfile.fullName = '$firstName $lastName';
    userProfile.firstName = firstName;
    userProfile.lastName = lastName;
    userProfile.description = description;
    userProfile.location = location;
    userProfile.hobbies = hobbies;
    await FirebaseFirestore.instance
      .collection('userProfile')
      .doc(user.uid)
      .set(userProfile.toJson());
  }

  Future signOut() async {
    return Future.wait([
      _firebaseAuth.signOut()
    ]);
  }

  bool isSignedIn() {
    final currentUser = _firebaseAuth.currentUser;
    log((currentUser != null).toString());
    return currentUser != null;
  }

  User getUser() {
    return _firebaseAuth.currentUser!;
  }

  // Create a function that gets all users from Firebase
  Future<List<UserProfile>> getAllUsers() async {
    List<UserProfile> userProfile = <UserProfile>[];
    var docs = FirebaseFirestore.instance.collection('userProfile').get();
    await docs.then((doc) {
      for (var doc in doc.docs) {
        userProfile.add(UserProfile.fromJson(doc.data()));
      }
    });
    return userProfile;
  }
}
