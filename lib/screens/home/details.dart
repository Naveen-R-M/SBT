import 'package:SBT/my_colors.dart';
import 'package:SBT/screens/home/item_view.dart';
import 'package:SBT/screens/home/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class Details extends StatelessWidget {
  String title;

  Details({this.title,});

  Future _getImages() async {
    var ref = Firestore.instance;
    QuerySnapshot qnRef = await ref.collection(title).getDocuments();
    return qnRef.documents;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.APP_BCK.withOpacity(0.35),
    ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.APP_BCK,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: MyColors.TEXT_COLOR
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _getImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else {
            return Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                padding: EdgeInsets.all(5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height /1.6),
                ),
                itemCount: snapshot.data.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var path = snapshot.data[index];
                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewItems(
                                  title: path.documentID,
                                  url: path.data["imageURL"],
                                  cost: path.data["cost"],
                                  description: path.data["description"]??null,
                                  category: title,
                                )));
                      },
                      child: Card(
                        shadowColor: MyColors.STATUS_BAR.withOpacity(0.5),
                        margin: EdgeInsets.all(5.0),
                        elevation: 15,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: 8, right: 8, top: 5.0, bottom: 5.0),
                              child: Text(
                                path.documentID,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: MyColors.TEXT_COLOR,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 5.5,
                              child: Center(
                                  child: Image.network(
                                path.data["imageURL"],
                              )),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 8.0),
                              child: Text(
                                path.data["cost"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: MyColors.TEXT_COLOR,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              ),
            );
          }
        },
      ),
    );
  }
}

//
//Container(
//height: 220,
//width: 160,
//margin: EdgeInsets.all(8),
//child: Align(
//alignment: Alignment.bottomRight,
//child: Text(
//'\$50',
//style: TextStyle(
//color: MyColors.TEXT_COLOR,
//fontSize: 22,
//),
//),
//),
//),
