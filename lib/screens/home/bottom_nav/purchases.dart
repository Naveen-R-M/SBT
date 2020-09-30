import 'package:SBT/screens/home/bottom_nav/transactions/failed_transactions.dart';
import 'package:SBT/screens/home/bottom_nav/transactions/successful_transactions.dart';
import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';

import '../../../my_colors.dart';

class Purchases extends StatefulWidget {
  @override
  _PurchasesState createState() => _PurchasesState();
}

//1635296430

enum Transaction {
  successfulTransaction,
  failedTransaction,
}

class _PurchasesState extends State<Purchases> {
  Transaction transaction = Transaction.successfulTransaction;

  @override
  Widget build(BuildContext context) {
    purchases() {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  'Purchase History',
                  style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 20,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onHorizontalDragEnd: (DragEndDetails) {
                      setState(() {
                        transaction = Transaction.failedTransaction;
                      });
                    },
                    onTap: () {
                      setState(() {
                        transaction = Transaction.successfulTransaction;
                      });
                    },
                    child: transaction == Transaction.successfulTransaction
                        ? Container(
                      padding: EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        right: 16,
                        left: 16,
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.TEXT_FIELD_BCK.withOpacity(0.6),
                        borderRadius:
                        BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            'Successful Transactions',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                        : Row(
                      children: [
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'Successful Transactions',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onHorizontalDragStart: (DragEndDetails) {
                      setState(() {
                        transaction = Transaction.successfulTransaction;
                      });
                    },
                    onTap: () {
                      setState(() {
                        transaction = Transaction.failedTransaction;
                      });
                    },
                    child: transaction == Transaction.failedTransaction
                        ? Container(
                      padding: EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        right: 16,
                        left: 16,
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.TEXT_FIELD_BCK.withOpacity(0.6),
                        borderRadius:
                        BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            'Failed Transactions',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                        : Row(
                      children: [
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'Failed Transactions',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SwipeDetector(
                onSwipeLeft: (){
                  setState(() {
                    transaction = Transaction.failedTransaction;
                  });
                },
                onSwipeRight: (){
                  setState(() {
                    transaction = Transaction.successfulTransaction;
                  });
                },
                child:transaction == Transaction.successfulTransaction
                    ?SuccessfulTransactions()
                    :FailedTransactions(),
              ),
            ],
          ),
        ),
      );
    }
    return purchases();
  }
}
