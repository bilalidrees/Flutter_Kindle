import 'dart:async';
import 'package:hiltonSample/src/resource/NetworkClient.dart';
import 'package:http/http.dart' show Client;

class BookProvider {
  Client client = Client();

  Future<NetworkClientState> fetchData(String endpoint) async {
    NetworkClientState networkClientState = NetworkClientState.getInstance();
    final response = networkClientState.getRequest(endpoint);
    return response;
  }

  Future<NetworkClientState> postData({String endpoint, String body}) async {
    NetworkClientState networkClientState = NetworkClientState.getInstance();
    final response =
        networkClientState.postRequest(endpoint: endpoint, jsonBody: body);
    return response;
  }
}
