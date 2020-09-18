import 'package:SBT/my_colors.dart';
import 'package:SBT/screens/home/details.dart';
import 'package:SBT/screens/home/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadImages extends StatefulWidget {
  var val;
  LoadImages({this.val});

  @override
  _LoadImagesState createState() => _LoadImagesState();
}

class _LoadImagesState extends State<LoadImages> {
  Future _getImages(var val) async {
    var ref = Firestore.instance;
    QuerySnapshot qnRef = await ref.collection(val).getDocuments();
    return qnRef.documents;
  }

  listView(var val) {
    return FutureBuilder(
        future: _getImages(val),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else {
            return Container(
              padding: EdgeInsets.only(bottom: 10,right: 10),
              margin: EdgeInsets.only(top: 5),
              height: MediaQuery.of(context).size.height-150,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: snapshot.data.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    var path = snapshot.data[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                            Details(title : path.documentID.toString(),)));
                        print(path.documentID.toString());
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 160,
                            margin: EdgeInsets.only(
                              bottom: 20,
                              right: 20,
                            ),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      MyColors.APP_BCK.withOpacity(0.40),
                                      BlendMode.srcOver),
                                  image: NetworkImage(
                                    path.data['imageURL'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                color: MyColors.TEXT_FIELD_BCK,
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: MyColors.TEXT_FIELD_BCK,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: MyColors.TEXT_COLOR.withOpacity(0.5),
                                    blurRadius: 5,
                                    offset: Offset(5, 5),
                                  )
                                ]),
                          ),
                          Container(
                            width: 180,
                            margin: EdgeInsets.only(
                              bottom: 20,
                              right: 10,
                            ),
                            child: Center(
                              child: Text(
                                snapshot.data[index].documentID,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: MyColors.TEXT_COLOR,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return listView(widget.val);
  }
}
