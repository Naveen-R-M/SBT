import 'package:SBT/my_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'details.dart';
import 'loading.dart';

class CategorySuggestions extends StatelessWidget {
  var val;

  CategorySuggestions(this.val);

  Future _getImages(var val) async {
    var ref = Firestore.instance;
    QuerySnapshot qnRef = await ref.collection(val).getDocuments();
    return qnRef.documents;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future : _getImages(val),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Loading();
          }else{
            return Container(
              margin: EdgeInsets.only(left: 10),
              height: 130,
              child: ListView.builder(
                  itemCount: snapshot.data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    var path = snapshot.data[index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                            Details(title : path.documentID.toString())));
                        print(path.documentID.toString());
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 160,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      MyColors.APP_BCK.withOpacity(0.40),
                                      BlendMode.srcOver),
                                  image: NetworkImage(
                                    path.data['imageURL'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                color: MyColors.APP_BCK,
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,color: MyColors.APP_BCK,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: MyColors.APP_BCK,
                                    blurRadius: 10,
                                    offset: Offset(5 , 2),
                                  )
                                ]
                            ),
                          ),
                          Container(
                            width: 180,
                            child: Center(
                              child: Text(
                                snapshot.data[index].documentID,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: MyColors.TEXT_COLOR,
                                  fontSize: 18,
                                  fontFamily: 'Pacifico'
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            );
          }
        });
  }
}
