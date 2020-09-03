import 'package:SBT/my_colors.dart';
import 'package:SBT/screens/authentication/auth.dart';
import 'package:SBT/screens/authentication/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  FirebaseUser user;
  HomeScreen({this.user});
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: MyColors.TEXT_FIELD_BCK,
        child: FlatButton(
          child: Text('Logout'),
          onPressed: () {
            _authService.signOut();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Login()));
          },
        ),
      ),
    );
  }
}
