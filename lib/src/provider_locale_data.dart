import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hiltonSample/src/model/Image.dart';
import 'package:hiltonSample/src/model/Part.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'model/Book.dart';
class RecentlyPlayed with ChangeNotifier{
  static const key = 'recent';
  final SharedPreferences _sharedPreferences;

  RecentlyPlayed(this._sharedPreferences) {
    loadData();
  }

  List<Part> _recentlyPlayedList = [];

  List<Part> get recentlyPlayedList => _recentlyPlayedList;

  loadData()  {
    List<String> decode =  _sharedPreferences.getStringList(key)??[];
    _recentlyPlayedList =  decode.map((e)=>Part.fromJson(jsonDecode(e))).toList();
    notifyListeners();
  }

  Future<void> saveData()async {
    print(_recentlyPlayedList);
    List<String> encoded =
        _recentlyPlayedList.map((obj) => jsonEncode(obj.toJson())).toList();
    print('save data $encoded');
   await _sharedPreferences.setStringList(key, encoded);
    loadData();
  }
}

class Recent{

}
