import 'dart:convert';

import 'package:hiltonSample/src/model/User.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hiltonSample/src/bloc/utility/SharedPrefrence.dart';

class SharedPref {
  SharedPref();

  SharedPref.createInstance();

  Future<void> setCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    if (user != null) {
      Map<String, dynamic> result = user.toJson();
      String jsonUser = jsonEncode(result);
      prefs.setString(Strings.CURRENT_USER, jsonUser);
    } else {
      prefs.setString(Strings.CURRENT_USER, null);
    }
  }

  Future<User> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    String result = prefs.getString(Strings.CURRENT_USER);
    if (result != null) {
      Map<String, dynamic> map = jsonDecode(result);
      return User.fromJson(map);
    } else
      return null;
  }

  Future<bool> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Strings.TOKEN, token);
    return true;
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Strings.TOKEN);
  }
}
