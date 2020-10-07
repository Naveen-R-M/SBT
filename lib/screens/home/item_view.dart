import 'dart:io';
import 'dart:typed_data';

import 'package:SBT/model/user.dart';
import 'package:SBT/screens/home/additional_images.dart';
import 'package:SBT/screens/home/suggestion.dart';
import 'package:SBT/screens/home/suggestion_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:intl/intl.dart';

import '../../my_colors.dart';

class ViewItems extends StatefulWidget {
  String category;
  String name;
  String title;
  String url;
  String description;
  String cost;

  ViewItems(
      {this.title,
      this.url,
      this.description,
      this.category,
      this.cost,
      this.name});

  @override
  _ViewItemsState createState() => _ViewItemsState();
}

class _ViewItemsState extends State<ViewItems> {
  var user;
  bool liked = false;
  bool cartAdded;
  Razorpay _razorpay;

  BuildContext dlogcontext;

  String street;
  String area;
  String city;
  String state;
  String postalCode;
  bool exceeded = false;
  int itemCount = 1;
  int totalCost;
  String address;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void getAddressAlertDialog(BuildContext context, user) {
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
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 1.5,
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
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) => value.length < 1
                            ? "Street name cannot be empty"
                            : null,
                        onChanged: (val) => street = val,
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
                            borderSide:
                                BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                        ),
                      ),
                      TextFormField(
                        validator: (value) => value.length < 1
                            ? "Area name cannot be empty"
                            : null,
                        onChanged: (val) => area = val,
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
                            borderSide:
                                BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                        ),
                      ),
                      TextFormField(
                        validator: (value) => value.length < 1
                            ? "City name cannot be empty"
                            : null,
                        onChanged: (val) => city = val,
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
                            borderSide:
                                BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                        ),
                      ),
                      TextFormField(
                        validator: (value) => value.length < 1
                            ? "State name cannot be empty"
                            : null,
                        onChanged: (val) => state = val,
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
                            borderSide:
                                BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                        ),
                      ),
                      TextFormField(
                        validator: (value) => value.length < 1
                            ? "Postal Code cannot be empty"
                            : null,
                        onChanged: (val) => postalCode = val,
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
                            borderSide:
                                BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: MyColors.TEXT_FIELD_BCK),
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
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                ref.updateData({
                                  'address':
                                      '$street\n$area\n$city\n$state\n$postalCode',
                                }).whenComplete(
                                    () => Navigator.of(dialogContext).pop());
                              }
                            },
                            child: Text(
                              'ADD',
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
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
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
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

  showAddressAlertDialog(
      BuildContext context, user, itemCount, productID, name, cost, imageURL) {
    totalCost = itemCount * num.parse(cost);
    return showDialog(
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
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 1.4,
              child: SingleChildScrollView(
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('Users')
                        .document(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      address = snapshot.data['address'];
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 5,
                                      bottom: 10,
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: Center(
                                      child: CircleAvatar(
                                        radius: 37,
                                        child: Icon(
                                          Icons.person,
                                          size: 65,
                                          color: Colors.white,
                                        ),
                                        backgroundColor:
                                            MyColors.TEXT_FIELD_BCK,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Center(
                                      child: Text(
                                        snapshot.data['name'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.bold,
                                        ),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 25,
                                        bottom: 10,
                                        left: 20,
                                        right: 20),
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
                                            onTap: () {
                                              getAddressAlertDialog(
                                                  context, user);
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              size: 20,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: 20, left: 20, right: 20),
                                    child: Column(
                                      children: [
                                        Text(
                                          snapshot.data['address'] ??
                                              'No Address found',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Lato',
                                              fontWeight: FontWeight.bold,
                                              height: 1.5),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        snapshot.data['address'] == null
                                            ? OutlineButton(
                                                onPressed: () {
                                                  getAddressAlertDialog(
                                                      context, user);
                                                },
                                                child: Text(
                                                  'ADD ADDRESS',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                                highlightedBorderColor:
                                                    MyColors.TEXT_COLOR,
                                                highlightColor:
                                                    MyColors.TEXT_FIELD_BCK,
                                                splashColor:
                                                    MyColors.TEXT_COLOR,
                                                borderSide: BorderSide(
                                                  color:
                                                      MyColors.TEXT_FIELD_BCK,
                                                  style: BorderStyle.solid,
                                                  width: 2,
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Product Details',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        width: 100,
                                        height: 100,
                                        child: Image.network(
                                          imageURL,
                                          fit: BoxFit.cover,
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Product name : $name'
                                      '\nProductID : $productID'
                                      '\nQuantity selected : $itemCount'
                                      '\nTotal cost : ₹$totalCost',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 1.2,
                                          height: 1.3,
                                          wordSpacing: 1.2),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: OutlineButton(
                                  highlightedBorderColor: MyColors.TEXT_COLOR,
                                  highlightColor: MyColors.TEXT_FIELD_BCK,
                                  splashColor: MyColors.TEXT_COLOR,
                                  borderSide: BorderSide(
                                    color: MyColors.TEXT_FIELD_BCK,
                                    style: BorderStyle.solid,
                                    width: 2,
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      dlogcontext = dialogContext;
                                    });
                                    print(
                                        "CAT:::${widget.category}DOC::${widget.title}");
                                    var itemRef = await Firestore.instance
                                        .collection(widget.category)
                                        .document(widget.title)
                                        .get();
                                    if (itemCount <=
                                        itemRef['stockAvailable']) {
                                      openCheckout(totalCost);
                                    } else {
                                      print('try less values');
                                    }
                                  },
                                  child: Text(
                                    'PROCEED TO PAYMENT',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.info,
                                    size: 13,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Check the details before proceeding to payment',
                                      style: TextStyle(
                                          fontSize: 12, fontFamily: 'Lato'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ),
        );
      },
    );
  }

  _addToLiked() async {
    var ref = Firestore.instance
        .collection('Users')
        .document(user.uid)
        .collection('Liked')
        .document();
    return await ref.setData({
      'category': widget.category,
      'name': widget.name,
      'title': widget.title,
    }).whenComplete(() => Fluttertoast.showToast(msg: 'Item added to liked'));
  }

  _addToCart() async {
    var ref = Firestore.instance
        .collection("Users")
        .document(user.uid)
        .collection('Cart')
        .document();
    return await ref.setData({
      'category': widget.category,
      'title': widget.title,
      'name': widget.name,
    }).whenComplete(() {
      Fluttertoast.showToast(msg: 'Item added to cart successfully');
      setState(() {
        cartAdded = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  _update(itemCount) async {
    var ref = await Firestore.instance
        .collection(widget.category)
        .document(widget.title)
        .get();
    if (ref.data['stockAvailable'] > 0) {
      return await Firestore.instance
          .collection(widget.category)
          .document(widget.title)
          .updateData({
        'stockAvailable': ref["stockAvailable"] - itemCount,
      });
    }
  }

  void openCheckout(totalCost) async {
    var options = {
      'key': 'rzp_test_iXSAz7jqJc5n0D',
      'amount': totalCost * 100,
      'name': 'SBT Shopping',
      'description': 'ProductID : ${widget.title}',
      'prefill': {'Contact': '', 'Mail id': ''},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(
        msg: 'Your paymentID ${response.paymentId} is successful');
    _update(itemCount);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    var userRef =
        await Firestore.instance.collection('Users').document(user.uid).get();
    await Firestore.instance.collection('Orders').document().setData({
      'dateTime': formattedDate,
      'result': 'Success',
      'category': widget.category,
      'name': widget.name,
      'productID': widget.title,
      'quantity': itemCount,
      'amount': totalCost,
      'imageURL': widget.url,
      'address': address,
      'username' : userRef.data['name'],
      'user phNo' : userRef.data['phone'],
      'status': 'UnDelivered',
      'user id': user.uid,
    });
    await Firestore.instance
        .collection('Users')
        .document(user.uid)
        .collection('Successful Transactions')
        .document()
        .setData({
      'dateTime': formattedDate,
      'result': 'Success',
      'category': widget.category,
      'name': widget.name,
      'productID': widget.title,
      'quantity': itemCount,
      'amount': totalCost,
      'imageURL': widget.url,
    });
    Navigator.of(dlogcontext).pop();
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    Fluttertoast.showToast(
        msg: 'Your payment is failed with ${{
      response.code
    }.toString()}\nERROR Message:${response.message}');
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    var userRef =
    await Firestore.instance.collection('Users').document(user.uid).get();
    await Firestore.instance
        .collection('Failed Transactions')
        .document(user.uid)
        .collection(widget.title)
        .document()
        .setData({
      'dateTime': formattedDate,
      'result': 'Failed',
      'category': widget.category,
      'name': widget.name,
      'productID': widget.title,
      'quantity': itemCount,
      'amount': totalCost,
      'imageURL': widget.url,
      'address': address,
      'username' : userRef.data['name'],
      'user phNo' : userRef.data['phone'],
      'user id': user.uid,
    });
    await Firestore.instance
        .collection('Users')
        .document(user.uid)
        .collection('Failed Transactions')
        .document()
        .setData({
      'dateTime': formattedDate,
      'result': 'Failed',
      'name': widget.name,
      'category': widget.category,
      'productID': widget.title,
      'quantity': itemCount,
      'amount': totalCost,
      'imageURL': widget.url,
    });
    Navigator.of(dlogcontext).pop();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: 'External Wallet selected : ${response.walletName}');
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: MyColors.APP_BCK,
        accentColor: MyColors.TEXT_FIELD_BCK,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            widget.category,
            style: TextStyle(
                color: MyColors.TEXT_COLOR,
                fontFamily: 'Pacifico',
                fontSize: 20),
          )),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  pageBuilder: (a, b, c) => ViewItems(
                        category: widget.category,
                        title: widget.title,
                        description: widget.description,
                        url: widget.url,
                        name: widget.name,
                        cost: '${widget.cost}',
                      ),
                  transitionDuration: Duration(seconds: 1)),
            );
            return Future.value(false);
          },
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 1.75,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.url), fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.name,
                      style: TextStyle(
                          fontSize: 30,
                          color: MyColors.TEXT_COLOR,
                          fontFamily: 'Pacifico'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '₹${widget.cost}',
                      style: TextStyle(
                          fontSize: 20,
                          color: MyColors.TEXT_COLOR,
                          fontFamily: 'Pacifico',
                          letterSpacing: 2),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          StreamBuilder(
                              stream: Firestore.instance
                                  .collection('Users')
                                  .document(user.uid)
                                  .collection('Liked')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                for (var i = 0;
                                    i < snapshot.data.documents.length;
                                    i++) {
                                  if (snapshot.data.documents[i]["title"] ==
                                      widget.title) {
                                    liked = true;
                                  }
                                }
                                return CircleAvatar(
                                  backgroundColor: MyColors.TEXT_FIELD_BCK,
                                  radius: 35,
                                  child: IconButton(
                                    icon: Icon(Icons.thumb_up),
                                    color: liked == true
                                        ? MyColors.TEXT_COLOR
                                        : Colors.grey,
                                    iconSize: 40,
                                    onPressed: liked != true
                                        ? () {
                                            _addToLiked();
                                            setState(() {
                                              liked = true;
                                            });
                                          }
                                        : () {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Item already added to liked..');
                                          },
                                  ),
                                );
                              }),
                          Container(
                            margin: EdgeInsets.all(10),
                            width: 100,
                            child: Center(
                              child: Text(
                                liked == true
                                    ? 'You liked this product'
                                    : 'Like this product?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Lato',
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        child: Container(
                          height: 105,
                          width: 2,
                          color: MyColors.TEXT_FIELD_BCK.withOpacity(0.35),
                        ),
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: MyColors.TEXT_FIELD_BCK,
                            radius: 35,
                            child: IconButton(
                              icon: Icon(Icons.share),
                              color: MyColors.TEXT_COLOR,
                              iconSize: 40,
                              onPressed: () async {
                                try {
                                  var appURL = await Firestore.instance
                                      .collection('APP')
                                      .document('URL')
                                      .get();
                                  var request = await HttpClient()
                                      .getUrl(Uri.parse(widget.url));
                                  var response = await request.close();
                                  Uint8List bytes =
                                      await consolidateHttpClientResponseBytes(
                                          response);
                                  await Share.file('SBT Shopping',
                                      '${widget.title}.jpg', bytes, 'image/jpg',
                                      text:
                                          'Hey have a look at our product ${widget.name}.'
                                          '\nDownload SBT Shopping app for free from playstore.'
                                          '\n${appURL['url']}');
                                } catch (e) {
                                  print("ERROR Sharing FILE: $e");
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            width: 100,
                            child: Center(
                              child: Text(
                                'Share this product via..',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Lato',
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        child: Container(
                          height: 105,
                          width: 2,
                          color: MyColors.TEXT_FIELD_BCK.withOpacity(0.35),
                        ),
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: MyColors.TEXT_FIELD_BCK,
                            radius: 35,
                            child: IconButton(
                              icon: Icon(Icons.photo_library),
                              color: MyColors.TEXT_COLOR,
                              iconSize: 40,
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AdditionalImages(
                                          title: widget.category,
                                          documentID: widget.title,
                                        )));
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            width: 100,
                            child: Center(
                              child: Text(
                                'Additional Images',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Lato',
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text(
                        'Quantity',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Lato',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: StreamBuilder(
                        stream: Firestore.instance
                            .collection(widget.category)
                            .document(widget.title)
                            .snapshots(),
                        builder: (context, snapshot) {
                          return Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: 20,
                                  right: 10,
                                ),
                                width: 40,
                                height: 30,
                                child: OutlineButton(
                                  highlightedBorderColor: MyColors.TEXT_COLOR,
                                  highlightColor: MyColors.TEXT_FIELD_BCK,
                                  splashColor: MyColors.TEXT_COLOR,
                                  borderSide: BorderSide(
                                    color: MyColors.TEXT_FIELD_BCK,
                                    style: BorderStyle.solid,
                                    width: 2,
                                  ),
                                  onPressed: itemCount != 1
                                      ? () {
                                          setState(() {
                                            itemCount--;
                                          });
                                        }
                                      : null,
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              snapshot.data['stockAvailable'] != 0
                                  ? Text(
                                      '$itemCount',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  : Text(
                                      '0',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 10,
                                  right: 20,
                                ),
                                width: 40,
                                height: 30,
                                child: OutlineButton(
                                  highlightedBorderColor: MyColors.TEXT_COLOR,
                                  highlightColor: MyColors.TEXT_FIELD_BCK,
                                  splashColor: MyColors.TEXT_COLOR,
                                  borderSide: BorderSide(
                                    color: MyColors.TEXT_FIELD_BCK,
                                    style: BorderStyle.solid,
                                    width: 2,
                                  ),
                                  onPressed: itemCount <
                                          snapshot.data['stockAvailable']
                                      ? () {
                                          setState(() {
                                            itemCount++;
                                          });
                                        }
                                      : null,
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 15.0, bottom: 15.0, right: 10.0),
                        width: MediaQuery.of(context).size.width / 2.35,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: StreamBuilder(
                            stream: Firestore.instance
                                .collection('Users')
                                .document(user.uid)
                                .collection('Cart')
                                .snapshots(),
                            builder: (context, snapshot) {
                              var dataCount = snapshot.data.documents.length;
                              print(dataCount);
                              for (var i = 0; i < dataCount; i++) {
                                if (snapshot.data.documents[i]['title'] ==
                                    widget.title) {
                                  cartAdded = true;
                                }
                              }
                              return OutlineButton(
                                onPressed: cartAdded == true
                                    ? null
                                    : () {
                                        _addToCart();
                                      },
                                highlightedBorderColor: MyColors.TEXT_COLOR,
                                highlightColor: MyColors.TEXT_FIELD_BCK,
                                splashColor: MyColors.TEXT_COLOR,
                                borderSide: BorderSide(
                                  color: MyColors.TEXT_FIELD_BCK,
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.add_shopping_cart,
                                      color: MyColors.TEXT_COLOR,
                                    ),
                                    Expanded(
                                      child: Text(
                                        cartAdded == true
                                            ? 'ADDED TO CART'
                                            : 'ADD TO CART',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: MyColors.TEXT_COLOR,
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      StreamBuilder(
                          stream: Firestore.instance
                              .collection(widget.category)
                              .document(widget.title)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return Container(
                              margin: EdgeInsets.only(
                                  top: 15.0, bottom: 15.0, left: 10.0),
                              width: MediaQuery.of(context).size.width / 2.35,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: OutlineButton(
                                onPressed: snapshot.data['stockAvailable'] > 0
                                    ? () {
                                        showAddressAlertDialog(
                                            context,
                                            user,
                                            itemCount,
                                            widget.title,
                                            widget.name,
                                            widget.cost,
                                            widget.url);
                                        // openCheckout();
                                      }
                                    : null,
                                highlightedBorderColor: MyColors.TEXT_COLOR,
                                highlightColor: MyColors.TEXT_FIELD_BCK,
                                splashColor: MyColors.TEXT_COLOR,
                                borderSide: BorderSide(
                                  color: MyColors.TEXT_FIELD_BCK,
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.monetization_on,
                                      color: MyColors.TEXT_COLOR,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'BOOK NOW',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: MyColors.TEXT_COLOR,
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    shadowColor: MyColors.TEXT_FIELD_BCK,
                    margin: EdgeInsets.all(15),
                    elevation: 10,
                    child: Column(
                      children: [
                        widget.description != null
                            ? Container(
                                margin: EdgeInsets.all(15),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Description',
                                      style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 18,
                                          color: Colors.black.withOpacity(0.75),
                                          fontWeight: FontWeight.bold,
                                          wordSpacing: 2,
                                          letterSpacing: 1.20),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      widget.description,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 16,
                                          wordSpacing: 2,
                                          height: 1.75,
                                          letterSpacing: 1.20,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ))
                            : Text(''),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Similar Items',
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.75),
                          fontWeight: FontWeight.bold,
                          wordSpacing: 2,
                          letterSpacing: 1.20),
                    ),
                  ),
                  Suggestion(widget.category, widget.name),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Categories',
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.75),
                          wordSpacing: 2,
                          letterSpacing: 1.20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CategorySuggestions('Categories'),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
