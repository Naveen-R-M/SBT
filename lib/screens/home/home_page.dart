import 'package:SBT/my_colors.dart';
import 'package:SBT/screens/home/loading.dart';
import 'package:SBT/screens/home/thumnail_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'image_carousel.dart';

class HomeScreen extends StatefulWidget {
  var user;

  HomeScreen({this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool admin = false;

  Stream checkAdmin() {
    var ref = Firestore.instance
        .collection('Users')
        .document(widget.user.uid)
        .snapshots();
    return ref;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: MyColors.APP_BCK,
        accentColor: MyColors.TEXT_FIELD_BCK,
      ),
      home: Scaffold(
          body: StreamBuilder(
        stream: checkAdmin(),
        builder: (context, snapshot) {
          var adminNo = snapshot.data["phone"];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else {
            if(adminNo=="+919944862232"){
              admin = true;
            }
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: MyColors.APP_BCK,
              child: Stack(
                children: [
                  ImageCarousel(
                    collection: 'Carousel',
                    document: 'HomePage',
                  ),
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 3),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  top: 25,
                                  left: 25,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Image(
                                        image: AssetImage('images/sbt.png'),
                                        fit: BoxFit.cover,
                                        height: 35,
                                        width: 35,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Categories',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: MyColors.TEXT_COLOR,
                                            fontSize: 22,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              admin == true ? Container(
                                margin: EdgeInsets.all(18),
                                alignment: Alignment.centerRight,
                                width: MediaQuery.of(context).size.width,
                                child: IconButton(
                                  iconSize: 38,
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: MyColors.TEXT_COLOR,
                                  ),
                                  onPressed: null,
                                ),
                              ):Container(),
                            ],
                          ),
                          LoadImages(val: 'Categories'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      )),
    );
  }
}
