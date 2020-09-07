import 'package:flutter/material.dart';

import '../../my_colors.dart';

class ViewItems extends StatefulWidget {
  String category;
  String title;
  String url;
  String description;
  String cost;

  ViewItems({
    this.title,
    this.url,
    this.description,
    this.category,
    this.cost
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
          title: Center(child: Text(widget.category,
          style: TextStyle(
            color: MyColors.TEXT_COLOR
          ),)),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
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
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Pacifico'
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.cost,
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Pacifico',
                      letterSpacing: 2
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: MyColors.TEXT_COLOR,
                  ),
                  child: FlatButton(
                    onPressed: null,
                    child: Text(
                      'PLACE ORDER',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                widget.description !=null? Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description :',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              wordSpacing: 2,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.20
                          ),
                        ),
                        SizedBox(height: 8,),
                        Text(
                          '\t\t\t\t\t\t'+widget.description,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              wordSpacing: 2,
                              letterSpacing: 1.20
                          ),
                        ),
                      ],
                    )
                ):Text(''),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
