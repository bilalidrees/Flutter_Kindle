import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:hiltonSample/src/ui/pages/book/HomePage.dart';
import 'package:hiltonSample/src/ui/pages/other_module/MainPageNavigator.dart';
import 'package:hiltonSample/AppLocalizations.dart';
import '../../../../route_generator.dart';
import '../../../bloc/utility/AppConfig.dart';
import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/ThemeBloc.dart';
import 'package:hiltonSample/src/ui/ui_constants/ImageAssetsResolver.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 5)).then((value) {
      navigateToMainScreen();
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed :
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Image.asset(
          ImageAssetsResolver.ITGN_IMAGE,
          height: AppConfig.of(context).appHeight(100),
          width: AppConfig.of(context).appHeight(100),
          fit: BoxFit.cover,
        )),
      ),
    );
  }

  void navigateToMainScreen() {
    Navigator.of(context).pushReplacementNamed(RouteNames.MAINPAGE,
        arguments: ScreenArguments(
            currentPage: HomePage(),
            message:
                AppLocalizations.of(context).translate(Strings.MAIN_PAGE)));
  }
}
