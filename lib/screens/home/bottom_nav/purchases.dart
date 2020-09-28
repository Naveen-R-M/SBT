import 'package:flutter/material.dart';

class Purchases extends StatefulWidget {
  @override
  _PurchasesState createState() => _PurchasesState();
}

//1635296430

class _PurchasesState extends State<Purchases> {
  purchases(){
    return Container(
      width: double.infinity,
      height: double.infinity,
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
                    fontFamily: 'Pacifico', fontSize: 22, color: Colors.black),
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
    return purchases();
  }
}
