import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:squabble/models/userprofile/user_profile_model.dart';
import 'package:squabble/models/userprofile/user_profile_singleton.dart';

class HomeScreen extends StatefulWidget {
  final User? userInfoDetails;
  const HomeScreen({Key? key, this.userInfoDetails}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserProfile userProfile = UserProfile(
    UserProfileSingleton().fullName,
    UserProfileSingleton().firstName,
    UserProfileSingleton().lastName,
    UserProfileSingleton().email,
    // UserProfileSingleton().password,
    UserProfileSingleton().description,
    UserProfileSingleton().location,
    UserProfileSingleton().hobbies
  );
  
  @override
  Widget _userName(context) {
    var name = userProfile.firstName;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Hey ' + name! + ",",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          )
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userName(context),
            RaisedButton(
              child: Text('Logout'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            )
          ],
        ),
      ),
    );
  }
}
