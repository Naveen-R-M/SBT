import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerOrders extends StatefulWidget {
  @override
  _CustomerOrdersState createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  orders() async {
    var ref = await Firestore.instance.collection('Orders').getDocuments();
    print(ref.documents.length);
    for (var i = 0; i < ref.documents.length; i++) {
      var orderRef = await Firestore.instance
          .collection('Orders')
          .document(ref.documents[i].documentID)
          .collection('Transactions')
          .getDocuments();
      for (var j = 0; j < orderRef.documents.length; j++) {
        var successRef = await Firestore.instance
            .collection('Orders')
            .document(ref.documents[i].documentID)
            .collection('Transactions')
            .document(orderRef.documents[j].documentID).get();
        print(successRef['status']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    orders();
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.pink,
      child: GestureDetector(
        onTap: () {
          print('tapped');
          orders();
        },
      ),
    );
  }
}
