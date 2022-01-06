import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:hiltonSample/src/model/Book.dart';
import 'package:flutter/services.dart';

class AppUtility {
  static getSources(String sourceList) {
    var array = sourceList.split('.');
    var retMap = {};
    if (array[0] != null) retMap['source'] = '"${array[0]}"';
    if (array[1] != null) retMap['category'] = '"${array[1]}"';
    if (array[2] != null) retMap['type'] = '"${array[2]}"';
    if (array[3] != null) retMap['sub_type'] = '"${array[3]}"';
    return retMap;
  }

  // static Future<List<Book>> getPublishTime(
  //     List<Book> newsFeedList) async {
  //   List<Book> newNewsFeed = List();
  //
  //   newsFeedList.forEach((news) {
  //     var split = news.pubdate.split("T");
  //     var time = "${split[0]} ${split[1]}";
  //     var tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(time, false);
  //     var currentDate = DateTime.now();
  //
  //     var seconds = (currentDate.millisecondsSinceEpoch -
  //             tempDate.millisecondsSinceEpoch) /
  //         1000;
  //     String intervalType;
  //     num mathValue;
  //     mathValue = seconds / 31536000;
  //     var interval = mathValue.round();
  //     if (interval >= 1) {
  //       intervalType = 'year';
  //     } else {
  //       mathValue = seconds / 2592000;
  //       interval = mathValue.round();
  //       if (interval >= 1) {
  //         intervalType = 'month';
  //       } else {
  //         mathValue = seconds / 86400;
  //         interval = mathValue.round();
  //         if (interval >= 1) {
  //           intervalType = 'day';
  //         } else {
  //           mathValue = seconds / 3600;
  //           interval = mathValue.round();
  //           if (interval >= 1) {
  //             intervalType = 'hour';
  //           } else {
  //             mathValue = seconds / 60;
  //             interval = mathValue.round();
  //             if (interval >= 1) {
  //               intervalType = 'minute';
  //             } else {
  //               interval = seconds as int;
  //               intervalType = 'second';
  //             }
  //           }
  //         }
  //       }
  //     }
  //     //    adding a plural to text, optional
  //     if (interval > 1 || interval == 0) {
  //       intervalType += 's';
  //     }
  //     if (interval is String || (interval <= 0)) {
  //       news.articlePublishedTime = "";
  //       newNewsFeed.add(news);
  //     } else {
  //       news.articlePublishedTime = "$interval $intervalType ago";
  //       newNewsFeed.add(news);
  //     }
  //   });
  //
  //   return newNewsFeed;
  // }

  static Future<List<dynamic>> getRootBundle() async {
    final String response = await rootBundle.loadString("i18n/sourceList.json");
    final data = await json.decode(response);
    List<dynamic> responseData = data as List<dynamic>;
    return responseData;
  }
}
