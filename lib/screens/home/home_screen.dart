import 'package:SBT/screens/admin/admin.dart';
import 'package:SBT/screens/home/loading.dart';
import 'package:SBT/screens/home/thumnail_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:SBT/screens/admin/delete_category.dart';
import '../admin/add_category.dart';
import '../../my_colors.dart';
import 'image_carousel.dart';

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
  var _sold;

  _message() async {
    var ref =
        await Firestore.instance.collection('Message').document('Banner').get();
    setState(() {
      message = ref["tag"].toString();
      _sold = ref["sold"].toString();
    });
  }

  Stream checkAdmin() {
    var ref = Firestore.instance
        .collection('Users')
        .document(widget.user.uid)
        .snapshots();
    return ref;
  }

  String message;
  Stream _getImages() {
    var ref = Firestore.instance;
    return ref
        .collection('Users')
        .document(widget.user.uid)
        .collection('Cart')
        .snapshots();
  }

  liked() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                'Liked Items',
                style: TextStyle(
                    fontFamily: 'Pacifico', fontSize: 22, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            StreamBuilder(
              stream: Firestore.instance
                  .collection('Users')
                  .document(widget.user.uid)
                  .collection('Liked')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                } else {
                  var data = snapshot.data.documents;
                  return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height - 160,
                    child: ListView.builder(
                      padding: EdgeInsets.all(5),
                      itemCount: data.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var path = data[index];
                        return GestureDetector(
                          child: StreamBuilder(
                              stream: Firestore.instance
                                  .collection(path.data['category'])
                                  .document(path.data['title'])
                                  .snapshots(),
                              builder: (context, snapshot2) {
                                var data2 = snapshot2.data;
                                return data2['stockAvailable'] > 0
                                    ? data2['priority'] == "High"
                                        ? Banner(
                                            location: BannerLocation.topEnd,
                                            message: message,
                                            textStyle: TextStyle(
                                                fontSize: 10,
                                                letterSpacing: 1.25),
                                            child: Card(
                                              elevation: 10,
                                              shadowColor: MyColors
                                                  .TEXT_FIELD_BCK
                                                  .withOpacity(0.50),
                                              child: Row(
                                                children: [
                                                  Card(
                                                    shadowColor: MyColors
                                                        .STATUS_BAR
                                                        .withOpacity(0.5),
                                                    elevation: 15,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.5,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              6,
                                                      child: Image.network(
                                                        path.data["imageURL"],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 15,
                                                            right: 8.0,
                                                            top: 8.0),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            path.data['title'],
                                                            style: TextStyle(
                                                              color: MyColors
                                                                  .TEXT_COLOR,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 15,
                                                            right: 8.0,
                                                            top: 8.0,
                                                            bottom: 5),
                                                        child: Text(
                                                          '₹${path.data["cost"]}',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: MyColors
                                                                .TEXT_COLOR,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Card(
                                            elevation: 10,
                                            shadowColor: MyColors.TEXT_FIELD_BCK
                                                .withOpacity(0.50),
                                            child: Row(
                                              children: [
                                                Card(
                                                  shadowColor: MyColors
                                                      .STATUS_BAR
                                                      .withOpacity(0.5),
                                                  elevation: 15,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            6,
                                                    child: Image.network(
                                                      path.data["imageURL"],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 15,
                                                          right: 8.0,
                                                          top: 8.0),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          path.data['title'],
                                                          style: TextStyle(
                                                            color: MyColors
                                                                .TEXT_COLOR,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 15,
                                                          right: 8.0,
                                                          top: 8.0,
                                                          bottom: 5),
                                                      child: Text(
                                                        '₹${path.data["cost"]}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: MyColors
                                                              .TEXT_COLOR,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                    : Banner(
                                        location: BannerLocation.topEnd,
                                        message: _sold,
                                        textStyle: TextStyle(
                                            fontSize: 10, letterSpacing: 1.25),
                                        child: Card(
                                          elevation: 10,
                                          shadowColor: MyColors.TEXT_FIELD_BCK
                                              .withOpacity(0.50),
                                          child: Row(
                                            children: [
                                              Card(
                                                shadowColor: MyColors.STATUS_BAR
                                                    .withOpacity(0.5),
                                                elevation: 15,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      6,
                                                  child: Image.network(
                                                    path.data["imageURL"],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15,
                                                        right: 8.0,
                                                        top: 8.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        path.data['title'],
                                                        style: TextStyle(
                                                          color: MyColors
                                                              .TEXT_COLOR,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15,
                                                        right: 8.0,
                                                        top: 8.0,
                                                        bottom: 5),
                                                    child: Text(
                                                      '₹${path.data["cost"]}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            MyColors.TEXT_COLOR,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                              }),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  cart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                'Your Cart',
                style: TextStyle(
                    fontFamily: 'Pacifico', fontSize: 22, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            StreamBuilder(
              stream: _getImages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                } else {
                  var data = snapshot.data.documents;
                  return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height - 160,
                    child: ListView.builder(
                      padding: EdgeInsets.all(5),
                      itemCount: data.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var path = data[index];
                        return GestureDetector(
                          child: StreamBuilder(
                              stream: Firestore.instance
                                  .collection(path.data['category'])
                                  .document(path.data['title'])
                                  .snapshots(),
                              builder: (context, snapshot2) {
                                var data2 = snapshot2.data;
                                return data2['stockAvailable'] > 0
                                    ? data2['priority'] == "High"
                                        ? Banner(
                                            location: BannerLocation.topEnd,
                                            message: message,
                                            textStyle: TextStyle(
                                                fontSize: 10,
                                                letterSpacing: 1.25),
                                            child: Card(
                                              elevation: 10,
                                              shadowColor: MyColors
                                                  .TEXT_FIELD_BCK
                                                  .withOpacity(0.50),
                                              child: Row(
                                                children: [
                                                  Card(
                                                    shadowColor: MyColors
                                                        .STATUS_BAR
                                                        .withOpacity(0.5),
                                                    elevation: 15,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.5,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              4.4,
                                                      child: Image.network(
                                                        path.data["imageURL"],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 15,
                                                            right: 8.0,
                                                            top: 8.0),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            path.data['title'],
                                                            style: TextStyle(
                                                              color: MyColors
                                                                  .TEXT_COLOR,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 15,
                                                            right: 8.0,
                                                            top: 8.0,
                                                            bottom: 5),
                                                        child: Text(
                                                          '₹${path.data["cost"]}',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: MyColors
                                                                .TEXT_COLOR,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 5.0,
                                                            left: 10.0),
                                                        width: 140,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child: StreamBuilder(
                                                            stream: Firestore
                                                                .instance
                                                                .collection(
                                                                    'Users')
                                                                .document(widget
                                                                    .user.uid)
                                                                .collection(
                                                                    'Cart')
                                                                .snapshots(),
                                                            builder: (context,
                                                                snapshot) {
                                                              var dataCount =
                                                                  snapshot
                                                                      .data
                                                                      .documents
                                                                      .length;
                                                              print(dataCount);
                                                              for (var i = 0;
                                                                  i < dataCount;
                                                                  i++) {
                                                                if (snapshot.data
                                                                            .documents[i]
                                                                        [
                                                                        'title'] ==
                                                                    title) {}
                                                              }
                                                              return OutlineButton(
                                                                onPressed:
                                                                    () {},
                                                                highlightedBorderColor:
                                                                    MyColors
                                                                        .TEXT_COLOR,
                                                                highlightColor:
                                                                    MyColors
                                                                        .TEXT_FIELD_BCK,
                                                                splashColor:
                                                                    MyColors
                                                                        .TEXT_COLOR,
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: MyColors
                                                                      .TEXT_FIELD_BCK,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid,
                                                                  width: 2,
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .add_shopping_cart,
                                                                      color: MyColors
                                                                          .TEXT_COLOR,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        'REMOVE FROM CART',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              MyColors.TEXT_COLOR,
                                                                          fontFamily:
                                                                              'Lato',
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 5.0,
                                                            bottom: 15.0,
                                                            left: 10.0),
                                                        width: 140,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        child: OutlineButton(
                                                          onPressed: () {},
                                                          highlightedBorderColor:
                                                              MyColors
                                                                  .TEXT_COLOR,
                                                          highlightColor: MyColors
                                                              .TEXT_FIELD_BCK,
                                                          splashColor: MyColors
                                                              .TEXT_COLOR,
                                                          borderSide:
                                                              BorderSide(
                                                            color: MyColors
                                                                .TEXT_FIELD_BCK,
                                                            style: BorderStyle
                                                                .solid,
                                                            width: 2,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .monetization_on,
                                                                color: MyColors
                                                                    .TEXT_COLOR,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  'BOOK NOW',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: MyColors
                                                                        .TEXT_COLOR,
                                                                    fontFamily:
                                                                        'Lato',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Card(
                                            elevation: 10,
                                            shadowColor: MyColors.TEXT_FIELD_BCK
                                                .withOpacity(0.50),
                                            child: Row(
                                              children: [
                                                Card(
                                                  shadowColor: MyColors
                                                      .STATUS_BAR
                                                      .withOpacity(0.5),
                                                  elevation: 15,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            4.4,
                                                    child: Image.network(
                                                      path.data["imageURL"],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 15,
                                                          right: 8.0,
                                                          top: 8.0),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          path.data['title'],
                                                          style: TextStyle(
                                                            color: MyColors
                                                                .TEXT_COLOR,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 15,
                                                          right: 8.0,
                                                          top: 8.0,
                                                          bottom: 5),
                                                      child: Text(
                                                        '₹${path.data["cost"]}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: MyColors
                                                              .TEXT_COLOR,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10.0,
                                                          bottom: 5.0,
                                                          left: 10.0),
                                                      width: 140,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      child: StreamBuilder(
                                                          stream: Firestore
                                                              .instance
                                                              .collection(
                                                                  'Users')
                                                              .document(widget
                                                                  .user.uid)
                                                              .collection(
                                                                  'Cart')
                                                              .snapshots(),
                                                          builder: (context,
                                                              snapshot) {
                                                            var dataCount =
                                                                snapshot
                                                                    .data
                                                                    .documents
                                                                    .length;
                                                            print(dataCount);
                                                            for (var i = 0;
                                                                i < dataCount;
                                                                i++) {
                                                              if (snapshot.data
                                                                          .documents[i]
                                                                      [
                                                                      'title'] ==
                                                                  title) {}
                                                            }
                                                            return OutlineButton(
                                                              onPressed: () {},
                                                              highlightedBorderColor:
                                                                  MyColors
                                                                      .TEXT_COLOR,
                                                              highlightColor:
                                                                  MyColors
                                                                      .TEXT_FIELD_BCK,
                                                              splashColor:
                                                                  MyColors
                                                                      .TEXT_COLOR,
                                                              borderSide:
                                                                  BorderSide(
                                                                color: MyColors
                                                                    .TEXT_FIELD_BCK,
                                                                style:
                                                                    BorderStyle
                                                                        .solid,
                                                                width: 2,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .add_shopping_cart,
                                                                    color: MyColors
                                                                        .TEXT_COLOR,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      'REMOVE FROM CART',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: MyColors
                                                                            .TEXT_COLOR,
                                                                        fontFamily:
                                                                            'Lato',
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 5.0,
                                                          bottom: 15.0,
                                                          left: 10.0),
                                                      width: 140,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                      child: OutlineButton(
                                                        onPressed: () {},
                                                        highlightedBorderColor:
                                                            MyColors.TEXT_COLOR,
                                                        highlightColor: MyColors
                                                            .TEXT_FIELD_BCK,
                                                        splashColor:
                                                            MyColors.TEXT_COLOR,
                                                        borderSide: BorderSide(
                                                          color: MyColors
                                                              .TEXT_FIELD_BCK,
                                                          style:
                                                              BorderStyle.solid,
                                                          width: 2,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .monetization_on,
                                                              color: MyColors
                                                                  .TEXT_COLOR,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                'BOOK NOW',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: MyColors
                                                                      .TEXT_COLOR,
                                                                  fontFamily:
                                                                      'Lato',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                    : Banner(
                                        location: BannerLocation.topEnd,
                                        message: _sold,
                                        textStyle: TextStyle(
                                            fontSize: 10, letterSpacing: 1.25),
                                        child: Card(
                                          elevation: 10,
                                          shadowColor: MyColors.TEXT_FIELD_BCK
                                              .withOpacity(0.50),
                                          child: Row(
                                            children: [
                                              Card(
                                                shadowColor: MyColors.STATUS_BAR
                                                    .withOpacity(0.5),
                                                elevation: 15,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      4.4,
                                                  child: Image.network(
                                                    path.data["imageURL"],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15,
                                                        right: 8.0,
                                                        top: 8.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        path.data['title'],
                                                        style: TextStyle(
                                                          color: MyColors
                                                              .TEXT_COLOR,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15,
                                                        right: 8.0,
                                                        top: 8.0,
                                                        bottom: 5),
                                                    child: Text(
                                                      '₹${path.data["cost"]}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            MyColors.TEXT_COLOR,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10.0,
                                                        bottom: 5.0,
                                                        left: 10.0),
                                                    width: 140,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    child: StreamBuilder(
                                                        stream: Firestore
                                                            .instance
                                                            .collection('Users')
                                                            .document(
                                                                widget.user.uid)
                                                            .collection('Cart')
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          var dataCount =
                                                              snapshot
                                                                  .data
                                                                  .documents
                                                                  .length;
                                                          print(dataCount);
                                                          for (var i = 0;
                                                              i < dataCount;
                                                              i++) {
                                                            if (snapshot.data
                                                                        .documents[i]
                                                                    ['title'] ==
                                                                title) {}
                                                          }
                                                          return OutlineButton(
                                                            onPressed: () {},
                                                            highlightedBorderColor:
                                                                MyColors
                                                                    .TEXT_COLOR,
                                                            highlightColor: MyColors
                                                                .TEXT_FIELD_BCK,
                                                            splashColor:
                                                                MyColors
                                                                    .TEXT_COLOR,
                                                            borderSide:
                                                                BorderSide(
                                                              color: MyColors
                                                                  .TEXT_FIELD_BCK,
                                                              style: BorderStyle
                                                                  .solid,
                                                              width: 2,
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .add_shopping_cart,
                                                                  color: MyColors
                                                                      .TEXT_COLOR,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    'REMOVE FROM CART',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: MyColors
                                                                          .TEXT_COLOR,
                                                                      fontFamily:
                                                                          'Lato',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 5.0,
                                                        bottom: 15.0,
                                                        left: 10.0),
                                                    width: 140,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: OutlineButton(
                                                      onPressed: () {},
                                                      highlightedBorderColor:
                                                          MyColors.TEXT_COLOR,
                                                      highlightColor: MyColors
                                                          .TEXT_FIELD_BCK,
                                                      splashColor:
                                                          MyColors.TEXT_COLOR,
                                                      borderSide: BorderSide(
                                                        color: MyColors
                                                            .TEXT_FIELD_BCK,
                                                        style:
                                                            BorderStyle.solid,
                                                        width: 2,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .monetization_on,
                                                            color: MyColors
                                                                .TEXT_COLOR,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              'BOOK NOW',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: MyColors
                                                                    .TEXT_COLOR,
                                                                fontFamily:
                                                                    'Lato',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                              }),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  home() {
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
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
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
                          LoadImages(val: title),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _message();
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
                    ? cart()
                    : bottomIcons == BottomIcons.Home
                        ? home()
                        : bottomIcons == BottomIcons.Liked
                            ? liked()
                            : Container(),
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
