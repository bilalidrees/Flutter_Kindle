import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/model/Book.dart';
import 'package:hiltonSample/src/model/Part.dart';
import 'package:hiltonSample/src/resource/networkConstant.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/style.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/bloc/ThemeBloc.dart';

import 'dart:math';

class CustomNewsWidget extends StatefulWidget {
  GestureTapCallback onPressed;
  Book book;
  Part episode;

  CustomNewsWidget({this.book, this.onPressed, this.episode});

  @override
  _CustomNewsWidgetState createState() => _CustomNewsWidgetState();
}

class _CustomNewsWidgetState extends State<CustomNewsWidget> {
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
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            margin: EdgeInsets.fromLTRB(
                AppConfig.of(context).appWidth(10),
                AppConfig.of(context).appWidth(5),
                AppConfig.of(context).appWidth(5),
                AppConfig.of(context).appWidth(1)),
            height: widget.episode != null
                ? AppConfig.of(context).appWidth(42)
                : AppConfig.of(context).appWidth(50),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    AppColors.mainScreenColorGradient1,
                    AppColors.mainScreenColorGradient2.withOpacity(0.9),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
              color:
                  darkThemeSelected ? AppColors.mainScreenColor : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Container(
              margin: EdgeInsets.only(
                  left: AppConfig.of(context).appWidth(35),
                  top: AppConfig.of(context).appWidth(2),
                  right: AppConfig.of(context).appWidth(3)),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.episode == null
                            ? widget.book.title
                            : widget.episode.title,
                        style: Theme.of(context).textTheme.headline3,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppConfig.of(context).appWidth(1.5),
                  ),
                  Container(
                    height: AppConfig.of(context).appWidth(13),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.episode == null
                            ? widget.book.description
                            : widget.episode.description,
                        style: Theme.of(context).textTheme.headline5,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppConfig.of(context).appWidth(2),
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.episode == null
                            ? "${widget.book.parts.length} Episode"
                            : "Episode ${(widget.episode.sno + 1).toString()}",
                        style: Theme.of(context).textTheme.headline5,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppConfig.of(context).appWidth(2),
                  ),
                  if (widget.episode != null)
                    Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.episode.audio.name,
                          style: Theme.of(context).textTheme.headline5,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  if (widget.episode == null)
                    Container(
                      alignment: Alignment.centerLeft,
                      child: RatingBar(
                        initialRating: 3,
                        minRating: 1,
                        itemSize: 17,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemBuilder: (context, _) => Icon(Icons.star,
                            color: AppColors.of(context).mainColor(1)),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ),
                  SizedBox(
                    height: AppConfig.of(context).appWidth(2),
                  ),
                  if (widget.episode == null)
                    Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "5 Reviews" ?? "",
                          style: Theme.of(context).textTheme.headline5,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: AppConfig.of(context).appWidth(5),
          top: AppConfig.of(context).appWidth(8),
          bottom: AppConfig.of(context).appWidth(4),
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                width: AppConfig.of(context).appWidth(35),
                image: NetworkImage(
                    "${NetworkConstants.BASE_URL}${widget.book.image.url}"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
