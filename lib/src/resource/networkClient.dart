import 'dart:async';
import 'dart:convert';
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
import 'NetworkConstant.dart';

class NetworkClientState {
  static const String URL = 'https://jsonplaceholder.typicode.com/posts';

  BuildContext _buildContext;
  static NetworkClientState networkClientState;
  String token, apiUrl;
  SessionClass sessionClass;
  Map<String, String> _headers;
  http.Client _client;
  var apiResponse;
  Dio dio = new Dio();

  NetworkClientState.createInstance() {}

  NetworkClientState(BuildContext context) {
    _buildContext = context;
  }

  static NetworkClientState getInstance({BuildContext context}) {
    if (networkClientState == null) {
      networkClientState = NetworkClientState(context);
    }
    if (context != null) {
      networkClientState._buildContext = context;
    }
    return networkClientState;
  }

  Future<void> setSessionToken() async {
    sessionClass = await SessionClass.getInstance();
    token =await sessionClass.getToken();
  }

  Future<NetworkClientState> postRequest(
      {String endpoint, String jsonBody}) async {
    try {
      final Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': token
      };
      apiResponse = await http.post(endpoint, body: jsonBody, headers: headers);
      print("response ${apiResponse.body}");
      return NetworkClientState._onSuccess(apiResponse.body, endpoint);
      // if (apiResponse.statusCode == 201 || apiResponse.statusCode == 200) {
      //   return NetworkClientState._onSuccess(apiResponse.body, endpoint);
      // } else {
      //   if (apiResponse.statusCode == 500)
      //     return NetworkClientState._onError(
      //         NetworkConstants.SERVER_ERROR, endpoint);
      //   else if (apiResponse.statusCode == 401 ||
      //       apiResponse.statusCode == 403) {
      //   } else
      //     return NetworkClientState._onError(
      //         "${apiResponse.body} ${apiResponse.statusCode}", endpoint);
      // }
    } on TimeoutException catch (_) {
      return NetworkClientState._onFailure(
          Exception("Timeout occured"), endpoint);
    } on Error catch (exception) {
      if (apiResponse.statusCode == 403) {
      } else {
        return NetworkClientState._onFailure(Exception(exception), endpoint);
      }
    } on Exception catch (exception) {
      //return NetworkClientState._onFailure(exception, endpoint);
    }
  }

  Future<NetworkClientState> postFormRequest(
      {String endpoint, String jsonBody, File file}) async {
    try {
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
      apiResponse = await dio.post(endpoint, data: formData);
      print("response ${apiResponse.body}");
      return NetworkClientState._onSuccess(apiResponse.body, endpoint);
    } on TimeoutException catch (_) {
      return NetworkClientState._onFailure(
          Exception("Timeout occured"), endpoint);
    } on Error catch (exception) {
      print("response exception ${apiResponse.body}");
      if (apiResponse.statusCode == 403) {
      } else {
        return NetworkClientState._onFailure(Exception(exception), endpoint);
      }
    } on Exception catch (exception) {
      print("response exception catch ${apiResponse.body}");
      return NetworkClientState._onFailure(exception, endpoint);
    }
  }

  Future<NetworkClientState> putRequest(
      {String endpoint, String json, bool isTest = true}) async {
    try {
      print("l$endpoint");

      print("hit url");
      apiResponse = await http.put("$endpoint", body: json, headers: {
        "Content-type": "application/json",
      });
//          .timeout(const Duration(seconds: 4));
      if (apiResponse.statusCode == 201 || apiResponse.statusCode == 200)
        return NetworkClientState._onSuccess(apiResponse.body, endpoint);
      else {
        if (apiResponse.statusCode == 500)
          return NetworkClientState._onError(
              NetworkConstants.SERVER_ERROR, endpoint);
        else if (apiResponse.statusCode == 401 ||
            apiResponse.statusCode == 403) {
        } else
          return NetworkClientState._onError(
              "${apiResponse.body} ${apiResponse.statusCode}", endpoint);
      }
    } on TimeoutException catch (_) {
      return NetworkClientState._onFailure(
          Exception("Timeout occured"), endpoint);
    } on Error catch (_) {
      if (apiResponse.statusCode == 401 || apiResponse.statusCode == 403) {
      } else {
        return NetworkClientState._onFailure(
            Exception("on error triggered"), endpoint);
      }
    } on Exception catch (exception) {
      return NetworkClientState._onFailure(exception, endpoint);
    }
  }

  Future<NetworkClientState> getRequest(String endpoint) async {
    try {
      apiResponse = await http.get("$endpoint", headers: {
        "Content-type": "application/json",
      });
      return NetworkClientState._onSuccess(apiResponse.body, endpoint);
      // if (apiResponse.statusCode == 200)
      //   return NetworkClientState._onSuccess(apiResponse.body, endpoint);
      // else {
      //   if (apiResponse.statusCode == 500)
      //     return NetworkClientState._onError(
      //         NetworkConstants.SERVER_ERROR, endpoint);
      //   else if (apiResponse.statusCode == 401 ||
      //       apiResponse.statusCode == 403) {
      //   } else
      //     return NetworkClientState._onError(
      //         "${apiResponse.body} ${apiResponse.statusCode}", endpoint);
      // }
    } on Error catch (_) {
      if (apiResponse.statusCode == 401 || apiResponse.statusCode == 403) {
      } else {
        return NetworkClientState._onFailure(
            Exception("on error triggered"), endpoint);
      }
    } on Exception catch (exception) {
      return NetworkClientState._onFailure(exception, endpoint);
    }
  }

  Future<NetworkClientState> deleteRequest(
      {String endpoint, String json, bool isTest = true}) async {
    try {
      apiResponse = await http.post("$endpoint", body: json, headers: {
        "Content-type": "application/json",
      });
      if (apiResponse.statusCode == 200)
        return NetworkClientState._onSuccess(apiResponse.body, endpoint);
      else {
        if (apiResponse.statusCode == 500)
          return NetworkClientState._onError(
              NetworkConstants.SERVER_ERROR, endpoint);
        else if (apiResponse.statusCode == 401 ||
            apiResponse.statusCode == 403) {
        } else
          return NetworkClientState._onError(
              "${apiResponse.body} ${apiResponse.statusCode}", endpoint);
      }
    } on Exception catch (exception) {
      return NetworkClientState._onFailure(exception, endpoint);
    }
  }

  factory NetworkClientState._onSuccess(String response, String apiEndpoint) =
      OnSuccessState;

  factory NetworkClientState._onError(String error, String apiEndpoint) =
      OnErrorState;

  factory NetworkClientState._onFailure(Exception throwable, String endPoint) =
      OnFailureState;
}

class OnSuccessState extends NetworkClientState {
  String response, apiEndpoint;

  OnSuccessState(this.response, this.apiEndpoint) : super.createInstance();
}

class OnErrorState extends NetworkClientState {
  String error, apiEndpoint;

  OnErrorState(this.error, this.apiEndpoint) : super.createInstance();
}

class OnFailureState extends NetworkClientState {
  Exception throwable;
  String apiEndpoint;

  OnFailureState(this.throwable, this.apiEndpoint) : super.createInstance();
}
