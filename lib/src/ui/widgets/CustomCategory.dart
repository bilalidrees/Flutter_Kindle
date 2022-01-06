import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/resource/networkConstant.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTitleWidget.dart';
import 'package:hiltonSample/src/ui/ui_constants/ImageAssetsResolver.dart';
import 'package:hiltonSample/AppLocalizations.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';

class CustomCategory extends StatefulWidget {
  String imageUrl;
  GestureTapCallback onPressed;
  int index;

  CustomCategory({this.imageUrl, this.onPressed, this.index});

  @override
  _CustomCategoryState createState() => _CustomCategoryState();
}

class _CustomCategoryState extends State<CustomCategory> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Stack(
        children: <Widget>[
          Container(
            width: widget.index != 2
                ? AppConfig.of(context).appWidth(45)
                : AppConfig.of(context).appWidth(45),
            margin: EdgeInsets.only(
                left: AppConfig.of(context).appWidth(2),
                right: AppConfig.of(context).appWidth(5),
                top: AppConfig.of(context).appWidth(5),
                bottom: AppConfig.of(context).appWidth(5)),
            decoration: BoxDecoration(
              color: Colors.grey,
              boxShadow: [
                
                BoxShadow(
                  color: AppColors.mainScreenColorGradient2,
                  offset: Offset(4.0, 4.0),
                  blurRadius: 5.0,
                ),
                BoxShadow(
                  color: AppColors.mainScreenColorGradient1,
                  offset: Offset(-2.0, -2.0),
                  blurRadius: 5.0,
                ),
              ],
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[200],
                    Colors.grey[300],
                    Colors.grey[400],
                    Colors.grey[500],
                  ],
                  stops: [
                    0.1,
                    0.3,
                    0.8,
                    1
                  ]),
              image: DecorationImage(
                image: NetworkImage(
                  "${NetworkConstants.BASE_URL}${widget.imageUrl}",
                ),
                // image: NetworkImage(widget.imageUrl),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   mainAxisSize: MainAxisSize.max,
                //   children: <Widget>[
                //     Expanded(
                //       flex: 4,
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: <Widget>[
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             crossAxisAlignment: CrossAxisAlignment.end,
                //             children: <Widget>[
                //               Container(
                //                 margin: EdgeInsets.only(
                //                     left: AppConfig.of(context).appWidth(4)),
                //                 child: CustomTitleWidget(
                //                     context: context, title: widget.title),
                //               )
                //             ],
                //           ),
                //           SizedBox(height: 5),
                //         ],
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
