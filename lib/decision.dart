import 'package:SBT/screens/authentication/auth.dart';
import 'package:SBT/screens/authentication/login.dart';
import 'package:SBT/screens/home/home_page.dart';
import 'package:flutter/material.dart';

class Decide extends StatefulWidget {
  @override
  _DecideState createState() => _DecideState();
}

AuthService _authService = AuthService();
bool flag;
currentUser()async{
  dynamic user = await _authService.currentUser();
  if(user!=null){
    flag = true;
    print(user);
  }else{
    print(user);
    flag = false;
  }
  return user;
}

class _DecideState extends State<Decide> {

  @override
  Widget build(BuildContext context) {
    return flag == true ? HomeScreen():Login();
  }

  @override
  void initState() {
    currentUser();
  }
}
