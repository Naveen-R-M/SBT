import 'package:SBT/screens/admin/admin.dart';
import 'package:SBT/screens/home/bottom_nav/account/profile.dart';
import 'package:SBT/screens/home/bottom_nav/cart.dart';
import 'package:SBT/screens/home/bottom_nav/home.dart';
import 'package:SBT/screens/home/bottom_nav/liked.dart';
import 'package:SBT/screens/home/bottom_nav/purchases.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:SBT/screens/admin/delete_category.dart';
import '../admin/add_category.dart';
import '../../my_colors.dart';

class HomePage extends StatefulWidget {
  var user;

  HomePage({this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

enum BottomIcons {
  Home,
  Cart,
  Liked,
  Purchases,
  Account,
}

class _HomePageState extends State<HomePage> {

  var title = 'Categories';
  BottomIcons bottomIcons = BottomIcons.Home;


  String message;

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
        floatingActionButton: bottomIcons == BottomIcons.Home
            ? Admin.admin == true
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
                : null
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: RefreshIndicator(
          onRefresh: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  pageBuilder: (a, b, c) => HomePage(
                        user: widget.user,
                      ),
                  transitionDuration: Duration(seconds: 0)),
            );
            return Future.value(false);
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                bottomIcons == BottomIcons.Cart
                    ? Cart(user: widget.user,)
                    : bottomIcons == BottomIcons.Home
                    ? Home(user: widget.user,)
                    : bottomIcons == BottomIcons.Liked
                    ? Liked(user: widget.user,)
                    : bottomIcons == BottomIcons.Purchases
                    ? Purchases()
                    : bottomIcons == BottomIcons.Account
                    ? Profile():Container(),
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
                                        'Account',
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
        ),
      ),
    );
  }
}
