import 'package:SBT/screens/home/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../my_colors.dart';
import 'item_view.dart';

class Suggestion extends StatelessWidget {
  String category;

  Suggestion(this.category);

  Future _getImages() async {
    var ref = Firestore.instance;
    QuerySnapshot qnRef = await ref.collection(category).getDocuments();
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
            margin: EdgeInsets.all(15),
            width: double.infinity,
            height: 230,
            child: ListView.builder(
              itemCount: snapshot.data.length,
              scrollDirection: Axis.horizontal,
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
                            category: category,
                          )));
                    },
                    child: Card(
                      shadowColor: MyColors.APP_BCK.withOpacity(0.5),
                      color: MyColors.APP_BCK,
                      margin: EdgeInsets.all(5.0),
                      elevation: 20,
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
                            color: Colors.white,
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
    );
  }
}
