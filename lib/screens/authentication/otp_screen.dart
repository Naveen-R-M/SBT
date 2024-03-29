import 'package:SBT/my_colors.dart';
import 'package:SBT/screens/authentication/auth.dart';
import 'package:SBT/screens/services/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class OtpScreen extends StatefulWidget {
  String phone;
  String name;
  OtpScreen({this.phone, this.name});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otp1, otp2, otp3, otp4, otp5, otp6;
  var location;
  String buttonText = 'Send OTP';
  AuthService _authService = AuthService();

  _getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String city = '${placemark.locality}';
    UserLocation.locality = placemark.locality;
    UserLocation.latitude = position.latitude.toString();
    UserLocation.longitude = position.longitude.toString();
    UserLocation.area = '${placemark.administrativeArea} , ${placemark.subAdministrativeArea}';
    UserLocation.postalCode = placemark.postalCode;
    return city;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'images/otp_verification.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                  left: 25,
                  top: MediaQuery.of(context).size.height / 13.617,
                ),
                child: Text(
                  'OTP Verification',
                  style: TextStyle(
                    color: MyColors.TEXT_COLOR,
                    fontSize: 28,
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                margin: EdgeInsets.only(left: 25),
                width: double.infinity,
                child: Text(
                  'Enter the OTP received',
                  style: TextStyle(
                    color: MyColors.TEXT_COLOR,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 40,
                    decoration: BoxDecoration(
                      color: MyColors.TEXT_FIELD_BCK,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: EdgeInsets.only(
                      left: 10,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      onChanged: (val) => otp1 = val,
                      style: TextStyle(
                          color: MyColors.TEXT_COLOR,
                          fontSize: 18,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w800),
                      cursorColor: MyColors.TEXT_COLOR,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColors.TEXT_FIELD_BCK,
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors.TEXT_FIELD_BCK),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors.TEXT_FIELD_BCK),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    decoration: BoxDecoration(
                      color: MyColors.TEXT_FIELD_BCK,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: EdgeInsets.only(
                      left: 10,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      onChanged: (val) => otp2 = val,
                      style: TextStyle(
                          color: MyColors.TEXT_COLOR,
                          fontSize: 18,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w800),
                      maxLines: 1,
                      cursorColor: MyColors.TEXT_COLOR,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColors.TEXT_FIELD_BCK,
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors.TEXT_FIELD_BCK),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors.TEXT_FIELD_BCK),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    decoration: BoxDecoration(
                      color: MyColors.TEXT_FIELD_BCK,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: EdgeInsets.only(
                      left: 10,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      onChanged: (val) => otp3 = val,
                      style: TextStyle(
                          color: MyColors.TEXT_COLOR,
                          fontSize: 18,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w800),
                      maxLines: 1,
                      cursorColor: MyColors.TEXT_COLOR,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColors.TEXT_FIELD_BCK,
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors.TEXT_FIELD_BCK),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors.TEXT_FIELD_BCK),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    decoration: BoxDecoration(
                      color: MyColors.TEXT_FIELD_BCK,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: EdgeInsets.only(
                      left: 10,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      onChanged: (val) => otp4 = val,
                      style: TextStyle(
                          color: MyColors.TEXT_COLOR,
                          fontSize: 18,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w800),
                      maxLines: 1,
                      cursorColor: MyColors.TEXT_COLOR,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColors.TEXT_FIELD_BCK,
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors.TEXT_FIELD_BCK),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors.TEXT_FIELD_BCK),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    decoration: BoxDecoration(
                      color: MyColors.TEXT_FIELD_BCK,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: EdgeInsets.only(
                      left: 10,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      onChanged: (val) => otp5 = val,
                      style: TextStyle(
                          color: MyColors.TEXT_COLOR,
                          fontSize: 18,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w800),
                      maxLines: 1,
                      cursorColor: MyColors.TEXT_COLOR,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColors.TEXT_FIELD_BCK,
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors.TEXT_FIELD_BCK),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors.TEXT_FIELD_BCK),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    decoration: BoxDecoration(
                      color: MyColors.TEXT_FIELD_BCK,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: EdgeInsets.only(
                      left: 10,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      onChanged: (val) => otp6 = val,
                      style: TextStyle(
                          color: MyColors.TEXT_COLOR,
                          fontSize: 18,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w800),
                      maxLines: 1,
                      cursorColor: MyColors.TEXT_COLOR,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColors.TEXT_FIELD_BCK,
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors.TEXT_FIELD_BCK),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors.TEXT_FIELD_BCK),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Container(
                  height: 45,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: MyColors.TEXT_COLOR,
                  ),
                  child: FlatButton(
                    onPressed: () async {
                      location = await _getLocation();
                      setState(() {
                        buttonText = 'Proceed';
                      });
                      dynamic result = await _authService.loginUser(
                        location,
                        widget.phone,
                        widget.name,
                        context,
                        otp1,
                        otp2,
                        otp3,
                        otp4,
                        otp5,
                        otp6
                      );
                      if (result != null) {
                        print('Success..!');
                      }
                    },
                    child: Text(
                      buttonText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyColors.TEXT_FIELD_BCK,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
