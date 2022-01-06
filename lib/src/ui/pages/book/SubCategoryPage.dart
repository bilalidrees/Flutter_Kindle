import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hiltonSample/src/ui/pages/other_module/MainPageNavigator.dart';
import 'package:hiltonSample/src/ui/widgets/CustomException.dart';
import 'package:hiltonSample/src/bloc/utility/AppUtility.dart';
import 'package:hiltonSample/AppLocalizations.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/style.dart';
import 'package:hiltonSample/src/ui/widgets/CustomLoader.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTitleWidget.dart';
import 'package:hiltonSample/src/ui/widgets/CustomSelectionWidget.dart';
import 'package:hiltonSample/src/ui/widgets/CustomShimmerView.dart';
import 'package:hiltonSample/src/ui/widgets/CustomNewsWidget.dart';
import '../../../../route_generator.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hiltonSample/src/bloc/ThemeBloc.dart';

import 'package:hiltonSample/src/bloc/BookBloc.dart';

class SubCategoryPage extends StatefulWidget {
  SubCategoryPage();

  @override
  _SubCategoryPageState createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  int selectedValue = 0;
  bool isDataFetching = true;
  ThemeBloc themeBloc;
  bool darkThemeSelected;
  BookBloc newsBloc;
  bool isLoading = true;
  String currentSelectedSubCategorySource, currentSelectedSubCategorySourceLogo;

  @override
  void initState() {
    themeBloc = ThemeBloc.getInstance();
    newsBloc = BookBloc();
    darkThemeSelected = themeBloc.isDarkThemeSelected;
    themeBloc.darkThemeIsEnabled.listen((value) {
      setState(() {
        darkThemeSelected = value;
      });
    });
    // Future.delayed(Duration.zero, () {
    //   newsBloc
    //       .saveCategoriesImages(widget.category, context)
    //       .then((updatedCategory) {
    //     widget.category = updatedCategory;
    //     currentSelectedSubCategorySource = widget.category.item.first.name;
    //     newsBloc.setFeedState(widget.category.item.first.name);
    //     newsBloc.newsFeedStream.listen((newsFeedList) {
    //       AppUtility.getPublishTime(newsFeedList).then((list) {
    //         newsBloc.newsFeedList = list;
    //         newsBloc
    //             .getSourceImages(currentSelectedSubCategorySource, context)
    //             .then((value) {
    //           currentSelectedSubCategorySourceLogo = value;
    //           setState(() {
    //             isDataFetching = false;
    //             isLoading = false;
    //           });
    //         });
    //       });
    //     });
    //   });
    // });
    super.initState();
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
                  SizedBox(
                    height: AppConfig.of(context).appWidth(1.8),
                  ),
                  Padding(
                      padding: Styles.getScreenPadding(context),
                      child: CustomTitleWidget(
                          context: context,
                          title:
                              "${"widget.category.category"} ${AppLocalizations.of(context).translate(Strings.TOP_CATEGORIES)}")),
                  SizedBox(
                    height: AppConfig.of(context).appWidth(5),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: AppConfig.of(context).appWidth(7.4)),
                    //child: categoriesWidget(context),
                    child: Container(),
                  ),
                  SizedBox(
                    height: AppConfig.of(context).appWidth(1),
                  ),
                ]),
              ),
              // isDataFetching
              //     ? SliverList(
              //         delegate: SliverChildListDelegate([
              //           SizedBox(height: AppConfig.of(context).appWidth(5)),
              //           Container(
              //               height: AppConfig.of(context).appWidth(120),
              //               child: Center(
              //                   child: CustomShimmerView(
              //                       darkThemeSelected: darkThemeSelected)))
              //         ]),
              //       )
              //     : showHeadlines()
            ],
          ),
        ),
      );
    else
      return CustomLoader();
  }

// Widget showHeadlines() {
//   if (newsBloc.newsFeedList.isNotEmpty)
//     return SliverList(
//         delegate:
//             SliverChildBuilderDelegate((BuildContext context, int index) {
//       var newsFeed = newsBloc.newsFeedList[index];
//       return AnimationConfiguration.staggeredList(
//         position: index,
//         duration: const Duration(milliseconds: 200),
//         child: SlideAnimation(
//           verticalOffset: 50.0,
//           child: FadeInAnimation(
//             child: CustomNewsWidget(
//               onPressed: () {
//                 Navigator.of(context).pushNamed(RouteNames.NEWS_DETAILS,
//                     arguments: ScreenArguments(
//                         data: newsFeed,
//                         message: currentSelectedSubCategorySourceLogo));
//               },
//               newsFeed: newsFeed,
//               logoUrl: currentSelectedSubCategorySourceLogo,
//             ),
//           ),
//         ),
//       );
//     }, childCount: newsBloc.newsFeedList.length));
//   else
//     return SliverToBoxAdapter(child: CustomException());
// }

// Container categoriesWidget(BuildContext context) {
//   return Container(
//     height: AppConfig.of(context).appWidth(39),
//     child: ListView.separated(
//       itemBuilder: (BuildContext context, int index) {
//         SubCategory subCategory = widget.category.item[index];
//         return GestureDetector(
//           onTap: () {
//             currentSelectedSubCategorySource = subCategory.name;
//             newsBloc.setFeedState(subCategory.name);
//             setState(() {
//               selectedValue = index;
//               isDataFetching = true;
//             });
//           },
//           child: CustomSelectionWidget(
//               subCategory: subCategory,
//               value: index,
//               selectedValue: selectedValue),
//         );
//       },
//       separatorBuilder: (BuildContext context, int index) {
//         return SizedBox(
//           width: AppConfig.of(context).appWidth(2.66),
//         );
//       },
//       itemCount: widget.category.item.length,
//       scrollDirection: Axis.horizontal,
//     ),
//   );
// }
}
