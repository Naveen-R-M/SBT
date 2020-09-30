import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../my_colors.dart';
import '../loading.dart';

class Liked extends StatefulWidget {
  var user;

  Liked({this.user});

  @override
  _LikedState createState() => _LikedState();
}

class _LikedState extends State<Liked> {
  String message;
  String sold;

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
                    fontFamily: 'Pacifico', fontSize: 20, color: Colors.black),
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
                                              data2["imageURL"],
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
                                                  data2['name'],
                                                  style: TextStyle(
                                                    color: MyColors
                                                        .TEXT_COLOR,
                                                    fontFamily: 'Pacifico',
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
                                                '₹${data2["cost"]}',
                                                textAlign:
                                                TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Pacifico',
                                                  color: MyColors
                                                      .TEXT_COLOR,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 15,
                                                  right: 8.0,
                                                  top: 8.0,
                                                  bottom: 5),
                                              child: OutlineButton(
                                                onPressed:()async{
                                                  var ref = await Firestore.instance
                                                      .collection('Users')
                                                      .document(widget
                                                      .user.uid)
                                                      .collection('Liked')
                                                      .document(path.documentID);
                                                  await ref.delete();
                                                },
                                                child: Text('REMOVE FROM LIKED'),
                                                highlightedBorderColor: MyColors.TEXT_COLOR,
                                                highlightColor: MyColors.TEXT_FIELD_BCK,
                                                splashColor: MyColors.TEXT_COLOR,
                                                borderSide: BorderSide(
                                                  color: MyColors.TEXT_FIELD_BCK,
                                                  style: BorderStyle.solid,
                                                  width: 2,
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
                                            data2["imageURL"],
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
                                                data2['name'],
                                                style: TextStyle(
                                                  fontFamily: 'Pacifico',
                                                  color: MyColors
                                                      .TEXT_COLOR,
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
                                              '₹${data2["cost"]}',
                                              textAlign:
                                              TextAlign.center,
                                              style: TextStyle(
                                                color: MyColors
                                                    .TEXT_COLOR,
                                                fontFamily: 'Pacifico',
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 15,
                                                right: 8.0,
                                                top: 8.0,
                                                bottom: 5),
                                            child: OutlineButton(
                                              onPressed:()async{
                                                var ref = await Firestore.instance
                                                    .collection('Users')
                                                    .document(widget
                                                    .user.uid)
                                                    .collection('Liked')
                                                    .document(path.documentID);
                                                await ref.delete();
                                              },
                                              child: Text('REMOVE FROM LIKED'),
                                              highlightedBorderColor: MyColors.TEXT_COLOR,
                                              highlightColor: MyColors.TEXT_FIELD_BCK,
                                              splashColor: MyColors.TEXT_COLOR,
                                              borderSide: BorderSide(
                                                color: MyColors.TEXT_FIELD_BCK,
                                                style: BorderStyle.solid,
                                                width: 2,
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
                                  message: sold,
                                  textStyle: TextStyle(
                                      fontSize: 10, letterSpacing: 1.25),
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
                                              data2["imageURL"],
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
                                                  data2['name'],
                                                  style: TextStyle(
                                                    color: MyColors
                                                        .TEXT_COLOR,
                                                    fontFamily: 'Pacifico',
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
                                                '₹${data2["cost"]}',
                                                textAlign:
                                                TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Pacifico',
                                                  color: MyColors
                                                      .TEXT_COLOR,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 15,
                                                  right: 8.0,
                                                  top: 8.0,
                                                  bottom: 5),
                                              child: OutlineButton(
                                                onPressed:()async{
                                                  var ref = await Firestore.instance
                                                      .collection('Users')
                                                      .document(widget
                                                      .user.uid)
                                                      .collection('Liked')
                                                      .document(path.documentID);
                                                  await ref.delete();
                                                },
                                                child: Text('REMOVE FROM LIKED'),
                                                highlightedBorderColor: MyColors.TEXT_COLOR,
                                                highlightColor: MyColors.TEXT_FIELD_BCK,
                                                splashColor: MyColors.TEXT_COLOR,
                                                borderSide: BorderSide(
                                                  color: MyColors.TEXT_FIELD_BCK,
                                                  style: BorderStyle.solid,
                                                  width: 2,
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

  @override
  Widget build(BuildContext context) {
    return liked();
  }

  _message() async {
    var ref =
    await Firestore.instance.collection('Message').document('Banner').get();
    setState(() {
      message = ref["tag"].toString();
      sold = ref["sold"].toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _message();
  }
}
