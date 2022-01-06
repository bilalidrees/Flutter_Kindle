import 'package:hiltonSample/src/bloc/utility/SharedPrefrence.dart';

class SessionClass {
  static SessionClass sessionClass;
  static String baseUrl;
  static String _token;
  static String fcmToken;
  static bool isOrderPlaced;
  bool isCartItemAddedForPreviousRestaurant = false;

  static Future<SessionClass> getInstance() async {
    if (sessionClass == null) {
      sessionClass = new SessionClass();
    }
    return sessionClass;
  }

  void setBaseUrl(String url) {
    baseUrl = url;
  }

  String getBaseUrl() {
    return baseUrl;
  }

  void setFcmToken(String token) {
    fcmToken = token;
  }

  String getFcmToken() {
    return fcmToken;
  }

  void setIsOrderPlaced(bool order) {
    isOrderPlaced = order;
  }

  bool getIsOrderPlaced() {
    return isOrderPlaced;
  }

  Future<bool> setToken(String token) async {
    _token = token;
    await SharedPref.createInstance().setToken(token);
    return true;
  }

  Future<String> getToken() async {
    _token = await SharedPref.createInstance().getToken();
    return _token;
  }
}
