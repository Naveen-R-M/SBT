import 'package:SBT/my_colors.dart';
import 'package:SBT/screens/authentication/otp_screen.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String phone;
  String name;

  final _formkey = GlobalKey<FormState>();

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
              'images/otp_screen.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Form(
            key: _formkey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    left: 25,
                    top: MediaQuery.of(context).size.height / 13.617,
                  ),
                  child: Text(
                    'WELCOME',
                    style: TextStyle(
                      color: MyColors.TEXT_COLOR,
                      fontSize: 28,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 25),
                  width: double.infinity,
                  child: Text(
                    'Enter your name',
                    style: TextStyle(
                      color: MyColors.TEXT_COLOR,
                      fontSize: 18,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: MyColors.TEXT_FIELD_BCK,
                  margin: EdgeInsets.only(
                    left: 23,
                    right: 23,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) =>
                        val.length < 1 ? "Enter your full name" : null,
                        keyboardType: TextInputType.text,
                        onChanged: (val) => name = val,
                        style: TextStyle(
                            color: MyColors.TEXT_COLOR,
                            letterSpacing: 3.0,
                            fontSize: 18,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w800,
                            ),
                        maxLines: 1,
                        cursorColor: MyColors.TEXT_COLOR,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: MyColors.TEXT_FIELD_BCK,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.only(left: 25),
                  width: double.infinity,
                  child: Text(
                    'Enter your phone number',
                    style: TextStyle(
                      color: MyColors.TEXT_COLOR,
                        fontSize: 18,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w800
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: MyColors.TEXT_FIELD_BCK,
                  margin: EdgeInsets.only(
                    left: 23,
                    right: 23,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) =>
                            val.length != 10 ? "Enter a valid phone number" : null,
                        keyboardType: TextInputType.phone,
                        onChanged: (val) => phone = val,
                        style: TextStyle(
                            color: MyColors.TEXT_COLOR,
                            letterSpacing: 3.0,
                            fontSize: 18,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w800),
                        maxLines: 1,
                        cursorColor: MyColors.TEXT_COLOR,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: MyColors.TEXT_FIELD_BCK,
                          prefix: Text(
                            '\t+91\t\t',
                            style: TextStyle(
                                color: MyColors.TEXT_COLOR,
                                fontSize: 18,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w800),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.TEXT_FIELD_BCK),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                      onPressed: () {
                        if (_formkey.currentState.validate()) {
                          String phone_no = '+91' + phone;
                          print(phone_no);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => OtpScreen(
                                  name: name,
                                      phone: phone_no,
                                    )),
                          );
                        }
                      },
                      child: Text(
                        'Proceed',
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
            ),
          )
        ],
      ),
    );
  }
}
