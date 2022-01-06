import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/bloc/ThemeBloc.dart';
import 'package:hiltonSample/AppLocalizations.dart';

class CustomException extends StatefulWidget {
  @override
  _CustomExceptionState createState() => _CustomExceptionState();
}

class _CustomExceptionState extends State<CustomException> {
  ThemeBloc themeBloc;
  bool darkThemeSelected;

  @override
  void initState() {
    themeBloc = ThemeBloc.getInstance();
    darkThemeSelected = themeBloc.isDarkThemeSelected;
    themeBloc.darkThemeIsEnabled.listen((value) {
      darkThemeSelected = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: AppConfig.of(context).appWidth(10),
          left: AppConfig.of(context).appWidth(7.4),
          right: AppConfig.of(context).appWidth(10),
          bottom: AppConfig.of(context).appWidth(7.4)),
      height: AppConfig.of(context).appWidth(25),
      width: double.infinity,
      decoration: BoxDecoration(
        color:
            darkThemeSelected ? AppColors.mainScreenColor : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Container(
        margin: EdgeInsets.only(
            right: AppConfig.of(context).appWidth(3),
            left: AppConfig.of(context).appWidth(3)),
        height: AppConfig.of(context).appWidth(13),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "You haven't played recently...",
            style: Theme.of(context)
                .textTheme
                .headline2
                .copyWith(fontSize: AppConfig.of(context).appWidth(6)),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}
