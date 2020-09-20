import 'package:SBT/screens/home/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../my_colors.dart';

class DeleteGallery extends StatefulWidget {
  String collection;
  String document;
  String subCollection;


  DeleteGallery({this.collection, this.document, this.subCollection});

  @override
  _DeleteGalleryState createState() => _DeleteGalleryState();
}

class _DeleteGalleryState extends State<DeleteGallery> {
  String documentID;

  var imageURL;

  _delete(context, imageURL) async {
    var ref = await FirebaseStorage.instance
        .getReferenceFromUrl(imageURL)
        .whenComplete(() => print(imageURL));
    await ref.delete();
    return await Firestore.instance
        .collection(widget.collection)
        .document(widget.document)
        .collection(widget.subCollection)
        .document(documentID)
        .delete()
        .whenComplete(() {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete ${widget.document}'),
        backgroundColor: MyColors.APP_BCK,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Select the ${(widget.document).toLowerCase()} images to delete',
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection(widget.collection)
                  .document(widget.document)
                  .collection(widget.subCollection)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                } else {
                  List<DropdownMenuItem> items = [];
                  for (int i = 0; i < snapshot.data.documents.length; i++) {
                    DocumentSnapshot snap = snapshot.data.documents[i];
                    items.add(
                      DropdownMenuItem(
                        child: Center(
                          child: Text(
                            snap.documentID,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                        value: '${snap.documentID}',
                      ),
                    );
                  }
                  return DropdownButton(
                    focusColor: MyColors.TEXT_FIELD_BCK,
                    iconEnabledColor: MyColors.TEXT_COLOR,
                    items: items,
                    onChanged: (val) {
                      print(val);
                      final snackbar = SnackBar(
                        content: Text('$val is selected'),
                      );
                      Scaffold.of(context).showSnackBar(snackbar);
                      setState(() {
                        documentID = val;
                      });
                    },
                    value: documentID,
                  );
                }
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              height: 45,
              child: FlatButton(
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                color: MyColors.TEXT_COLOR,
                onPressed: () async {
                  var ref = await Firestore.instance
                      .collection(widget.collection)
                      .document(widget.document)
                      .collection(widget.subCollection)
                      .document(documentID)
                      .get();
                  imageURL = ref['imageURL'];
                  print(imageURL);
                  _delete(context, imageURL);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
