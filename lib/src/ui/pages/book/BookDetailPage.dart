import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hiltonSample/route_generator.dart';
import 'package:hiltonSample/src/model/Book.dart';
import 'package:hiltonSample/src/model/Part.dart';
import 'package:hiltonSample/src/resource/networkConstant.dart';
import 'package:hiltonSample/src/ui/pages/book/AudioScreen.dart';
import 'package:hiltonSample/src/ui/pages/other_module/MainPageNavigator.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/style.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/bloc/ThemeBloc.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/ui/widgets/CustomBackButton.dart';
import 'package:hiltonSample/src/ui/widgets/CustomNewsWidget.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTitleWidget.dart';
import 'package:provider/provider.dart';

import '../../../provider_locale_data.dart';

class BookDetailPage extends StatefulWidget {
  Book book;

  BookDetailPage({this.book});

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  ThemeBloc themeBloc;
  bool darkThemeSelected;

  @override
  void initState() {
    themeBloc = ThemeBloc.getInstance();
    darkThemeSelected = themeBloc.isDarkThemeSelected;
    themeBloc.darkThemeIsEnabled.listen((value) {
      setState(() {
        darkThemeSelected = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Hero(
              tag: widget.book.id,
              child: Container(
                height: AppConfig.of(context).appHeight(58),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "${NetworkConstants.BASE_URL}${widget.book.image.url}"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Container(),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.4,
              maxChildSize: 0.8,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                if (widget.book.parts.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(AppConfig.of(context).appWidth(10)),
                    child: Center(
                        child: CustomTitleWidget(
                            context: context, title: "New parts coming soon!")),
                  );
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      color: darkThemeSelected
                          ? Color(0xFF353434)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      controller: scrollController,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            SizedBox(
                                height: AppConfig.of(context).appWidth(10)),
                            CustomScrollView(
                              shrinkWrap: true,
                              slivers: [
                                SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                  Part episodeItem = widget.book.parts[index];
                                  episodeItem.bookId = widget.book.id;
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        //part_container
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: AppConfig.of(context)
                                                  .appWidth(2),
                                              right: AppConfig.of(context)
                                                  .appWidth(3)),
                                          child: CustomNewsWidget(
                                            onPressed: () async {
                                              Provider.of<RecentlyPlayed>(
                                                      context,
                                                      listen: false)
                                                  .recentlyPlayedList
                                                  .add(episodeItem);
                                              await Provider.of<RecentlyPlayed>(
                                                      context,
                                                      listen: false)
                                                  .saveData();
                                              Navigator.of(context).pushNamed(
                                                  RouteNames.MAINPAGE,
                                                  arguments: ScreenArguments(
                                                      currentPage: AudioScreen(
                                                        book: widget.book,
                                                        episode: episodeItem,
                                                      ),
                                                      message:
                                                          episodeItem.title));
                                            },
                                            episode: episodeItem,
                                            book: widget.book,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }, childCount: widget.book.parts.length)),
                              ],
                            ),
                            SizedBox(
                                height: AppConfig.of(context).appWidth(12)),
                          ],
                        );
                      },
                    ),
                  );
                }
              },
            ),
            CustomBackButton(darkThemeSelected: darkThemeSelected),
          ],
        ),
      ),
    );
  }
}
