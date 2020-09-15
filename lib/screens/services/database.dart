import 'package:cloud_firestore/cloud_firestore.dart';

class Database{
  final String uid;
  Database({this.uid});
  final CollectionReference ref = Firestore.instance.collection('Users');

  Future UserData(String phone, String location)async{
    return await ref.document(uid).setData(
      {
        'uid':uid,
        'phone':phone,
        'location':location,
      }
    );
  }
}