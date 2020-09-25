import 'package:SBT/model/user.dart';
import 'package:SBT/screens/home/additional_images.dart';
import 'package:SBT/screens/home/suggestion.dart';
import 'package:SBT/screens/home/suggestion_category.dart';
import 'package:SBT/screens/services/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import '../../my_colors.dart';

class ViewItems extends StatefulWidget {
  String category;
  String title;
  String url;
  String description;
  String cost;

  ViewItems({this.title, this.url, this.description, this.category, this.cost});

  @override
  _ViewItemsState createState() => _ViewItemsState();
}

class _ViewItemsState extends State<ViewItems> {
  var user;
  bool liked = false;
  bool cartAdded;
  Razorpay _razorpay;

  _addToLiked() async {
    var ref = Firestore.instance
        .collection('Users')
        .document(user.uid)
        .collection('Liked')
        .document();
    return await ref.setData({
      'category': widget.category,
      'title': widget.title,
      'cost': widget.cost,
      'description': widget.description,
      'imageURL': widget.url,
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
      'cost': widget.cost,
      'description': widget.description,
      'imageURL': widget.url,
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

  _update() async {
    var ref = await Firestore.instance
        .collection(widget.category)
        .document(widget.title)
        .get();
    if (ref.data['stockAvailable'] > 0) {
      return await Firestore.instance
          .collection(widget.category)
          .document(widget.title)
          .updateData({
        'stockAvailable': ref["stockAvailable"] - 1,
      });
    }
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_iXSAz7jqJc5n0D',
      'amount': num.parse(widget.cost) * 100,
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
    _update();
    DateTime now = DateTime.now();
    await Firestore.instance
        .collection('Users')
        .document(user.uid)
        .collection('Successful Transactions')
        .document()
        .setData({
      'dateTime': now,
      'result': 'Success',
      'category': widget.category,
      'productID': widget.title,
      'amount': widget.cost,
      'imageURL': widget.url,
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    Fluttertoast.showToast(
        msg: 'Your payment is failed with ${{
      response.code
    }.toString()}\nERROR Message:${response.message}');
    DateTime now = DateTime.now();
    await Firestore.instance
        .collection('Users')
        .document(user.uid)
        .collection('Failed Transactions')
        .document()
        .setData({
      'dateTime': now,
      'result': 'Failed',
      'category': widget.category,
      'productID': widget.title,
      'amount': widget.cost,
      'imageURL': widget.url,
    });
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
            style: TextStyle(color: MyColors.TEXT_COLOR),
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
                        cost: '₹${widget.cost}',
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
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                              MyColors.STATUS_BAR.withOpacity(0.3),
                              MyColors.APP_BCK.withOpacity(.0),
                            ]),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.title,
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
                                for (var i = 0 ; i<snapshot.data.documents.length;i++){
                                  if(snapshot.data.documents[i]["title"]==widget.title){
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
                                    onPressed: () {
                                      _addToLiked();
                                      setState(() {
                                        liked = true;
                                      });
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
                              icon: Image.asset('images/whatsapp_logo.png'),
                              color: MyColors.TEXT_COLOR,
                              iconSize: 40,
                              onPressed: () async {
                                var admin_no = await Firestore.instance
                                    .collection('Admin')
                                    .document('Phone No')
                                    .get();
                                FlutterOpenWhatsapp.sendSingleMessage(
                                    "${admin_no["phoneNo"]}",
                                    'Product ID : ${widget.title}'
                                        '\nCost : ₹${widget.cost}'
                                        '\nDescription : ${widget.description}'
                                        '\n\nAddress:'
                                        '\nArea : ${UserLocation.area}'
                                        '\nLocality : ${UserLocation.locality}'
                                        '\nPostal Code : ${UserLocation.postalCode}'
                                        '\nLatitude : ${UserLocation.latitude}'
                                        '\nLongitude : ${UserLocation.longitude}');
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            width: 100,
                            child: Center(
                              child: Text(
                                'Share via whatsapp',
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
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 15.0, bottom: 15.0, right: 10.0),
                        width: 140,
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
                      Container(
                        margin: EdgeInsets.only(
                            top: 15.0, bottom: 15.0, left: 10.0),
                        width: 140,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: OutlineButton(
                          onPressed: () {
                            openCheckout();
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      ),
                    ],
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
                  Suggestion(widget.category),
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
