import 'package:flutter/material.dart';

import '../../my_colors.dart';

class ViewItems extends StatefulWidget {
  String category;
  String title;
  String url;
  String description;

  ViewItems({
    this.title,
    this.url,
    this.description,
    this.category,
});

  @override
  _ViewItemsState createState() => _ViewItemsState();
}

class _ViewItemsState extends State<ViewItems> {
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
          title: Center(child: Text(widget.category)),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  height: MediaQuery.of(context).size.height/1.75,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.url),
                      fit: BoxFit.cover
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [
                            MyColors.STATUS_BAR.withOpacity(0.3),
                            MyColors.APP_BCK.withOpacity(.0),
                          ]
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
