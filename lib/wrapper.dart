import 'package:SBT/screens/authentication/login.dart';
import 'package:SBT/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user !=null){
      return HomePage(user: user,);
    }else{
      return Login();
    }
  }
}
