import 'package:delibrary/src/controller/book-services.dart';
import 'package:delibrary/src/controller/services.dart';
import 'package:delibrary/src/model/action.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/property-list.dart';
import 'package:delibrary/src/model/property.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:delibrary/src/model/wish.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PropertyServices extends Services {
  PropertyServices()
      : super(BaseOptions(
          // baseUrl: "https://delibrary.herokuapp.com/v1/",
          baseUrl: "http://10.9.0.5:8080/v1/",
          // baseUrl: "http://localhost:8080/v1/",
          connectTimeout: 20000,
          receiveTimeout: 20000,
        ));

  // Returns empty list in case of error
  Future<BookList> getPropertiesByPosition(
      BuildContext context, String province,
      [String town = ""]) async {
    print(
        "[Properties services] Getting properties by position from Delibrary...");

    if (province?.isEmpty ?? true) {
      showSnackBar(context, ErrorMessage.emptyFields);
      return BookList();
    }

    Response response;

    province = cleanParameter(province);
    town = cleanParameter(town);

    try {
      response = await dio
          .get("properties/$province${town.isEmpty ? '' : '/' + town}");
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 500) {
          showSnackBar(context, ErrorMessage.serverError);
          return BookList();
        }
        // Otherwise, unexpected error, print and raise exception
        errorOnResponse(e);
      } else {
        // Generic error before the request is sent, print
        errorOnRequest(e, false);
        showSnackBar(context, ErrorMessage.checkConnection);
        return BookList();
      }
    }

    // Property list fetched, parse and return
    PropertyList propertyList = PropertyList.fromJson(response.data);

    // Remove properties whose owner is the logged in user.
    Session session = context.read<Session>();
    String username = session.user.username;
    List<Property> properties = propertyList.properties
        .where((p) => p.ownerUsername != username)
        .toList();

    return _getBooksFromProperties(properties);
  }

  Future<BookList> _getBooksFromProperties(List<Property> propertyList) async {
    print(
        "[Properties services] Getting info for each book from Google Books...");
    List<Book> bookList = [];
    BookServices bookServices = BookServices();

    await Future.forEach(propertyList, (property) async {
      Book book = await bookServices.getById(property.bookId);
      if (book != null)
        bookList.add(Book(id: book.id, info: book.info, property: property));
    });

    return BookList(totalItems: bookList.length, items: bookList);
  }

  DelibraryAction removeProperty(Book book) {
    return DelibraryAction(
      text: "Rimuovi dalla libreria",
      execute: (BuildContext context) async {
        Session session = context.read<Session>();
        String username = session.user.username;

        try {
          await dio.delete("users/$username/properties/${book.property.id}");
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

        // Property removed successfully, update session
        session.removeProperty(book);
        showSnackBar(context, ConfirmMessage.propertyRemoved);
        pop(context);
      },
    );
  }

  DelibraryAction addProperty(Book book) {
    return DelibraryAction(
      text: "Aggiungi alla libreria",
      execute: (BuildContext context) async {
        Position position = await showPositionModal(context);
        if (position == null) return;

        Session session = context.read<Session>();
        String username = session.user.username;

        Response response;

        try {
          response = await dio.post("users/$username/properties/new", data: {
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

        // Property added successfully, update session
        Property property = Property.fromJson(response.data);
        Book newBook = book.setProperty(property);

        session.addProperty(newBook);
        showSnackBar(context, ConfirmMessage.propertyAdded);
        pop(context);
      },
    );
  }

  DelibraryAction movePropertyToWishList(Book book) {
    return DelibraryAction(
        text: "Sposta nella wishlist",
        execute: (BuildContext context) async {
          Session session = context.read<Session>();
          String username = session.user.username;

          try {
            await dio.delete("users/$username/properties/${book.property.id}");
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

          Response response;

          try {
            response = await dio
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

          Wish wish = Wish.fromJson(response.data);
          Book newBook = book.setWish(wish);

          session.removeProperty(book);
          session.addWish(newBook);
          showSnackBar(context, ConfirmMessage.propertyMoved);
          pop(context);
        });
  }

  Future<void> updateSession(BuildContext context) async {
    print("[Properties services] Getting properties from Delibrary...");

    Response response;

    Session session = context.read<Session>();
    String username = session.user.username;

    try {
      response = await dio.get("users/$username/properties");
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
    PropertyList propertyList = PropertyList.fromJson(response.data);
    session.properties = await _getBooksFromProperties(propertyList.properties);
  }
}
