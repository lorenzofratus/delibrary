import 'package:delibrary/src/controller/book-services.dart';
import 'package:delibrary/src/controller/services.dart';
import 'package:delibrary/src/model/action.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/wish-list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class WishServices extends Services {
  static WishServices _singleton = WishServices._internal();
  BookList _bookList;

  BookList get bookList => _bookList;

  factory WishServices() {
    return _singleton;
  }

  WishServices._internal()
      : super(BaseOptions(
          // baseUrl: "https://delibrary.herokuapp.com/v1/users/",
          baseUrl: "http://localhost:8080/v1/users/",
          connectTimeout: 20000,
          receiveTimeout: 20000,
        ));

  Future<void> init(String username) async {
    print("[Wishes services] Getting wishes from Delibrary...");
    _bookList = await _getBooks("$username/wishes");
  }

  Future<BookList> _getBooks(String path) async {
    Response response;
    try {
      response = await dio.get(path);
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        throw Exception(
            "Delibrary server responded with ${e.response.statusCode}");
      } else {
        print(e.request);
        print(e.message);
        throw Exception(
            "Error while setting up or sending the request to Delibrary");
      }
    }
    return _getBooksFromWishes(WishList.fromJson(response.data));
  }

  Future<BookList> _getBooksFromWishes(WishList wishList) async {
    print("[Wishes services] Getting info for each book from Google Books...");
    List<Book> bookList = [];
    BookServices bookServices = BookServices();

    await Future.forEach(wishList.wishes, (wish) async {
      Book book = await bookServices.getById(wish.bookId);
      bookList.add(Book(id: book.id, info: book.info, wish: wish));
    });

    return BookList(totalItems: bookList.length, items: bookList);
  }

  DelibraryAction removeWish(Book book) {
    return DelibraryAction(
      text: "Rimuovi dalla lista dei desideri",
      execute: (BuildContext context) async {
        // Remove wish from server.
        Response response;
        try {
          response = await dio
              .delete("${book.wish.ownerUsername}/wishes/${book.wish.id}");
        } on DioError catch (e) {
          if (e.response != null) {
            print(e.response.data);
            print(e.response.headers);
            print(e.response.request);
            throw Exception(
                "Delibrary server responded with ${e.response.statusCode}");
          } else {
            print(e.request);
            print(e.message);
            throw Exception(
                "Error while setting up or sending the request to Delibrary");
          }
        }

        if (response.statusCode == 201) {
          // Remove wish from local copy.
          _bookList.remove(book);
        } else
          throw Exception(
              "It was not possible to delete the wish from the server.");
      },
    );
  }

  DelibraryAction addWish(Book book) {
    return DelibraryAction(
      text: "Aggiungi alla lista dei desideri",
      execute: (BuildContext context) async {
        // Remove wish from server.
        Response response;
        // Envelope<User> user = await UserServices().validateUser();
        // String username = user.payload.username;
        // TODO: RETRIEVE USERNAME (from session);
        String username = "";
        try {
          // TODO fill the body in o4rder to make a valid POST request.
          response = await dio.post("$username/wishes/new", data: {});
        } on DioError catch (e) {
          if (e.response != null) {
            print(e.response.data);
            print(e.response.headers);
            print(e.response.request);
            throw Exception(
                "Delibrary server responded with ${e.response.statusCode}");
          } else {
            print(e.request);
            print(e.message);
            throw Exception(
                "Error while setting up or sending the request to Delibrary");
          }
        }

        if (response.statusCode == 201) {
          _bookList.add(book);
        } else
          throw Exception("It was not possible to add the wish to the server.");
      },
    );
  }

  DelibraryAction moveWishToLibrary(Book book) {
    return DelibraryAction(
        text: "Sposta nella wishlist",
        execute: (BuildContext context) {/* TODO */});
  }
}
