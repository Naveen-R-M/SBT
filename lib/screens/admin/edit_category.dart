import 'package:SBT/screens/home/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../my_colors.dart';

class EditCategory extends StatefulWidget {
  String collection;
  EditCategory({this.collection});

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

String documentID;
int stockAvailable;

class _EditCategoryState extends State<EditCategory> {
  _update() async {
    var ref = Firestore.instance.collection(widget.collection).document(documentID);
    return await ref.updateData({
      'stockAvailable': stockAvailable,
    }).whenComplete(() => Navigator.pop(context));
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Edit ${widget.collection}'),
        backgroundColor: MyColors.APP_BCK,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Select the ${(widget.collection).toLowerCase()} to edit',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    Firestore.instance.collection(widget.collection).snapshots(),
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
              TextFormField(
                validator: (value) =>
                value.length < 1
                    ? "Stock count is required"
                    : null,
                onChanged: (val) => stockAvailable = num.parse(val),
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
              Container(
                margin: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: FlatButton(
                  child: Text(
                    'UPDATE',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  color: MyColors.TEXT_COLOR,
                  onPressed: (){
                    if (_key.currentState.validate()){
                      _update();
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
