import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:hiltonSample/src/bloc/utility/SessionClass.dart';

import 'package:hiltonSample/src/model/ServerResponse.dart';
import 'package:hiltonSample/src/model/User.dart';
import 'package:hiltonSample/src/resource/networkConstant.dart';
import 'package:hiltonSample/src/resource/network_provider/UserProvider.dart';
import 'package:http/http.dart' as http;

import 'package:hiltonSample/src/resource/NetworkClient.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hiltonSample/route_generator.dart';
import 'package:hiltonSample/src/app.dart';
import 'package:hiltonSample/src/bloc/utility/SessionClass.dart';
import 'package:hiltonSample/src/bloc/utility/SharedPrefrence.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class UserRepository {
  final userProvider = UserProvider();

  Future<User> userAuth({User user, String url}) async {
    Map<String, dynamic> result = user.toJson();
    String jsonUser = jsonEncode(result);
    NetworkClientState response =
        await userProvider.postData(endpoint: url, body: jsonUser);
    if (response is OnSuccessState) {
      OnSuccessState onSuccessState = response;
      final parsed = json.decode(onSuccessState.response);
      ServerResponse serverResponse = ServerResponse.fromJson(parsed);
      if (serverResponse.success) {
        if (url == NetworkConstants.SOCIAL_LOGIN_URL ||
            url == NetworkConstants.LOGIN_URL ||
            url == NetworkConstants.REGISTER_URL) {
          var sessionClass = await SessionClass.getInstance();
          await sessionClass.setToken(serverResponse.token);
        }
        Map<String, dynamic> responseData =
            serverResponse.data as Map<String, dynamic>;
        return User.fromJson(responseData);
      } else {
        throw serverResponse.apiMessage;
      }
    } else if (response is OnFailureState) {
      OnFailureState onErrorState = response;
      throw onErrorState.throwable;
    }
  }

  Future<User> uploadImageToServer({File file, String url}) async {
    // NetworkClientState response =
    //     await userProvider.postFormRequest(endpoint: url, file: image);
    // if (response is OnSuccessState) {
    //   OnSuccessState onSuccessState = response;
    //   final parsed = json.decode(onSuccessState.response);
    //   ServerResponse serverResponse = ServerResponse.fromJson(parsed);
    //   if (serverResponse.success) {
    //     var sessionClass = await SessionClass.getInstance();
    //     sessionClass.setToken(serverResponse.token);
    //     Map<String, dynamic> responseData =
    //         serverResponse.data as Map<String, dynamic>;
    //     return User.fromJson(responseData);
    //   } else {
    //     throw serverResponse.apiMessage;
    //   }
    // } else if (response is OnFailureState) {
    //   OnFailureState onErrorState = response;
    //   throw onErrorState.throwable;
    // }
    Dio dio = new Dio();
    SessionClass sessionClass;
    sessionClass = await SessionClass.getInstance();
    var token = await sessionClass.getToken();

    String fileName = file.path.split('/').last;
    var ext = fileName.split(".");
    FormData formData = FormData.fromMap({
      "photo": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: MediaType('image', ext[1]),
      ),
    });
    dio.options.headers["Authorization"] = token;
    print(" topken : $token");
    final apiResponse = await dio.post(url, data: formData);
    print(apiResponse.data);
    Map<String, dynamic> responseData =
        apiResponse.data as Map<String, dynamic>;
    ServerResponse serverResponse = ServerResponse.fromJson(responseData);
    if (serverResponse.success) {
      Map<String, dynamic> responseData =
          serverResponse.data as Map<String, dynamic>;
      return User.fromJson(responseData);
    } else {
      throw serverResponse.apiMessage;
    }
  }

  Future<String> forgotPassword({String email, String url}) async {
    Map<String, dynamic> result = {"email": email};
    String jsonUser = jsonEncode(result);
    NetworkClientState response =
        await userProvider.postData(endpoint: url, body: jsonUser);
    if (response is OnSuccessState) {
      OnSuccessState onSuccessState = response;
      final parsed = json.decode(onSuccessState.response);
      ServerResponse serverResponse = ServerResponse.fromJson(parsed);
      if (serverResponse.success) {
        return serverResponse.apiMessage;
      } else {
        throw serverResponse.apiMessage;
      }
    } else if (response is OnFailureState) {
      OnFailureState onErrorState = response;
      throw onErrorState.throwable;
    }
    return null;
  }
}
