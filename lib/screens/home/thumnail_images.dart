import 'package:SBT/my_colors.dart';
import 'package:SBT/screens/home/details.dart';
import 'package:SBT/screens/home/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LoadImages extends StatefulWidget {
  var val;
  LoadImages({this.val});

  @override
  _LoadImagesState createState() => _LoadImagesState();
}

class _LoadImagesState extends State<LoadImages> {
  Stream _getImages(var val) {
    var ref = Firestore.instance;
    return ref.collection(val).snapshots();
  }

  listView(var val) {
    return StreamBuilder(
        stream: _getImages(val),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else {
            var data = snapshot.data.documents;
            return Container(
              padding: EdgeInsets.only(bottom: 30,right: 10,),
              height: MediaQuery.of(context).size.height-150,
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                  itemCount: data.length,
                  scrollDirection: Axis.vertical,
                  staggeredTileBuilder: (index)=>StaggeredTile.count(
                      (index%2==0)?1 : 1,(index%2==0)?1.85:1,
                  ),
                  itemBuilder: (context, index) {
                    var path = data[index];
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
                                borderRadius: BorderRadius.all(Radius.circular(30)),
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
                                path.documentID,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: MyColors.TEXT_COLOR,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
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
