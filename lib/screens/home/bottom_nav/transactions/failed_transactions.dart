import 'package:SBT/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../my_colors.dart';
import '../../loading.dart';

class FailedTransactions extends StatefulWidget {
  @override
  _FailedTransactionsState createState() => _FailedTransactionsState();
}

class _FailedTransactionsState extends State<FailedTransactions> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    transaction() {
      return StreamBuilder(
        stream: Firestore.instance
            .collection('Users')
            .document(user.uid)
            .collection('Failed Transactions')
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
                                  2.5,
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
                                    path.data['name'],
                                    style: TextStyle(
                                      color: MyColors
                                          .TEXT_COLOR,
                                      fontFamily: 'Pacifico',
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 15,
                                    right: 8.0,
                                    top: 8.0,
                                    bottom: 5),
                                child: Text(
                                  '₹${path.data["amount"]}',
                                  textAlign:
                                  TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Pacifico',
                                    color: MyColors
                                        .TEXT_COLOR,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 15,
                                    right: 8.0,
                                    top: 8.0,
                                    bottom: 5),
                                child: Text(
                                  '${path.data['dateTime']}',
                                  textAlign:
                                  TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Pacifico',
                                    color: MyColors
                                        .TEXT_COLOR,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
