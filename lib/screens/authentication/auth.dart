import 'package:SBT/screens/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SBT/model/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  Future<bool> loginUser(
      String phone, BuildContext context, otp1, otp2, otp3, otp4, otp5, otp6) async {
    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        AuthResult authResult = await _auth.signInWithCredential(credential);
        FirebaseUser user = authResult.user;
        if (user != null) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomeScreen(user: user),
          ));
        }
      },
      verificationFailed: (AuthException exception) async {
        var result = await AuthException;
        print(result);
      },
      codeSent: (String verificationId, [int forceResendingToken]) async {
        String code = otp1 + otp2 + otp3 + otp4 + otp5 + otp6;
        AuthCredential credential = PhoneAuthProvider.getCredential(
            verificationId: verificationId, smsCode: code);
        AuthResult authResult = await _auth.signInWithCredential(credential);
        FirebaseUser user = authResult.user;
        if (user != null) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomeScreen(user: user),
          ));
        }
      },
      codeAutoRetrievalTimeout: null,
    );
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
  Future currentUser()async{
    final FirebaseUser user = await _auth.currentUser();
    return user!=null?user.uid:null;
  }
}
