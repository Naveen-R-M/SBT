import 'package:SBT/screens/home/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../my_colors.dart';

class CustomerOrders extends StatefulWidget {
  @override
  _CustomerOrdersState createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  orders() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                'Customer Orders',
                style: TextStyle(
                    fontFamily: 'Pacifico', fontSize: 20, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            StreamBuilder(
              stream: Firestore.instance
                  .collection('Orders')
                  .orderBy('dateTime', descending: false)
                  .where('status', isEqualTo: 'UnDelivered')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                } else {
                  var data = snapshot.data.documents;
                  return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height - 160,
                    child: ListView.builder(
                      padding: EdgeInsets.all(5),
                      itemCount: data.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var path = data[index];
                        return Card(
                          elevation: 10,
                          shadowColor:
                              MyColors.TEXT_FIELD_BCK.withOpacity(0.50),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Card(
                                    shadowColor:
                                        MyColors.STATUS_BAR.withOpacity(0.5),
                                    elevation: 15,
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3.7,
                                      child: CachedNetworkImage(
                                        imageUrl: path.data['imageURL'],
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        width: 120,
                                        padding: EdgeInsets.all(5),
                                        margin: EdgeInsets.only(
                                            left: 15,
                                            right: 8.0,
                                            top: 8.0,
                                            bottom: 5),
                                        child: OutlineButton(
                                          onPressed: () async {
                                            await Firestore.instance
                                                .collection('Orders')
                                                .document(path.documentID)
                                                .updateData(
                                                    {'status': 'Delivered'})
                                                .whenComplete(() =>
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            '${path.documentID} , '
                                                            '${path.data['name']} deleted'))
                                                .timeout(Duration(minutes: 1));
                                          },
                                          child: Text(
                                            'MARK AS DELIVERED',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                height: 1.5),
                                          ),
                                          highlightedBorderColor:
                                              MyColors.TEXT_COLOR,
                                          highlightColor:
                                              MyColors.TEXT_FIELD_BCK,
                                          splashColor: MyColors.TEXT_COLOR,
                                          borderSide: BorderSide(
                                            color: MyColors.TEXT_FIELD_BCK,
                                            style: BorderStyle.solid,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 15, right: 8.0, bottom: 10, top: 8.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Product name\t : \t${path.data['name']}'
                                    '\nProductID\t : \t${path.data['productID']}'
                                    '\nQuantity\t : \t${path.data['quantity']}'
                                    '\nAmount Paid\t : \t₹${path.data['amount']}'
                                    '\nAddress\t : \n[ ${path.data['address']} ]'
                                    '\nBooking Date\t : \t[-- ${path.data['dateTime']} --]'
                                    '\nUsername\t : \t[ ${path.data['username']} ]'
                                    '\nUser PhoneNO\t : \t[ ${path.data['user phNo']} ]',
                                    style: TextStyle(
                                      color: MyColors.TEXT_COLOR,
                                      fontFamily: 'Lato',
                                      height: 1.5,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return orders();
  }
}
