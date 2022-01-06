import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';

class CustomLoader extends StatefulWidget {
  @override
  _CustomLoaderState createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.mainScreenColor,
        child: Center(child: SpinKitRotatingCircle(color: AppColors.white)));
  }
}
