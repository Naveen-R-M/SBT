import 'package:SBT/screens/admin/add_category.dart';
import 'package:SBT/screens/admin/admin.dart';
import 'package:SBT/screens/admin/delete_category.dart';
import 'package:SBT/screens/home/thumnail_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../my_colors.dart';
import 'image_carousel.dart';

class HomeScreen extends StatefulWidget {
  var user;

  HomeScreen({this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum BottomIcons {
  Home,
  Cart,
  Liked,
  Purchases,
  Account,
}

class _HomeScreenState extends State<HomeScreen> {
  var title = "Categories";

  Stream checkAdmin() {
    var ref = Firestore.instance
        .collection('Users')
        .document(widget.user.uid)
        .snapshots();
    return ref;
  }

  BottomIcons bottomIcons = BottomIcons.Home;

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
          floatingActionButton: Admin.admin == true
              ? Container(
                  child: Container(
                    margin: EdgeInsets.only(right: 15, bottom: 70),
                    child: SpeedDial(
                      animatedIcon: AnimatedIcons.menu_arrow,
                      children: [
                        SpeedDialChild(
                            child: IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => DeleteCategories(
                                        val: title,
                                      )),
                            );
                          },
                        )),
                        SpeedDialChild(
                          child: IconButton(
                            icon: Icon(Icons.add_circle),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddCategories(
                                    val: title,
                                    imageURL: '',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SpeedDialChild(
                          child: IconButton(
                            icon: Icon(Icons.view_carousel),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddCategories(
                                    val: 'Carousel',
                                    imageURL: '',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SpeedDialChild(
                            child: IconButton(
                          icon: Icon(Icons.layers_clear),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => DeleteCategories(
                                        val: 'Carousel',
                                      )),
                            );
                          },
                        )),
                      ],
                    ),
                  ),
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: RefreshIndicator(
            onRefresh: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    pageBuilder: (a, b, c) => HomeScreen(
                          user: widget.user,
                        ),
                    transitionDuration: Duration(seconds: 0)),
              );
              return Future.value(false);
            },
            child: Container(
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
                      child: StreamBuilder(
                          stream: checkAdmin(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              if (snapshot.data["phone"] == "+919944274499") {
                                Admin.admin = true;
                              }
                            }
                            return Container(
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
                                    height: 15,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
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
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  LoadImages(val: 'Categories'),
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(
                          top: 15, left: 24, right: 24, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                bottomIcons = BottomIcons.Home;
                              });
                            },
                            child: bottomIcons == BottomIcons.Home
                                ? Container(
                                    padding: EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                      right: 16,
                                      left: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: MyColors.TEXT_FIELD_BCK
                                          .withOpacity(0.6),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.home),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Text(
                                          'Home',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Icon(Icons.home),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                bottomIcons = BottomIcons.Cart;
                              });
                            },
                            child: bottomIcons == BottomIcons.Cart
                                ? Container(
                                    padding: EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                      right: 16,
                                      left: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: MyColors.TEXT_FIELD_BCK
                                          .withOpacity(0.6),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.add_shopping_cart),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Text(
                                          'Cart',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Icon(Icons.add_shopping_cart),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                bottomIcons = BottomIcons.Liked;
                              });
                            },
                            child: bottomIcons == BottomIcons.Liked
                                ? Container(
                                    padding: EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                      right: 16,
                                      left: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: MyColors.TEXT_FIELD_BCK
                                          .withOpacity(0.6),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.thumb_up),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Text(
                                          'Liked',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Icon(Icons.thumb_up),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                bottomIcons = BottomIcons.Purchases;
                              });
                            },
                            child: bottomIcons == BottomIcons.Purchases
                                ? Container(
                                    padding: EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                      right: 16,
                                      left: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: MyColors.TEXT_FIELD_BCK
                                          .withOpacity(0.6),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.receipt),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Text(
                                          'Purchases',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Icon(Icons.receipt),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                bottomIcons = BottomIcons.Account;
                              });
                            },
                            child: bottomIcons == BottomIcons.Account
                                ? Container(
                                    padding: EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                      right: 16,
                                      left: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: MyColors.TEXT_FIELD_BCK
                                          .withOpacity(0.6),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.account_circle),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Text(
                                          'Account Settings',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Icon(Icons.account_circle),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
