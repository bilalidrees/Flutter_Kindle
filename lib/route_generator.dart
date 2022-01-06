import 'package:hiltonSample/src/bloc/BookBloc.dart';
import 'package:hiltonSample/src/bloc/bloc_provider.dart';
import 'package:hiltonSample/src/ui/pages/main/MainPage.dart';
import 'package:hiltonSample/src/ui/pages/book/BookDetailPage.dart';
import 'package:hiltonSample/src/ui/pages/user/Login.dart';
import 'package:hiltonSample/src/ui/pages/user/Signup.dart';
import 'package:hiltonSample/src/ui/pages/user/ForgetPassword.dart';
import 'package:hiltonSample/src/ui/pages/user/Profile.dart';
import 'src/app.dart';
import 'package:hiltonSample/src/ui/pages/main/SplashScreen.dart';
import 'package:hiltonSample/src/ui/pages/other_module/MainPageNavigator.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final ScreenArguments args = settings.arguments;
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (_) => RouteAwareWidget("/", child: SplashScreen()));
      case RouteNames.MAINPAGE:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                bloc: BookBloc(),
                child: RouteAwareWidget(
                  RouteNames.MAINPAGE,
                  child: MainPage(
                      currentPage: args.currentPage,
                      currentTitle: args.message),
                )));
      case RouteNames.NEWS_DETAILS:
        return MaterialPageRoute(
            builder: (_) => RouteAwareWidget(RouteNames.NEWS_DETAILS,
                child: BookDetailPage()));
      case RouteNames.FORGOT_PASSWORD:
        return MaterialPageRoute(
            builder: (_) => RouteAwareWidget(RouteNames.FORGOT_PASSWORD,
                child: ForgetPassword()));
      case RouteNames.PROFILE:
        return MaterialPageRoute(
            builder: (_) =>
                RouteAwareWidget(RouteNames.PROFILE, child: Profile()));
      case RouteNames.LOGIN:
        return MaterialPageRoute(
            builder: (_) => RouteAwareWidget(RouteNames.LOGIN, child: Login()));
      case RouteNames.SIGN_UP:
        return MaterialPageRoute(
            builder: (_) =>
                RouteAwareWidget(RouteNames.SIGN_UP, child: Signup()));
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

class RouteNames {
  static const String SPLASH = "/welcome";
  static const String MAINPAGE = "/MainPage";
  static const String AUDIO_PAGE = "/AUDIO_PAGE";
  static const String NEWS_DETAILS = "/NewsDetails";
  static const String SUB_CATEGORY = "/Sub_Category";
  static const String LOGIN = "/Login";
  static const String SIGN_UP = "/SignUp";
  static const String FORGOT_PASSWORD = "/Forgot_Password";
  static const String PROFILE = "/Profile";

}
