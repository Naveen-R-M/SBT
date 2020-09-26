import 'package:SBT/screens/admin/add_gallery.dart';
import 'package:SBT/screens/admin/admin.dart';
import 'package:SBT/screens/admin/delete_gallery.dart';
import 'package:SBT/screens/home/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../my_colors.dart';

class AdditionalImages extends StatelessWidget {
  String title;
  String documentID;
  AdditionalImages({this.title, this.documentID});

  Stream _getImages(collections, documents, subCollections) {
    var ref = Firestore.instance;
    return ref
        .collection(collections)
        .document(documents)
        .collection(subCollections)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
            child: Text(
          '$title gallery',
          style: TextStyle(
            color: MyColors.TEXT_COLOR,
            fontFamily: 'Pacifico',
            fontSize: 20
          ),
        )),
      ),
      floatingActionButton: Admin.admin == true
          ? SpeedDial(
              animatedIcon: AnimatedIcons.menu_arrow,
              children: [
                SpeedDialChild(
                    child: IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DeleteGallery(
                        collection: title,
                        document: documentID,
                        subCollection: 'Additional Images',
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
                          builder: (context) => AddGallery(
                            collection: title,
                            document: documentID,
                            imageURL: '',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : null,
      body: RefreshIndicator(
        onRefresh: (){
          Navigator.pushReplacement(context,
            PageRouteBuilder(pageBuilder: (a,b,c)=>AdditionalImages(
              title: title,
              documentID: documentID,
            ),
                transitionDuration: Duration(seconds: 0)
            ),
          );
          return Future.value(false);
        },
        child: Container(
          margin: EdgeInsets.all(5.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
            stream: _getImages(title, documentID, 'Additional Images'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              } else {
                var data = snapshot.data.documents;
                return GestureDetector(
                  child: Container(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        var path = data[index];
                        return Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    path.data['imageURL'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Admin.admin==true?Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(data[index].documentID,
                                style: TextStyle(
                                  fontFamily: 'Pacifico',
                                  fontSize: 28,
                                ),),
                              ),
                            ):Container(),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
