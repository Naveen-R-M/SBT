import 'package:SBT/screens/home/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../my_colors.dart';
import 'item_view.dart';

class Suggestion extends StatefulWidget {
  String category;

  Suggestion(this.category);

  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  String message;
  String sold;
  Future _getImages() async {
    var ref = Firestore.instance;
    QuerySnapshot qnRef = await ref.collection(widget.category).getDocuments();
    return qnRef.documents;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        } else {
          return Container(
            margin: EdgeInsets.only(left: 8,bottom: 8,top: 5.0),
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.height / 5)+80,
            child: ListView.builder(
              padding: EdgeInsets.all(5),
              itemCount: snapshot.data.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var path = snapshot.data[index];
                return GestureDetector(
                    onTap: path.data['stockAvailable']>0?() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewItems(
                                title: path.documentID,
                                url: path.data["imageURL"],
                                cost: path.data["cost"],
                                description: path.data["description"] ?? null,
                                category: widget.category,
                              )));
                    }:null,
                    child:path.data['stockAvailable']>0?path.data['priority']=='High'
                        ? Banner(
                          message: message,
                          location: BannerLocation.topEnd,
                          child:  Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Card(
                              elevation: 3.5,
                              shadowColor: MyColors.TEXT_COLOR.withOpacity(0.4),
                              child: Column(
                                children: [
                                  Card(
                                    shadowColor: MyColors.STATUS_BAR.withOpacity(0.5),
                                    elevation: 7,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 2.25,
                                      height: MediaQuery.of(context).size.height / 5,
                                      child: Image.network(
                                        path.data["imageURL"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 2.25,
                                      margin: EdgeInsets.only(
                                          left: 8.0, right: 8.0, top: 8.0),
                                      child: Text(
                                        path.documentID,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: MyColors.TEXT_COLOR,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                    EdgeInsets.only(left: 8.0, right: 8.0,bottom: 5.0),
                                    child: Text(
                                      '₹${path.data["cost"]}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: MyColors.TEXT_COLOR,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        : Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Card(
                        elevation: 3.5,
                        shadowColor: MyColors.TEXT_COLOR.withOpacity(0.4),
                        child: Column(
                          children: [
                            Card(
                              shadowColor: MyColors.STATUS_BAR.withOpacity(0.5),
                              elevation: 7,
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2.25,
                                height: MediaQuery.of(context).size.height / 5,
                                child: Image.network(
                                  path.data["imageURL"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2.25,
                                margin: EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 8.0),
                                child: Text(
                                  path.documentID,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: MyColors.TEXT_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin:
                              EdgeInsets.only(left: 8.0, right: 8.0,bottom: 5.0),
                              child: Text(
                                '₹${path.data["cost"]}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: MyColors.TEXT_COLOR,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        :Banner(
                      message: sold,
                      location: BannerLocation.topEnd,
                      child:  Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Card(
                          elevation: 3.5,
                          shadowColor: MyColors.TEXT_COLOR.withOpacity(0.4),
                          child: Column(
                            children: [
                              Card(
                                shadowColor: MyColors.STATUS_BAR.withOpacity(0.5),
                                elevation: 7,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2.25,
                                  height: MediaQuery.of(context).size.height / 5,
                                  child: Image.network(
                                    path.data["imageURL"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2.25,
                                  margin: EdgeInsets.only(
                                      left: 8.0, right: 8.0, top: 8.0),
                                  child: Text(
                                    path.documentID,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: MyColors.TEXT_COLOR,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                EdgeInsets.only(left: 8.0, right: 8.0,bottom: 5.0),
                                child: Text(
                                  '₹${path.data["cost"]}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: MyColors.TEXT_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                );
              },
            ),
          );
        }
      },
    );
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

//
// return Container(
// margin: EdgeInsets.all(15),
// width: double.infinity,
// height: 230,
// child: ListView.builder(
// itemCount: snapshot.data.length,
// scrollDirection: Axis.horizontal,
// itemBuilder: (context, index) {
// var path = snapshot.data[index];
// return Container(
// width: MediaQuery.of(context).size.width/3,
// child: GestureDetector(
// onTap: () {
// Navigator.of(context).push(MaterialPageRoute(
// builder: (context) => ViewItems(
// title: path.documentID,
// url: path.data["imageURL"],
// cost: path.data["cost"],
// description: path.data["description"]??null,
// category: category,
// )));
// },
// child: Column(
// children: [
// Card(
// shadowColor: MyColors.APP_BCK.withOpacity(0.5),
// color: MyColors.APP_BCK,
// margin: EdgeInsets.all(5.0),
// elevation: 20,
// child: Container(
// height: MediaQuery.of(context).size.height / 5.5,
// color: Colors.white,
// child: Center(
// child: Image.network(
// path.data["imageURL"],
// )),
// ),
// ),
// Expanded(
// child: Container(
// margin: EdgeInsets.only(
// left: 8, right: 8, top: 5.0, bottom: 5.0),
// child: Text(
// path.documentID,
// textAlign: TextAlign.center,
// style: TextStyle(
// color: MyColors.TEXT_COLOR,
// fontWeight: FontWeight.bold,
// fontSize: 18,
// ),
// ),
// ),
// ),
// Container(
// margin: EdgeInsets.only(
// left: 8.0, right: 8.0, top: 8.0),
// child: Text(
// path.data["cost"],
// textAlign: TextAlign.center,
// style: TextStyle(
// color: MyColors.TEXT_COLOR,
// fontWeight: FontWeight.bold,
// fontSize: 18,
// ),
// ),
// ),
// ],
// )),
// );
// },
// ),
// );
