import 'package:hiltonSample/src/bloc/AuthenticationBloc.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/bloc/utility/Validations.dart';
import 'package:hiltonSample/src/resource/networkConstant.dart';
import 'package:hiltonSample/src/ui/ui_constants/ImageAssetsResolver.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/style.dart';
import 'package:hiltonSample/src/ui/widgets/CustomButton.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/ui/ui_constants/ImageAssetsResolver.dart';
import 'package:hiltonSample/src/ui/widgets/CustomBackButton.dart';
import 'package:toast/toast.dart';
import '../../../../AppLocalizations.dart';

import '../../../../route_generator.dart';
import 'package:hiltonSample/src/bloc/utility/SharedPrefrence.dart';
import 'package:hiltonSample/src/model/User.dart';
import 'package:hiltonSample/src/bloc/ThemeBloc.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email = "", username = "", password = "", confirmPassword = "";
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  AuthenticationBloc authenticationBloc = AuthenticationBloc();
  bool _isVisible = false,
      isPasswordHidden = true,
      isConfirmPasswordHidden = true;
  ThemeBloc themeBloc;
  bool darkThemeSelected;

  setVisiblity(bool visiblity) {
    setState(() {
      _isVisible = visiblity;
    });
  }

  setPasswordStatus(bool isPassword) {
    setState(() {
      if (isPassword)
        isPasswordHidden = !isPasswordHidden;
      else
        isConfirmPasswordHidden = !isConfirmPasswordHidden;
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
    authenticationBloc.userAuthStream.listen((user) async {
      await SharedPref.createInstance().setCurrentUser(user);
      Navigator.of(context).pop();
    }, onError: (exception) {
      Toast.show(exception, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: signUpWidget(context),
      ),
    );
  }

  Widget signUpWidget(BuildContext context) {
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
                  height: AppConfig.of(context).appWidth(100),
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
                          SizedBox(height: app.appHeight(3)),
                          Form(
                            key: _formKey,
                            child: Container(
                              margin: const EdgeInsets.only(
                                  right: 20.0, left: 20.0),
                              child: Column(
                                children: <Widget>[
                                  CustomTextField(
                                      AppLocalizations.of(context)
                                          .translate(Strings.EMAIL_ADDRESS),
                                      TextInputType.emailAddress,
                                      VALIDATION_TYPE.EMAIL,
                                      Icons.account_circle,
                                      emailController,
                                      false,
                                      () {}),
                                  SizedBox(height: app.appHeight(1)),
                                  CustomTextField(
                                      AppLocalizations.of(context)
                                          .translate(Strings.PASSWORD),
                                      TextInputType.visiblePassword,
                                      VALIDATION_TYPE.PASSWORD,
                                      Icons.lock,
                                      passwordController,
                                      isPasswordHidden, () {
                                    setPasswordStatus(true);
                                  }),
                                  SizedBox(height: app.appHeight(1)),
                                  CustomTextField(
                                      AppLocalizations.of(context)
                                          .translate(Strings.CONFIRM_PASSWORD),
                                      TextInputType.visiblePassword,
                                      VALIDATION_TYPE.PASSWORD,
                                      Icons.lock,
                                      confirmPasswordController,
                                      isConfirmPasswordHidden, () {
                                    setPasswordStatus(false);
                                  }),
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
                                  if (passwordController.text ==
                                      confirmPasswordController.text) {
                                    authenticationBloc.userAuth(
                                        user: User(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        ),
                                        url: NetworkConstants.REGISTER_URL);
                                  } else {}
                                }
                              },
                              radius: 10,
                              text: AppLocalizations.of(context)
                                  .translate(Strings.SIGN_UP),
                              textColor: darkThemeSelected
                                  ? Color(0xFF353434)
                                  : Colors.white,
                              backgorundColor: AppColors.mainScreenColor,
                              width: AppConfig.of(context).appWidth(84),
                              isToShowEndingIcon: false,
                            ),
                          ),
                          SizedBox(height: app.appHeight(2)),
                          GestureDetector(
                            onTap: () async {
                              Navigator.of(context)
                                  .popAndPushNamed(RouteNames.LOGIN);
                            },
                            child: RichText(
                              text: TextSpan(
                                  text: AppLocalizations.of(context)
                                      .translate(Strings.LOGIN_HINT),
                                  style: Theme.of(context).textTheme.headline4,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)
                                            .translate(
                                                Strings.LOGIN_HINT_EXPAND),
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: AppConfig.of(context)
                                              .appWidth(4.3),
                                          color: AppColors.mainScreenColor,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ]),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: app.appHeight(4)),
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
}
