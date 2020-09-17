import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../my_colors.dart';

class DeleteCategories extends StatefulWidget {
  String val;
  DeleteCategories({this.val});

  @override
  _DeleteCategoriesState createState() => _DeleteCategoriesState();
}

class _DeleteCategoriesState extends State<DeleteCategories> {
  String documentID;
  var imageURL;

  _delete(context, imageURL) async {
    var ref = await FirebaseStorage.instance
        .getReferenceFromUrl(imageURL)
        .whenComplete(() => print(imageURL));
    await ref.delete();
    return await Firestore.instance
        .collection(widget.val)
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
        title: Text('Delete ${widget.val}'),
        backgroundColor: MyColors.STATUS_BAR,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            TextFormField(
              onChanged: (val) => documentID = val,
              style: TextStyle(
                  color: MyColors.TEXT_COLOR,
                  letterSpacing: 3.0,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              cursorColor: MyColors.TEXT_COLOR,
              decoration: InputDecoration(
                hintText: 'Enter documentID',
                hintStyle: TextStyle(fontStyle: FontStyle.normal),
                filled: true,
                fillColor: MyColors.TEXT_FIELD_BCK,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: MyColors.TEXT_FIELD_BCK),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: MyColors.TEXT_FIELD_BCK),
                ),
              ),
            ),
            SizedBox(
              height: 15,
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
                  var ref = await Firestore.instance.collection(widget.val).document(documentID).get();
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
