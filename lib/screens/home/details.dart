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
  String url;

  Details({this.title, this.url});

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
                height: double.infinity,
                child: GridView.builder(
                  padding: EdgeInsets.all(5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
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
                              category: title,
                            )));
                      },
                      child: Card(
                        shadowColor: MyColors.STATUS_BAR.withOpacity(0.5),
                        margin: EdgeInsets.all(5.0),
                        elevation: 15,
                        child: Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  EdgeInsets.only(left: 8, right: 8, bottom: 8),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  path.documentID,
                                  style: TextStyle(
                                    color: MyColors.TEXT_COLOR,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(8),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  path.data["cost"],
                                  style: TextStyle(
                                    color: MyColors.TEXT_COLOR,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 150,
                              child: Center(
                                  child: Image.network(path.data["imageURL"])),
                            )
                          ],
                        ),
                      ),
                    );
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
