import 'package:SBT/my_colors.dart';
import 'package:SBT/screens/admin/add_category.dart';
import 'package:SBT/screens/admin/admin.dart';
import 'package:SBT/screens/admin/delete_category.dart';
import 'package:SBT/screens/home/item_view.dart';
import 'package:SBT/screens/home/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Details extends StatefulWidget {
  String title;

  Details({
    this.title,
  });

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String message;
  Stream _getImages() {
    var ref = Firestore.instance;
    return ref.collection(widget.title).snapshots();
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.APP_BCK.withOpacity(0.35),
    ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.APP_BCK,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(color: MyColors.TEXT_COLOR),
          ),
        ),
      ),
      floatingActionButton: Admin.admin == true
          ? SpeedDial(
              animatedIcon: AnimatedIcons.menu_arrow,
              children: [
                SpeedDialChild(
                    child: IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => DeleteCategories(
                                val: widget.title,
                              )),
                    );
                  },
                )),
                SpeedDialChild(
                    child: IconButton(
                      icon: Icon(Icons.add_circle),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                          builder: (context) => AddCategories(
                                val: widget.title,
                                imageURL: '',
                              )),
                        );
                        },
                    ),
                ),
              ],
            )
          : null,
      body:  RefreshIndicator(
        onRefresh: (){
          Navigator.pushReplacement(context,
            PageRouteBuilder(pageBuilder: (a,b,c)=>Details(title: widget.title,),
                transitionDuration: Duration(seconds: 0)
            ),
          );
          return Future.value(false);
        },
        child: StreamBuilder(
          stream: _getImages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            } else {
              var data = snapshot.data.documents;
              return Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: GridView.builder(
                  padding: EdgeInsets.all(5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.6),
                  ),
                  itemCount: data.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    var path = data[index];
                    return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ViewItems(
                                    title: path.documentID,
                                    url: path.data["imageURL"],
                                    cost: path.data["cost"],
                                    description: path.data["description"] ?? null,
                                    category: widget.title,
                                  )));
                        },
                        child: path.data['priority']=="High"?Banner(
                          location: BannerLocation.topEnd,
                          message: message,
                          textStyle: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.25
                          ),
                          child: Card(
                            elevation: 10,
                            shadowColor: MyColors.TEXT_COLOR.withOpacity(0.70),
                            child: Column(
                              children: [
                                Card(
                                  shadowColor: MyColors.STATUS_BAR.withOpacity(0.5),
                                  elevation: 15,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width/2.30,
                                    height: MediaQuery.of(context).size.height / 5,
                                    child: Image.network(
                                      path.data["imageURL"],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 8.0, right: 8.0, top: 8.0),
                                  child: Text(
                                    path.documentID,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: MyColors.TEXT_COLOR,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 8.0, right: 8.0, top: 8.0,bottom: 5),
                                  child: Text(
                                    path.data["cost"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: MyColors.TEXT_COLOR,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ):Card(
                      elevation: 10,
                      shadowColor: MyColors.TEXT_COLOR.withOpacity(0.70),
                      child: Column(
                        children: [
                          Card(
                            shadowColor: MyColors.STATUS_BAR.withOpacity(0.5),
                            elevation: 15,
                            child: Container(
                              width: MediaQuery.of(context).size.width/2.30,
                              height: MediaQuery.of(context).size.height / 5,
                              child: Image.network(
                                path.data["imageURL"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            child: Text(
                              path.documentID,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: MyColors.TEXT_COLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0,bottom: 5),
                            child: Text(
                              path.data["cost"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: MyColors.TEXT_COLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
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
        ),
      ),
    );
  }

  _message()async{
    var ref = await Firestore.instance.collection('Message').document('Banner').get();
    setState(() {
      message = ref["tag"].toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _message();
  }
}

//
//Container(
//height: 220,
//width: 160,
//margin: EdgeInsets.all(8),
//child: Align(
//alignment: Alignment.bottomRight,
//child: Text(
//'\$50',
//style: TextStyle(
//color: MyColors.TEXT_COLOR,
//fontSize: 22,
//),
//),
//),
//),
