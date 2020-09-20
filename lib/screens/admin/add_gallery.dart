import 'package:SBT/screens/admin/additional_image_process.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../my_colors.dart';

class AddGallery extends StatefulWidget {
  String collection;
  String document;
  String imageURL;

  AddGallery({this.collection, this.document, this.imageURL});

  @override
  _AddGalleryState createState() => _AddGalleryState();
}

class _AddGalleryState extends State<AddGallery> {
  String subCollection;
  String subDocumentID;
  String imageURL;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _documentController = TextEditingController();

  _upload() async {
    CollectionReference ref = Firestore.instance
        .collection(widget.collection)
        .document(widget.document)
        .collection('Additional Images');
    return await ref.document(subDocumentID).setData({
      'imageURL': widget.imageURL,
    }).whenComplete(() {
      print("Completed");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add additional Images'),
        backgroundColor: MyColors.APP_BCK,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) =>
                    value.length < 1 ? "DocumentID cannot be empty" : null,
                controller: _documentController,
                onChanged: (val) => subDocumentID = val,
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
                color: MyColors.TEXT_FIELD_BCK,
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.file_upload),
                    color: MyColors.TEXT_COLOR,
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdditionalImageProcess(
                              val: widget.collection,
                          document: widget.document,
                            ))),
                  ),
                  title: Text(widget.imageURL),
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
                    'Upload',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  color: MyColors.TEXT_COLOR,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _upload();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
