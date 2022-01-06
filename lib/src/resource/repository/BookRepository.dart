import 'dart:async';
import 'dart:convert';
import 'package:hiltonSample/src/model/Book.dart';
import 'package:http/http.dart' as http;

import 'package:hiltonSample/src/resource/NetworkClient.dart';
import 'package:hiltonSample/src/resource/networkConstant.dart';
import 'package:hiltonSample/src/resource/network_provider/BookProvider.dart';
import 'package:hiltonSample/src/bloc/utility/AppUtility.dart';

class BookRepository {
  final newsProvider = BookProvider();

  Future<List<Book>> getNewsCategories() async {
    List<Book> book = [];
    NetworkClientState response =
        await newsProvider.fetchData(NetworkConstants.BOOKS_URL);
    if (response is OnSuccessState) {
      OnSuccessState onSuccessState = response;
      Iterable l = json.decode(onSuccessState.response);
      List<Book> posts =
          List<Book>.from(l.map((model) => Book.fromJson(model)));
      return posts;
    } else if (response is OnFailureState) {
      OnFailureState onErrorState = response;
      throw onErrorState.throwable;
    }
    return book;
  }
}
