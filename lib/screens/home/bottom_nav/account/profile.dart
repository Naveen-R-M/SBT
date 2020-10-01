import 'package:SBT/model/user.dart';
import 'package:SBT/my_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String street;
  String area;
  String city;
  String state;
  String postalCode;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void showAlertDialog(BuildContext context,user){
    var ref = Firestore.instance.collection('Users').document(user.uid);
    showDialog(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return Dialog(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(25),
              width: MediaQuery.of(context).size.width/1.2,
              height: MediaQuery.of(context).size.height/1.5,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Text(
                        'Add Address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',
                          fontSize: 18
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value)=>value.length<1?"Street name cannot be empty":null,
                        onChanged: (val)=>street=val,
                        style: TextStyle(
                          letterSpacing: 3.0,
                          fontSize: 14,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        cursorColor: MyColors.TEXT_COLOR,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter your street name',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                        ),
                      ),
                      TextFormField(
                        validator: (value)=>value.length<1?"Area name cannot be empty":null,
                        onChanged: (val)=>area=val,
                        style: TextStyle(
                          letterSpacing: 3.0,
                          fontSize: 14,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        cursorColor: MyColors.TEXT_COLOR,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter your area name',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                        ),
                      ),
                      TextFormField(
                        validator: (value)=>value.length<1?"City name cannot be empty":null,
                        onChanged: (val)=>city=val,
                        style: TextStyle(
                          letterSpacing: 3.0,
                          fontSize: 14,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        cursorColor: MyColors.TEXT_COLOR,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter your city name',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                        ),
                      ),
                      TextFormField(
                        validator: (value)=>value.length<1?"State name cannot be empty":null,
                        onChanged: (val)=>state=val,
                        style: TextStyle(
                          letterSpacing: 3.0,
                          fontSize: 14,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        cursorColor: MyColors.TEXT_COLOR,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter your state name',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                        ),
                      ),
                      TextFormField(
                        validator: (value)=>value.length<1?"Postal Code cannot be empty":null,
                        onChanged: (val)=>postalCode=val,
                        style: TextStyle(
                          letterSpacing: 3.0,
                          fontSize: 14,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        cursorColor: MyColors.TEXT_COLOR,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter your Postal Code',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlineButton(
                            highlightedBorderColor: MyColors.TEXT_COLOR,
                            highlightColor: MyColors.TEXT_FIELD_BCK,
                            splashColor: MyColors.TEXT_COLOR,
                            borderSide: BorderSide(
                              color: MyColors.TEXT_FIELD_BCK,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                              onPressed: (){
                              if(_formKey.currentState.validate()){
                                ref.updateData({
                                  'address':'$street\n$area\n$city\n$state\n$postalCode',
                                }).whenComplete(() => Navigator.of(dialogContext).pop());
                              }
                              },
                            child: Text(
                              'ADD',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          OutlineButton(
                            highlightedBorderColor: MyColors.TEXT_COLOR,
                            highlightColor: MyColors.TEXT_FIELD_BCK,
                            splashColor: MyColors.TEXT_COLOR,
                            borderSide: BorderSide(
                              color: MyColors.TEXT_FIELD_BCK,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                              onPressed: (){
                                Navigator.of(dialogContext).pop();
                              },
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    profile(){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3.5,
                    decoration: BoxDecoration(
                        color: MyColors.STATUS_BAR.withOpacity(0.6),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Center(
                      child: Text(
                        'Account',
                        style: TextStyle(
                            fontFamily: 'Pacifico', fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream: Firestore.instance.collection('Users').document(user.uid).snapshots(),
                    builder: (context, snapshot) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 6.5,
                            left: 30,
                            right: 30,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: MyColors.TEXT_COLOR.withOpacity(0.5),
                                      spreadRadius: 3,
                                    blurRadius: 10
                                  )
                                ],
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                          top: 5,
                                          bottom: 15,
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: Center(
                                          child: CircleAvatar(
                                            radius: 40,
                                            child: Icon(
                                              Icons.person,
                                              size: 65,
                                              color: Colors.white,
                                            ),
                                            backgroundColor: MyColors.TEXT_FIELD_BCK,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Center(
                                          child: Text(
                                            snapshot.data['phone'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Lato',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 25,
                                            bottom: 10,
                                            left: 20,
                                            right: 20
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Address',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                showAlertDialog(context, user);
                                              },
                                                child: Icon(Icons.edit,size: 20,)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            bottom: 20,
                                            left: 20,
                                            right: 20
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              snapshot.data['address']??'No Address found',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.5
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            snapshot.data['address']==null
                                                ?OutlineButton(
                                                  onPressed: (){
                                                    showAlertDialog(context,user);
                                                  },
                                                  child: Text(
                                                    'ADD ADDRESS',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12
                                                    ),
                                                  ),
                                                  highlightedBorderColor: MyColors.TEXT_COLOR,
                                                  highlightColor: MyColors.TEXT_FIELD_BCK,
                                                  splashColor: MyColors.TEXT_COLOR,
                                                  borderSide: BorderSide(
                                                    color: MyColors.TEXT_FIELD_BCK,
                                                    style: BorderStyle.solid,
                                                    width: 2,
                                                  ),
                                                ):Container()
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                      );
                    }
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      );
    }

    return profile();
  }
}
