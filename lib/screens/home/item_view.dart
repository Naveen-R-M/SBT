
import 'package:SBT/screens/home/suggestion.dart';
import 'package:SBT/screens/home/suggestion_category.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  margin: EdgeInsets.only(left: 15,right: 15,top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 35,
                        color: MyColors.TEXT_COLOR,
                        fontFamily: 'Pacifico'
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.cost,
                    style: TextStyle(
                        fontSize: 22,
                        color: MyColors.TEXT_COLOR,
                        fontFamily: 'Pacifico',
                      letterSpacing: 2
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  margin: EdgeInsets.all(15.0),
                  width: 200,
                  decoration: BoxDecoration(
                    color: MyColors.STATUS_BAR,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  child: FlatButton(
                    onPressed:()async{
                      await launch('tel:422 2394911');
                    },
                    child: Text(
                      'BOOK NOW',
                      style: TextStyle(
                          color: Colors.white,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Card(
                  shadowColor: MyColors.TEXT_FIELD_BCK,
                  margin: EdgeInsets.all(15),
                  elevation: 10,
                  child: Column(
                    children: [
                      widget.description !=null? Container(
                          margin: EdgeInsets.all(15),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description',
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 22,
                                    color: Colors.black.withOpacity(0.75),
                                    fontWeight: FontWeight.bold,
                                    wordSpacing: 2,
                                    letterSpacing: 1.20
                                ),
                              ),
                              SizedBox(height: 8,),
                              Text(
                                '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t'+widget.description,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 16,
                                    wordSpacing: 2,
                                    height: 1.75,
                                    letterSpacing: 1.20,
                                    fontWeight: FontWeight.w300
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 15,right: 15,),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Similar Items',
                    style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 22,
                        color: Colors.black.withOpacity(0.75),
                        fontWeight: FontWeight.bold,
                        wordSpacing: 2,
                        letterSpacing: 1.20
                    ),
                  ),
                ),
                Suggestion(widget.category),
                SizedBox(height: 5,),
                Container(
                  margin: EdgeInsets.only(left: 15,right: 15,),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Categories',
                    style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black.withOpacity(0.75),
                        wordSpacing: 2,
                        letterSpacing: 1.20
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                CategorySuggestions('Categories'),
                SizedBox(height: 15,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
