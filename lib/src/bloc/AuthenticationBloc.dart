import 'dart:convert';
import 'dart:io';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hiltonSample/src/model/User.dart';
import 'package:hiltonSample/src/resource/repository/UserRepository.dart';
import 'package:rxdart/subjects.dart';
import 'package:hiltonSample/src/bloc/utility/SharedPrefrence.dart';
import 'bloc_provider.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class AuthenticationBloc implements BlocBase {
  static AuthenticationBloc _authenticationBloc;
  final userRepository = UserRepository();
  GoogleSignIn _googleSignIn;
  //final facebookLogin = FacebookLogin();
  final loginDrawerStreamController = PublishSubject<void>();

  Stream<void> get loginDrawerStream => loginDrawerStreamController.stream;

  final socialLoginStreamController = PublishSubject<GoogleSignIn>();

  Stream<GoogleSignIn> get socialLoginStream =>
      socialLoginStreamController.stream;
  final facebookLoginStreamController = PublishSubject<User>();

  Stream<User> get facebookLoginStream => facebookLoginStreamController.stream;

  final imageStreamController = BehaviorSubject<User>();

  Stream<User> get imageStream => imageStreamController.stream;

  final userAuthStreamController = BehaviorSubject<User>();

  Stream<User> get userAuthStream => userAuthStreamController.stream;

  final forgotPasswordStreamController = BehaviorSubject<String>();

  Stream<String> get forgotPasswordStream =>
      forgotPasswordStreamController.stream;

  static AuthenticationBloc getInstance() {
    if (_authenticationBloc == null) {
      _authenticationBloc = AuthenticationBloc();
    }
    return _authenticationBloc;
  }

  void uploadImageToServer({File image, String url}) async {
    await userRepository.uploadImageToServer(file: image, url: url).then(
        (model) {
      imageStreamController.sink.add(model);
    }, onError: (exception) {
      imageStreamController.sink.addError(exception);
    });
  }

  void userAuth({User user, String url}) async {
    await userRepository.userAuth(user: user, url: url).then((model) {
      userAuthStreamController.sink.add(model);
    }, onError: (exception) {
      userAuthStreamController.sink.addError(exception);
    });
  }

  void forgotPassword({String email, String url}) async {
    await userRepository.forgotPassword(email: email, url: url).then((model) {
      forgotPasswordStreamController.sink.add(model);
    }, onError: (exception) {
      forgotPasswordStreamController.sink.addError(exception);
    });
  }

  Future<void> signInGoogle() async {
    _googleSignIn = GoogleSignIn(scopes: ['email']);
    try {
      await _googleSignIn.signIn();
      socialLoginStreamController.sink.add(_googleSignIn);
    } catch (error) {
      print(error);
      socialLoginStreamController.sink.addError(error);
    }
  }

  // void facebookSignIn() async {
  //   facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
  //   final result = await facebookLogin.logIn(['email']);
  //   switch (result.status) {
  //     case FacebookLoginStatus.loggedIn:
  //       final token = result.accessToken.token;
  //       final graphResponse = await http.get(
  //           'https://graph.facebook.com/v2.12/me?fields=id,name,picture.width(800).height(800),first_name,last_name,email&access_token=${token}');
  //       final profile = JSON.jsonDecode(graphResponse.body);
  //       print(profile);
  //       facebookLoginStreamController.sink.add(User(
  //         email: profile["email"],
  //         fullname: profile["name"],
  //         picture: profile["picture"],
  //       ));
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       print('canceled');
  //       facebookLoginStreamController.sink.addError("");
  //       break;
  //     case FacebookLoginStatus.error:
  //       print('error');
  //       facebookLoginStreamController.sink.addError("");
  //       break;
  //   }
  // }

  Future<void> socialSignOut() async {
    _googleSignIn = GoogleSignIn(scopes: ['email']);
    logout();
    // facebookLogin.isLoggedIn.then((value) async {
    //   if (value) {
    //     await facebookLogin.logOut();
    //     logout();
    //   } else {
    //     logout();
    //   }
    // });
  }

  void logout() {
    _googleSignIn.isSignedIn().then((value) async {
      if (value) {
        _googleSignIn.signOut();
        SharedPref.createInstance().setToken(null);
        await SharedPref.createInstance().setCurrentUser(null);
      } else {
        SharedPref.createInstance().setToken(null);
        await SharedPref.createInstance().setCurrentUser(null);
      }
    });
  }

  @override
  void dispose() {
    socialLoginStreamController.close();
    loginDrawerStreamController.close();
    facebookLoginStreamController.close();
    userAuthStreamController.close();
    forgotPasswordStreamController.close();
    imageStreamController.close();
  }
}
