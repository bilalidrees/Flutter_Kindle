import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/AuthenticationBloc.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/bloc/ThemeBloc.dart';
import 'package:hiltonSample/src/resource/networkConstant.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTextField.dart';
import 'package:hiltonSample/src/bloc/utility/Validations.dart';
import 'package:hiltonSample/src/model/User.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/style.dart';
import 'package:hiltonSample/src/ui/widgets/CustomButton.dart';
import '../../../../AppLocalizations.dart';
import '../../../../route_generator.dart';
import 'package:hiltonSample/src/ui/widgets/CustomBackButton.dart';
import 'package:toast/toast.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  ThemeBloc themeBloc;
  bool darkThemeSelected;
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AuthenticationBloc authenticationBloc = AuthenticationBloc();

  @override
  void initState() {
    themeBloc = ThemeBloc.getInstance();
    darkThemeSelected = themeBloc.isDarkThemeSelected;
    themeBloc.darkThemeIsEnabled.listen((value) {
      setState(() {
        darkThemeSelected = value;
      });
    });
    authenticationBloc.forgotPasswordStream.listen((message) {
      Toast.show(message.toString(), context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.of(context).pop();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: forgetPassword(context),
      ),
    );
  }

  Widget forgetPassword(BuildContext context) {
    final app = AppConfig(context);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.red, Colors.red[300]])),
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
                          Container(
                            margin: EdgeInsets.only(
                              top: AppConfig.of(context).appWidth(5),
                            ),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate(Strings.FORGOT_PASSWORD),
                              style: TextStyle(
                                fontFamily: 'RobotoCondensed',
                                color: Colors.red,
                                fontSize: AppConfig.of(context).appWidth(4.3),
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: app.appWidth(3)),
                          Container(
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate(Strings.FORGOT_PASSWORD_HINT),
                              style: Theme.of(context).textTheme.headline4,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: app.appWidth(5)),
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
                                  SizedBox(height: app.appHeight(1)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: app.appWidth(5)),
                          Container(
                            margin: EdgeInsets.only(
                                left: AppConfig.of(context).appWidth(5),
                                right: AppConfig.of(context).appWidth(5),
                                bottom: AppConfig.of(context).appWidth(5)),
                            child: CustomButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  authenticationBloc.forgotPassword(
                                      email: emailController.text,
                                      url:
                                          NetworkConstants.FORGOT_PASSWORD_URL);
                                }
                              },
                              radius: 10,
                              text: AppLocalizations.of(context)
                                  .translate(Strings.RESET_LINK),
                              textColor: darkThemeSelected
                                  ? Color(0xFF353434)
                                  : Colors.white,
                              backgorundColor:
                                  AppColors.of(context).mainColor(1),
                              width: AppConfig.of(context).appWidth(84),
                              isToShowEndingIcon: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CustomBackButton(darkThemeSelected: darkThemeSelected),
//           Positioned(
// //          top: AppConfig.of(context).appHeight(50),
// //          right: AppConfig.of(context).appHeight(28),
//             child: Visibility(
//                 visible: _isVisible,
//                 child: Center(child: CircularProgressIndicator())),
//           ),
        ],
      ),
    );
  }
}
