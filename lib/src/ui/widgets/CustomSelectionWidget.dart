import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/style.dart';

class CustomSelectionWidget extends StatefulWidget {
  int value, selectedValue;
  GestureTapCallback onPressed;

  CustomSelectionWidget(
      { this.value, this.selectedValue, this.onPressed});

  @override
  _CustomSelectionWidgetState createState() => _CustomSelectionWidgetState();
}

class _CustomSelectionWidgetState extends State<CustomSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  left: AppConfig.of(context).appWidth(1),
                  right: AppConfig.of(context).appWidth(4),
                  top: AppConfig.of(context).appWidth(1),
                  bottom: AppConfig.of(context).appWidth(1)),
              decoration: BoxDecoration(
                color: widget.value == widget.selectedValue
                    ? AppColors.mainScreenColor
                    : AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[600],
                    offset: Offset(4.0, 4.0),
                    blurRadius: 3.0,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-2.0, -2.0),
                    blurRadius: 3.0,
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              padding: EdgeInsets.all(AppConfig.of(context).appWidth(5)),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: Container(
                  padding: EdgeInsets.all(AppConfig.of(context).appWidth(5.88)),
                  decoration: BoxDecoration(
                    color:AppColors.white ,
                    image: DecorationImage(
                      image: NetworkImage("https://picsum.photos/seed/picsum/200/300"),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppConfig.of(context).appWidth(2)),
            Container(
              height: AppConfig.of(context).appWidth(10),
              width: AppConfig.of(context).appWidth(23),
              margin: EdgeInsets.only(
                  left: AppConfig.of(context).appWidth(1.2),
                  bottom: AppConfig.of(context).appWidth(2)),
              child: Text(
                "widget.subCategory.label",
                style: Theme.of(context).textTheme.headline3,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
