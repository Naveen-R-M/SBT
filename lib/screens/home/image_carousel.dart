import 'package:SBT/my_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class ImageCarousel extends StatelessWidget {
  var collection,document;

  ImageCarousel({this.collection,this.document});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height/2.7,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
              stream: Firestore.instance.collection(collection).document(document).snapshots(),
              builder: (context, snapshot) {
                var data = snapshot.data;
                return Carousel(
                  boxFit: BoxFit.cover,
                  images: [
                    NetworkImage(data['Sarees']),
                    NetworkImage(data['Shirts']),
                    NetworkImage(data['T-Shirts']),
                  ],
                  dotVerticalPadding: 50,
                  autoplay: true,
                  dotBgColor: Colors.purple.withOpacity(0),
                  indicatorBgPadding: 5.0,
                  dotColor: MyColors.TEXT_COLOR,
                  dotSize: 4.0,
                );
              }
          ),
          decoration: BoxDecoration(
              color: Color(0xff242E38),
              border: Border(
                bottom: BorderSide(
                  width: 1,color: MyColors.APP_BCK,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff0A0A14),
                  blurRadius: 30,
                  offset: Offset(5 , 2),
                )
              ]
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height/2.7,
          width: MediaQuery.of(context).size.width,
          color: MyColors.APP_BCK.withOpacity(0.25),
        )
      ],
    );
  }
}
