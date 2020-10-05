import 'package:SBT/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../my_colors.dart';
import '../../loading.dart';

class SuccessfulTransactions extends StatefulWidget {
  @override
  _SuccessfulTransactionsState createState() => _SuccessfulTransactionsState();
}

class _SuccessfulTransactionsState extends State<SuccessfulTransactions> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    transaction() {
      return StreamBuilder(
        stream: Firestore.instance
            .collection('Users')
            .document(user.uid)
            .collection('Successful Transactions')
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
                  return GestureDetector(
                    child: Banner(
                      location: BannerLocation.topStart,
                      message: 'Success',
                      color: Colors.lightGreen,
                      child: Card(
                        elevation: 10,
                        shadowColor: MyColors
                            .TEXT_FIELD_BCK
                            .withOpacity(0.50),
                        child: Row(
                          children: [
                            Card(
                              shadowColor: MyColors
                                  .STATUS_BAR
                                  .withOpacity(0.5),
                              elevation: 15,
                              child: Container(
                                width:
                                MediaQuery.of(context)
                                    .size
                                    .width /
                                    3.3,
                                height:
                                MediaQuery.of(context)
                                    .size
                                    .height /
                                    6,
                                child: Image.network(
                                  path.data["imageURL"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 15,
                                      right: 8.0,
                                      top: 8.0),
                                  child: Align(
                                    alignment:
                                    Alignment.topLeft,
                                      child: Text(
                                        'Product name : ${path.data['name']}'
                                            '\nProductID : ${path.data['productID']}'
                                            '\nQuantity selected : ${path.data['quantity']}'
                                            '\nTotal cost : ₹${path.data['amount']}'
                                            '\nBooking date and time : \n${path.data['dateTime']}',
                                        style: TextStyle(
                                            color: MyColors.TEXT_COLOR,
                                            fontSize: 12,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.2,
                                            height: 1.6,
                                            wordSpacing: 1.2
                                        ),
                                      ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      );
    }

    return transaction();
  }
}
