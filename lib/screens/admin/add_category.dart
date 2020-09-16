import 'package:SBT/my_colors.dart';
import 'package:SBT/screens/admin/image_process.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCategories extends StatefulWidget {
  String imageURL;
  AddCategories({this.imageURL});

  @override
  _AddCategoriesState createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  String categoryName;

  String documentID;

  TextEditingController _documentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _upload() async{
      CollectionReference ref = Firestore.instance.collection('Categories');
      return await ref.document(documentID).setData({
        'imageURL':widget.imageURL,
      }).whenComplete(() {
        print("Completed");
        setState(() {
          _documentController.text = '';
          widget.imageURL = '';
        });
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('New Category'),
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
              controller: _documentController,
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
              color: MyColors.TEXT_FIELD_BCK,
              child: ListTile(
                leading: IconButton(
                  icon: Icon(Icons.file_upload),
                  color: MyColors.TEXT_COLOR,
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ImageProcess(
                            val: 'Categories',
                          ))),
                ),
                title: Text(widget.imageURL),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.only(top:20),
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
                  _upload();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
