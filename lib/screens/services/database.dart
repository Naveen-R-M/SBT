import 'package:SBT/screens/services/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database{
  final String uid;
  Database({this.uid});
  final CollectionReference ref = Firestore.instance.collection('Users');

  Future UserData(String phone,String name, String location)async{
    return await ref.document(uid).setData(
      {
        'uid':uid,
        'phone':phone,
        'name' :name,
        'location':location,
        'state':UserLocation.area,
        'postal code':UserLocation.postalCode,
        'latitude':UserLocation.latitude,
        'longitude':UserLocation.longitude,
      }
    );
  }
}