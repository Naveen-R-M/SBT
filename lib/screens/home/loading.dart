import 'package:SBT/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/2,
      child: Center(
        child: SpinKitFadingCircle(
          color: MyColors.TEXT_COLOR,
          size: 50.0,
        ),
      ),
    );
  }
}
