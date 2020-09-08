import 'package:SBT/my_colors.dart';
import 'package:SBT/screens/home/thumnail_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'image_carousel.dart';

class HomeScreen extends StatelessWidget {
  FirebaseUser user;
  HomeScreen({this.user});

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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: MyColors.APP_BCK,
          child: Stack(
            children: [
              ImageCarousel(collection: 'Carousel', document: 'HomePage',),
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                    top:MediaQuery.of(context).size.height / 3
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                    )
                    ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 25,
                          left: 25,
                        ),
                        child: Text(
                          'Categories',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: MyColors.TEXT_COLOR,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2
                          ),
                        ),
                      ),
                      LoadImages(val: 'Images'),
                    ],
                  ),
                  ),
              ),
            ],
          ),
          ),
  ),
    );
}
}
