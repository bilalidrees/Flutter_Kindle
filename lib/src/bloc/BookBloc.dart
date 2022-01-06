import 'package:hiltonSample/AppLocalizations.dart';
import 'package:hiltonSample/src/model/Book.dart';

import 'bloc_provider.dart';
import 'dart:async';
import 'package:hiltonSample/src/resource/repository/BookRepository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hiltonSample/src/bloc/utility/AppUtility.dart';

class BookBloc implements BlocBase {
  BookBloc();

  final newsRepository = BookRepository();
  List<Book> bookList, _engBookList, _urBookList;

  final bookStreamController = BehaviorSubject<List<Book>>();

  Stream<List<Book>> get bookStream => bookStreamController.stream;

  get englishList => _engBookList;

  get urduList => _urBookList;

  void getBooksDetails() async {
    await newsRepository.getNewsCategories().then((model) {
      bookList = model;
      _engBookList = bookList.where((element) {
        return element.lang == "en";
      }).toList();
      _urBookList = bookList.where((element) {
        return element.lang == "ur";
      }).toList();
      bookStreamController.sink.add(model);
    }, onError: (exception) {
      bookStreamController.sink.addError(exception);
    });
  }

  void dispose() {
    bookStreamController.close();
    // TODO: implement dispose
  }
}
