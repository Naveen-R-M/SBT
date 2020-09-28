import 'package:SBT/model/user.dart';
import 'package:SBT/screens/home/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  _delete(context, imageURL, user) async {
    var userRef = await Firestore.instance.collection('Users').getDocuments();
    for (var i = 0; i < userRef.documents.length; i++) {
      var liked = await Firestore.instance
          .collection('Users')
          .document(userRef.documents[i].documentID)
          .collection('Liked')
          .getDocuments();
      var cart = await Firestore.instance
          .collection('Users')
          .document(userRef.documents[i].documentID)
          .collection('Cart')
          .getDocuments();
      for(var j=0;j<cart.documents.length;j++){
        if (cart.documents[j].data['title'] == documentID) {
          await Firestore.instance
              .collection('Users')
              .document(userRef.documents[i].documentID)
              .collection('Cart')
              .document(cart.documents[j].documentID)
              .delete();
        }
        if (liked.documents[j].data['title'] == documentID) {
          await Firestore.instance
              .collection('Users')
              .document(userRef.documents[i].documentID)
              .collection('Liked')
              .document(liked.documents[j].documentID)
              .delete();
        }
      }
    }
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
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete ${widget.val}'),
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
              'Select the ${(widget.val).toLowerCase()} to delete',
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection(widget.val).snapshots(),
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
                      .collection(widget.val)
                      .document(documentID)
                      .get();
                  imageURL = ref['imageURL'];
                  print(imageURL);
                  _delete(context, imageURL, user);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
