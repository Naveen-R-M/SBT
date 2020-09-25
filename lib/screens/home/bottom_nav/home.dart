import 'package:SBT/screens/admin/admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../my_colors.dart';
import '../image_carousel.dart';
import '../thumnail_images.dart';

class Home extends StatefulWidget {
  var user;

  Home({this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var title = 'Categories';
  Stream checkAdmin() {
    var ref = Firestore.instance
        .collection('Users')
        .document(widget.user.uid)
        .snapshots();
    return ref;
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
  Widget build(BuildContext context) {
    return home();
  }
}
