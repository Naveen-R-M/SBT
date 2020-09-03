import 'dart:async';

import 'package:SBT/decision.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(
   MaterialApp(
     debugShowCheckedModeBanner: false,
     title: 'SBT Shopping',
     home: MyApp(),
     routes: <String,WidgetBuilder>{
       "/decision_page": (BuildContext context) => Decide()
     },
   ) 
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset('images/sbt_splash.jpg',fit: BoxFit.cover,),
      ),
    );
  }

  @override
  void initState() {
    Timer(Duration(milliseconds: 2000),(){
      Navigator.pushReplacementNamed(context, "/decision_page");
    });
  }
}