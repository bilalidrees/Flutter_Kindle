import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/utility/AppUtility.dart';
import 'package:hiltonSample/src/model/Book.dart';
import 'package:hiltonSample/src/model/Part.dart';
import 'package:hiltonSample/src/resource/networkConstant.dart';
import 'package:hiltonSample/src/ui/pages/book/BookDetailPage.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/ui/widgets/CustomShimmerView.dart';
import 'package:hiltonSample/AppLocalizations.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/ui/pages/book/SubCategoryPage.dart';
import 'package:hiltonSample/src/ui/ui_constants/ImageAssetsResolver.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/style.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTitleWidget.dart';
import 'package:hiltonSample/src/ui/widgets/CustomCategory.dart';
import 'package:hiltonSample/src/ui/widgets/CustomLoader.dart';
import 'package:hiltonSample/src/ui/widgets/CustomNewsWidget.dart';
import 'package:hiltonSample/src/ui/widgets/CustomException.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../../../../route_generator.dart';
import 'package:hiltonSample/src/bloc/BookBloc.dart';
import 'package:hiltonSample/src/ui/pages/other_module/MainPageNavigator.dart';
import 'package:hiltonSample/src/bloc/ThemeBloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../provider_locale_data.dart';
import 'AudioScreen.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  bool isDataFetching = true;
  BookBloc bookBloc;
  ThemeBloc themeBloc;
  bool darkThemeSelected;
  String currentSelectedSubCategorySource, currentSelectedSubCategorySourceLogo;
  final ValueNotifier<int> indexNotifier = ValueNotifier(0);

  initState() {
    themeBloc = ThemeBloc.getInstance();
    darkThemeSelected = themeBloc.isDarkThemeSelected;
    themeBloc.darkThemeIsEnabled.listen((value) {
      setState(() {
        darkThemeSelected = value;
      });
    });
    Future.delayed(Duration(seconds: 5)).then((value) {
      setState(() {
        isDataFetching = false;
      });
    });
    bookBloc = BookBloc();
    bookBloc.getBooksDetails();
    bookBloc.bookStream.listen((modelList) {
      bookBloc.bookList = bookBloc.englishList;
      updateLoadingStatus(isloading: false);
    });

    super.initState();
  }

  @override
  void dispose() {
    indexNotifier.dispose();
    super.dispose();
  }

  void updateLoadingStatus({bool isloading}) {
    setState(() {
      isLoading = isloading;
    });
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading)
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: darkThemeSelected ? Color(0xFF353434) : Colors.grey[200],
          ),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  ValueListenableBuilder<int>(
                    valueListenable: indexNotifier,
                    builder: (context, value, child) => CarouselSlider.builder(
                      options: CarouselOptions(
                          autoPlay: true,
                          viewportFraction: 0.65,
                          height: AppConfig.of(context).appWidth(100),
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          pauseAutoPlayOnTouch: false,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {
                            indexNotifier.value = index;
                          }),
                      itemCount: bookBloc.bookList.length,
                      itemBuilder: (context, index, pageIndex) {
                        return Transform.scale(
                          scale: index == value ? 1 : 0.75,
                          child: Container(
                            width: AppConfig.of(context).appWidth(70),
                            margin: EdgeInsets.only(
                                 top: AppConfig.of(context).appWidth(3),
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
                                  "${NetworkConstants.BASE_URL}${bookBloc.bookList[index].image.url}",
                                ),
                                // image: NetworkImage(widget.imageUrl),
                                fit: BoxFit.fill,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: indexNotifier,
                    builder: (context, value, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: map<Widget>(bookBloc.bookList, (index, url) {
                        return Container(
                          width: 7.0,
                          height: 7.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: indexNotifier.value == index
                                ? Colors.redAccent
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    height: AppConfig.of(context).appWidth(1),
                  ),
                  Padding(
                      padding: Styles.getScreenPadding(context),
                      child: CustomTitleWidget(
                          context: context,
                          title: AppLocalizations.of(context)
                              .translate(Strings.TOP_CATEGORIES))),
                  Padding(
                    padding: EdgeInsets.only(
                        left: AppConfig.of(context).appWidth(7)),
                    child: featuredRestaurantListWidget(context, 1),
                  ),
                  SizedBox(
                    height: AppConfig.of(context).appWidth(4),
                  ),
                  Padding(
                      padding: Styles.getScreenPadding(context),
                      child: CustomTitleWidget(
                          context: context,
                          title: AppLocalizations.of(context)
                              .translate(Strings.LATEST_SERIES))),
                  Padding(
                    padding: EdgeInsets.only(
                        left: AppConfig.of(context).appWidth(7)),
                    child: featuredRestaurantListWidget(context, 2),
                  ),
                  SizedBox(
                    height: AppConfig.of(context).appWidth(3),
                  ),
                  SizedBox(
                    height: AppConfig.of(context).appWidth(3),
                  ),
                  Padding(
                      padding: Styles.getScreenPadding(context),
                      child: CustomTitleWidget(
                          context: context,
                          title: AppLocalizations.of(context)
                              .translate(Strings.HEADLINES))),
                ]),
              ),
              showHeadlines(context)
            ],
          ),
        ),
      );
    else
      return CustomLoader();
  }

  Widget featuredRestaurantListWidget(BuildContext context, int indexNumber) {
    if (bookBloc.bookList.isEmpty)
      return Padding(
        padding: EdgeInsets.all(AppConfig.of(context).appWidth(10)),
        child: Center(
            child: CustomTitleWidget(context: context, title: "Coming Soon")),
      );
    else {
      return Container(
        height: AppConfig.of(context).appWidth(70),
        child: ListView.separated(
          //  shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return CustomCategory(
                onPressed: () async {
                  await Navigator.of(context).pushNamed(RouteNames.MAINPAGE,
                      arguments: ScreenArguments(
                          currentPage:
                              BookDetailPage(book: bookBloc.bookList[index]),
                          message: bookBloc.bookList[index].title));
                  context.read<RecentlyPlayed>().loadData();
                },
                index: indexNumber,
                imageUrl: bookBloc.bookList[index].image.url);
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: AppConfig.of(context).appWidth(0),
            );
          },
          itemCount: bookBloc.bookList.length,
          scrollDirection: Axis.horizontal,
        ),
      );
    }
  }

  Widget showHeadlines(BuildContext context) {
    final pro = Provider.of<RecentlyPlayed>(context);

    if (context.read<RecentlyPlayed>().recentlyPlayedList.isNotEmpty)
      // return SliverList(
      //     delegate: SliverChildListDelegate([
      //   Column(
      //     children: pro.recentlyPlayedList
      //         .asMap()
      //         .map((i, part) => MapEntry(
      //             i,
      //             Container(
      //               margin: EdgeInsets.only(
      //                   left: AppConfig.of(context).appWidth(2),
      //                   right: AppConfig.of(context).appWidth(3)),
      //               child: CustomNewsWidget(
      //                 onPressed: () async {
      //                   Navigator.of(context).pushNamed(RouteNames.MAINPAGE,
      //                       arguments: ScreenArguments(
      //                           currentPage: AudioScreen(
      //                             book: bookBloc.bookList[i],
      //                             episode: part,
      //                           ),
      //                           message: part.title));
      //                 },
      //                 episode: part,
      //                 book: bookBloc.bookList[i],
      //               ),
      //             )))
      //         .values
      //         .toList(),
      //   ),
      // ]));
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          print(pro.recentlyPlayedList[0].id);
          print(bookBloc.bookList[0].id);
          Part episodeItem = pro.recentlyPlayedList[index];
          return Container(
            margin: EdgeInsets.only(
                left: AppConfig.of(context).appWidth(2),
                right: AppConfig.of(context).appWidth(3)),
            child: CustomNewsWidget(
              onPressed: () async {
                Navigator.of(context).pushNamed(RouteNames.MAINPAGE,
                    arguments: ScreenArguments(
                        currentPage: AudioScreen(
                          book: bookBloc.bookList.singleWhere(
                              (element) => element.id == episodeItem.bookId),
                          episode: episodeItem,
                        ),
                        message: episodeItem.title));
              },
              episode: episodeItem,
              book: bookBloc.bookList
                  .singleWhere((element) => element.id == episodeItem.bookId),
            ),
          );
        }, childCount: pro.recentlyPlayedList.length),
      );
    // return SliverList(
    //     delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
    //   // var news = bookBloc.bookList[index];
    //   var news = context.read<RecentlyPlayed>().recentlyPlayedList[index];
    //   print(news.id);
    //   return AnimationConfiguration.staggeredList(
    //     position: index,
    //     duration: const Duration(milliseconds: 375),
    //     child: SlideAnimation(
    //       verticalOffset: 50.0,
    //       child: FadeInAnimation(
    //         child: CustomNewsWidget(
    //           onPressed: () {
    //             if (context.read<RecentlyPlayed>().recentlyPlayedList[index].parts.length != 0)
    //             {
    //               Navigator.of(context).pushNamed(RouteNames.MAINPAGE,
    //                   arguments: ScreenArguments(
    //                       currentPage: BookDetailPage(
    //                           book: context
    //                               .read<RecentlyPlayed>()
    //                               .recentlyPlayedList[index]),
    //                       message: context
    //                           .read<RecentlyPlayed>()
    //                           .recentlyPlayedList[index]
    //                           .title));
    //             } else {
    //               Toast.show("No Episode Available", context,
    //                   duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    //             }
    //           },
    //           book: news,
    //         ),
    //       ),
    //     ),
    //   );
    // },
    //         childCount: context.read<RecentlyPlayed>().recentlyPlayedList.length));
    else
      return SliverToBoxAdapter(child: CustomException());
  }
}
