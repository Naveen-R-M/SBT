import 'package:SBT/screens/home/additional_images.dart';
import 'package:SBT/screens/home/suggestion.dart';
import 'package:SBT/screens/home/suggestion_category.dart';
import 'package:SBT/screens/services/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
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
  Razorpay _razorpay;

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

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_iXSAz7jqJc5n0D',
      'amount': 100 * 100,
      'name': 'SBT Shopping',
      'description': 'Happy shopping with us',
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: 'Your paymentID ${response.paymentId} is successful');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: 'Your payment is failed with ${{
      response.code
    }.toString()}\nERROR Message:${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: 'External Wallet selected : ${response.walletName}');
  }

  _getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    UserLocation.locality = placemark.locality;
    UserLocation.latitude = position.latitude.toString();
    UserLocation.longitude = position.longitude.toString();
    UserLocation.area =
        '${placemark.administrativeArea} , ${placemark.subAdministrativeArea}';
    UserLocation.postalCode = placemark.postalCode;
  }

  @override
  Widget build(BuildContext context) {
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
                        cost: widget.cost,
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
                      widget.cost,
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: MyColors.TEXT_FIELD_BCK,
                              radius: 35,
                              child: IconButton(
                                icon: Icon(Icons.phone),
                                color: MyColors.TEXT_COLOR,
                                iconSize: 40,
                                onPressed: () async {
                                  var admin_mobile_no = await Firestore.instance
                                      .collection('Admin')
                                      .document('Mobile No')
                                      .get();
                                  await launch(
                                      'tel:' + '${admin_mobile_no['phoneNo']}');
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              width: 100,
                              child: Center(
                                child: Text(
                                  'Book through phone',
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
                                  _getLocation();
                                  var admin_no = await Firestore.instance
                                      .collection('Admin')
                                      .document('Phone No')
                                      .get();
                                  FlutterOpenWhatsapp.sendSingleMessage(
                                      "${admin_no["phoneNo"]}",
                                      'Product ID : ${widget.title}'
                                          '\nCost : ${widget.cost}'
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
                                  'Book through whatsapp',
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
                                icon: Icon(Icons.monetization_on),
                                color: MyColors.TEXT_COLOR,
                                iconSize: 40,
                                onPressed: () {
                                  openCheckout();
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              width: 100,
                              child: Center(
                                child: Text(
                                  'Book through online',
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
                  ),
                  SizedBox(
                    height: 15,
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
