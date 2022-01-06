import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/bloc/utility/SharedPrefrence.dart';
import 'package:hiltonSample/src/bloc/utility/Validations.dart';
import 'package:hiltonSample/src/model/User.dart';
import 'package:hiltonSample/src/resource/networkConstant.dart';
import 'package:toast/toast.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/style.dart';
import 'package:hiltonSample/src/ui/widgets/CustomButton.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTextField.dart';
import 'package:hiltonSample/src/bloc/AuthenticationBloc.dart';
import '../../../../AppLocalizations.dart';
import 'package:hiltonSample/src/bloc/ThemeBloc.dart';
import '../../../../route_generator.dart';
import 'package:hiltonSample/src/ui/widgets/CustomBackButton.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String username, password;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  AuthenticationBloc authenticationBloc = AuthenticationBloc();
  bool _isVisible = false,
      isToShowLoginDialog = false,
      isPasswordHidden = true,
      isKeyBoardOpen = false;
  ThemeBloc themeBloc;
  bool darkThemeSelected;

  setVisiblity(bool visiblity) {
    setState(() {
      _isVisible = visiblity;
    });
  }

  setPasswordStatus() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

  @override
  void initState() {
    themeBloc = ThemeBloc.getInstance();
    darkThemeSelected = themeBloc.isDarkThemeSelected;
    themeBloc.darkThemeIsEnabled.listen((value) {
      setState(() {
        darkThemeSelected = value;
      });
    });
    authenticationBloc.userAuthStream.listen((user) {
      saveUser(user: user);
    }, onError: (exception) {
      Toast.show(exception.toString(), context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });

    authenticationBloc.socialLoginStream.listen((_googleSignIn) {
      authenticationBloc.userAuth(
          user: User(
              fullname: _googleSignIn.currentUser.displayName.toString(),
              email: _googleSignIn.currentUser.email.toString(),
              picture: _googleSignIn.currentUser.photoUrl),
          url: NetworkConstants.SOCIAL_LOGIN_URL);
    }, onError: (exception) {});

    authenticationBloc.facebookLoginStream.listen((userObject) {
      authenticationBloc.userAuth(
          user: userObject, url: NetworkConstants.SOCIAL_LOGIN_URL);
    }, onError: (exception) {});
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: loginWithEmailWidget(context),
      ),
    );
  }

  Widget loginWithEmailWidget(BuildContext context) {
    final app = AppConfig(context);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.red, AppColors.mainScreenColor])),
      child: Stack(
        children: <Widget>[
          Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Container(
                  margin: EdgeInsets.all(AppConfig.of(context).appWidth(5)),
                  decoration: BoxDecoration(
                    color: darkThemeSelected ? Color(0xFF353434) : Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: app.appHeight(5)),
                          Form(
                            key: _formKey,
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: AppConfig.of(context).appWidth(5),
                                  right: AppConfig.of(context).appWidth(5)),
                              child: Column(
                                children: <Widget>[
                                  CustomTextField(
                                      AppLocalizations.of(context)
                                          .translate(Strings.USERNAME),
                                      TextInputType.text,
                                      VALIDATION_TYPE.TEXT,
                                      Icons.account_circle,
                                      emailController,
                                      false,
                                      () {}),
                                  SizedBox(height: app.appHeight(2)),
                                  CustomTextField(
                                      AppLocalizations.of(context)
                                          .translate(Strings.PASSWORD),
                                      TextInputType.visiblePassword,
                                      VALIDATION_TYPE.PASSWORD,
                                      Icons.lock,
                                      passwordController,
                                      isPasswordHidden, () {
                                    setPasswordStatus();
                                  }),
                                  SizedBox(height: app.appHeight(1)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: app.appHeight(3)),
                          Container(
                            margin: EdgeInsets.only(
                                left: AppConfig.of(context).appWidth(5),
                                right: AppConfig.of(context).appWidth(5)),
                            child: CustomButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  authenticationBloc.userAuth(
                                      user: User(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      ),
                                      url: NetworkConstants.LOGIN_URL);
                                }
                              },
                              radius: 10,
                              text: AppLocalizations.of(context)
                                  .translate(Strings.LOG_IN),
                              textColor: darkThemeSelected
                                  ? Color(0xFF353434)
                                  : Colors.white,
                              backgorundColor: AppColors.mainScreenColor,
                              width: AppConfig.of(context).appWidth(84),
                              isToShowEndingIcon: false,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: AppConfig.of(context).appWidth(1),
                                right: AppConfig.of(context).appWidth(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).popAndPushNamed(
                                        RouteNames.FORGOT_PASSWORD);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate(Strings.FORGOT_PASSWORD),
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: app.appHeight(3)),
                          Container(
                            margin: EdgeInsets.only(
                                left: AppConfig.of(context).appWidth(5),
                                right: AppConfig.of(context).appWidth(5)),
                            child: CustomButton(
                              onPressed: () {
                                authenticationBloc.signInGoogle();
                              },
                              radius: 10,
                              text: AppLocalizations.of(context)
                                  .translate(Strings.SIGN_IN_GOOGLE),
                              textColor: darkThemeSelected
                                  ? Color(0xFF353434)
                                  : Colors.white,
                              backgorundColor: AppColors.google_signin,
                              width: AppConfig.of(context).appWidth(84),
                              isToShowEndingIcon: false,
                            ),
                          ),
                          SizedBox(height: app.appHeight(3)),
                          Container(
                            margin: EdgeInsets.only(
                                left: AppConfig.of(context).appWidth(5),
                                right: AppConfig.of(context).appWidth(5)),
                            child: CustomButton(
                              onPressed: () {
                               // authenticationBloc.facebookSignIn();
                              },
                              radius: 10,
                              text: AppLocalizations.of(context)
                                  .translate(Strings.SIGN_IN_FB),
                              textColor: darkThemeSelected
                                  ? Color(0xFF353434)
                                  : Colors.white,
                              backgorundColor:
                                  AppColors.of(context).facebookColor(1),
                              width: AppConfig.of(context).appWidth(84),
                              isToShowEndingIcon: false,
                            ),
                          ),
                          SizedBox(height: app.appHeight(3)),
                          Container(
                            height: app.appHeight(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate(Strings.SIGN_UP_HINT),
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                    width: AppConfig.of(context).appWidth(2)),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .popAndPushNamed(RouteNames.SIGN_UP);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate(Strings.SIGN_UP),
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CustomBackButton(darkThemeSelected: darkThemeSelected),
          Positioned(
//          top: AppConfig.of(context).appHeight(50),
//          right: AppConfig.of(context).appHeight(28),
            child: Visibility(
                visible: _isVisible,
                child: Center(child: CircularProgressIndicator())),
          ),
        ],
      ),
    );
  }

  Future<void> saveUser({User user}) async {
    await SharedPref.createInstance().setCurrentUser(user);
    Navigator.of(context).pop();
  }
}
