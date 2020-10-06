import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerOrders extends StatefulWidget {
  @override
  _CustomerOrdersState createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  orders() async{
    var ref = await Firestore.instance.collection('Orders').document()
    .collection('Successful Transactions').getDocuments();
    for (var i = 0 ; i<ref.documents.length; i++){
      print(ref.documents[i].data);
    }
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
