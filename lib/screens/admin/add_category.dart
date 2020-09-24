import 'package:SBT/my_colors.dart';
import 'package:SBT/screens/admin/image_process.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCategories extends StatefulWidget {
  String imageURL;
  String val;
  AddCategories({this.imageURL,this.val});

  @override
  _AddCategoriesState createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  String categoryName;

  String documentID;
  String description;
  String cost;
  String priorityValue;
  int stockCount;

  final _formkey = GlobalKey<FormState>();
  TextEditingController _documentController = TextEditingController();

  var priority = ['High', 'Low'];

  @override
  Widget build(BuildContext context) {
    _upload() async {
      CollectionReference ref = Firestore.instance.collection(widget.val);
      if (widget.val == "Categories") {
        return await ref.document(documentID).setData({
          'imageURL': widget.imageURL,
        }).whenComplete(() {
          print("Completed");
        });
      }
      else {
        return await ref.document(documentID).setData({
          'stockAvailable': stockCount,
          'cost': cost,
          'description': description,
          'imageURL': widget.imageURL,
          'priority': priorityValue,
        }).whenComplete(() {
          print("Completed");
        });
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('New ${widget.val}'),
        backgroundColor: MyColors.APP_BCK,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.all(10),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if((widget.val == "Categories") | (widget.val ==
                    "Carousel")) ...[
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) =>
                    value.length < 1
                        ? "DocumentID cannot be empty"
                        : null,
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
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ImageProcess(
                                      val: widget.val,
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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
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
                        if (_formkey.currentState.validate()) {
                          _upload();
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  )
                ],
                if((widget.val != "Categories") &&
                    (widget.val != "Carousel")) ...[
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) =>
                    value.length < 1
                        ? "DocumentID cannot be empty"
                        : null,
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
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) =>
                    value.length < 1
                        ? "Cost cannot be empty"
                        : null,
                    onChanged: (val) => cost = val,
                    style: TextStyle(
                        color: MyColors.TEXT_COLOR,
                        letterSpacing: 3.0,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    cursorColor: MyColors.TEXT_COLOR,
                    decoration: InputDecoration(
                      hintText: 'Enter the cost',
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
                  TextFormField(
                    validator: (value) =>
                    value.length < 1
                        ? "Description cannot be empty"
                        : null,
                    onChanged: (val) => description = val,
                    style: TextStyle(
                        color: MyColors.TEXT_COLOR,
                        letterSpacing: 3.0,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    cursorColor: MyColors.TEXT_COLOR,
                    decoration: InputDecoration(
                      hintText: 'Enter the description',
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
                  TextFormField(
                    validator: (value) =>
                    value.length < 1
                        ? "Stock count is required"
                        : null,
                    onChanged: (val) => stockCount = num.parse(val),
                    style: TextStyle(
                        color: MyColors.TEXT_COLOR,
                        letterSpacing: 3.0,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    cursorColor: MyColors.TEXT_COLOR,
                    decoration: InputDecoration(
                      hintText: 'Stock Available',
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
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ImageProcess(
                                      val: widget.val,
                                    ))),
                      ),
                      title: Text(widget.imageURL),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        'Priority',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: DropdownButton<String>(
                      items: priority.map((value) {
                        return DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (value) {
                        print("Priority:::");
                        setState(() {
                          priorityValue = value;
                        });
                      },
                      value: priorityValue,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
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
                        if (_formkey.currentState.validate()) {
                          _upload();
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}