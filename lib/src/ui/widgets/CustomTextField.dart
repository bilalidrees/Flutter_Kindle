import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/utility/Validations.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/style.dart';

import '../../../AppLocalizations.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';

class CustomTextField extends StatelessWidget {
  String labelText;
  TextInputType textInputType;
  VALIDATION_TYPE validationType;
  IconData icon;
  TextEditingController controller;
  bool obscureText, isEnabled;
  Function onPasswordVisiblityChange;
  Function onKeyPressed;

  CustomTextField(
      this.labelText,
      this.textInputType,
      this.validationType,
      this.icon,
      this.controller,
      this.obscureText,
      this.onPasswordVisiblityChange,
      {this.isEnabled,
      this.onKeyPressed});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: (isEnabled != null ? isEnabled : true),
      controller: controller,
      enableInteractiveSelection: true,
      obscureText: obscureText,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: AppConfig.of(context).appWidth(3.5),
        color: AppColors.black,
        fontWeight: FontWeight.w300,
      ),
      keyboardType: textInputType,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.greyTextColor,
        prefixIcon: Icon(
          icon,
          color: AppColors.timberWolf,
        ),
        suffixIcon: IconButton(
          icon: checkForVisiblityIcon(),
          onPressed: onPasswordVisiblityChange,
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: AppConfig.of(context).appWidth(3.5),
          color: AppColors.mainScreenColor,
          fontWeight: FontWeight.w300,
        ),
        contentPadding: EdgeInsets.fromLTRB(15.0, 16.0, 15.0, 16.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.timberWolf, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (value) => checkFieldValidation(
          val: value,
          password: '',
          fieldName:
              "${AppLocalizations.of(context).translate(Strings.PLEASE_ENTER_TEXT)} $labelText ",
          fieldType: validationType,
          context: context),
      onFieldSubmitted: (value) => {onKeyPressed()},
    );
  }

  Widget checkForVisiblityIcon() {
    if (validationType == VALIDATION_TYPE.PASSWORD) {
      if (obscureText) {
        return Icon(
          Icons.visibility_off,
          color: AppColors.timberWolf,
        );
      } else {
        return Icon(
          Icons.visibility,
          color: AppColors.timberWolf,
        );
      }
    } else {
      return Container();
    }
  }
}
