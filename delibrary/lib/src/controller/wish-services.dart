import 'package:delibrary/src/controller/book-services.dart';
import 'package:delibrary/src/controller/services.dart';
import 'package:delibrary/src/model/action.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/property.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:delibrary/src/model/wish-list.dart';
import 'package:delibrary/src/model/wish.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishServices extends Services {
  WishServices()
      : super(BaseOptions(
          // baseUrl: "https://delibrary.herokuapp.com/v1/users/",
          baseUrl: "http://10.9.0.5:8080/v1/",
          // baseUrl: "http://localhost:8080/v1/",
          connectTimeout: 20000,
          receiveTimeout: 20000,
        ));

  Future<BookList> _getBooksFromWishes(List<Wish> wishList) async {
    print("[Wishes services] Getting info for each book from Google Books...");
    List<Book> bookList = [];
    BookServices bookServices = BookServices();

    await Future.forEach(wishList, (wish) async {
      Book book = await bookServices.getById(wish.bookId);
      if (book != null)
        bookList.add(Book(id: book.id, info: book.info, wish: wish));
    });

    return BookList(totalItems: bookList.length, items: bookList);
  }

  DelibraryAction removeWish(Book book) {
    return DelibraryAction(
      text: "Rimuovi dalla wishlist",
      execute: (BuildContext context) async {
        Session session = context.read<Session>();
        String username = session.user.username;

        try {
          await dio.delete("users/$username/wishes/${book.wish.id}");
        } on DioError catch (e) {
          if (e.response != null) {
            if (e.response.statusCode == 404)
              return showSnackBar(context, ErrorMessage.userNotFound);
            if (e.response.statusCode == 500)
              return showSnackBar(context, ErrorMessage.serverError);
            // Otherwise, unexpected error, print and raise exception
            errorOnResponse(e);
          } else {
            // Generic error before the request is sent, print
            errorOnRequest(e, false);
            return showSnackBar(context, ErrorMessage.checkConnection);
          }
        }

        // Wish removed successfully, update session
        session.wishes.remove(book);
        showSnackBar(context, ConfirmMessage.wishRemoved);
        pop(context);
      },
    );
  }

  DelibraryAction addWish(Book book) {
    return DelibraryAction(
      text: "Aggiungi alla wishlist",
      execute: (BuildContext context) async {
        Session session = context.read<Session>();
        String username = session.user.username;

        try {
          await dio
              .post("users/$username/wishes/new", data: {"bookId": book.id});
        } on DioError catch (e) {
          if (e.response != null) {
            if (e.response.statusCode == 404)
              return showSnackBar(context, ErrorMessage.userNotFound);
            if (e.response.statusCode == 406)
              return showSnackBar(context, ErrorMessage.alreadyInProperties);
            if (e.response.statusCode == 409)
              return showSnackBar(context, ErrorMessage.alreadyInWishes);
            if (e.response.statusCode == 500)
              return showSnackBar(context, ErrorMessage.serverError);
            // Otherwise, unexpected error, print and raise exception
            errorOnResponse(e);
          } else {
            // Generic error before the request is sent, print
            errorOnRequest(e, false);
            return showSnackBar(context, ErrorMessage.checkConnection);
          }
        }

        // Wish added successfully, update session
        session.wishes.add(book);
        showSnackBar(context, ConfirmMessage.wishAdded);
        pop(context);
      },
    );
  }

  DelibraryAction moveWishToLibrary(Book book) {
    return DelibraryAction(
        text: "Sposta nella libreria",
        execute: (BuildContext context) async {
          Position position = await showPositionModal(context);
          if (position == null) return;

          Session session = context.read<Session>();
          String username = session.user.username;

          try {
            await dio.delete("users/$username/wishes/${book.wish.id}");
          } on DioError catch (e) {
            if (e.response != null) {
              if (e.response.statusCode == 404)
                return showSnackBar(context, ErrorMessage.userNotFound);
              if (e.response.statusCode == 500)
                return showSnackBar(context, ErrorMessage.serverError);
              // Otherwise, unexpected error, print and raise exception
              errorOnResponse(e);
            } else {
              // Generic error before the request is sent, print
              errorOnRequest(e, false);
              return showSnackBar(context, ErrorMessage.checkConnection);
            }
          }

          try {
            await dio.post("users/$username/properties/new", data: {
              "book": {"bookId": book.id},
              "position": position.toJson(),
            });
          } on DioError catch (e) {
            if (e.response != null) {
              if (e.response.statusCode == 404)
                return showSnackBar(context, ErrorMessage.userNotFound);
              if (e.response.statusCode == 406)
                return showSnackBar(context, ErrorMessage.alreadyInWishes);
              if (e.response.statusCode == 409)
                return showSnackBar(context, ErrorMessage.alreadyInProperties);
              if (e.response.statusCode == 500)
                return showSnackBar(context, ErrorMessage.serverError);
              // Otherwise, unexpected error, print and raise exception
              errorOnResponse(e);
            } else {
              // Generic error before the request is sent, print
              errorOnRequest(e, false);
              return showSnackBar(context, ErrorMessage.checkConnection);
            }
          }

          session.wishes.remove(book);
          session.properties.add(book);
          showSnackBar(context, ConfirmMessage.wishMoved);
          pop(context);
        });
  }

  Future<void> updateSession(BuildContext context) async {
    print("[Wishes services] Getting wishes from Delibrary...");

    Response response;

    Session session = context.read<Session>();
    String username = session.user.username;

    try {
      response = await dio.get("users/$username/wishes");
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 404)
          return showSnackBar(context, ErrorMessage.userNotFound);
        if (e.response.statusCode == 500)
          return showSnackBar(context, ErrorMessage.serverError);
        // Otherwise, unexpected error, print and raise exception
        errorOnResponse(e);
      } else {
        // Generic error before the request is sent, print
        errorOnRequest(e, false);
        return showSnackBar(context, ErrorMessage.checkConnection);
      }
    }

    // Property list fetched, parse and update session
    WishList wishList = WishList.fromJson(response.data);
    session.wishes = await _getBooksFromWishes(wishList.wishes);
  }
}
