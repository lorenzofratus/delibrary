import 'package:delibrary/src/controller/book-services.dart';
import 'package:delibrary/src/controller/services.dart';
import 'package:delibrary/src/model/action.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/property-list.dart';
import 'package:delibrary/src/model/property.dart';
import 'package:dio/dio.dart';

class PropertyServices extends Services {
  static PropertyServices _singleton = PropertyServices._internal();
  BookList _bookList;

  BookList get bookList => _bookList;

  factory PropertyServices() {
    return _singleton;
  }

  PropertyServices._internal()
      : super(BaseOptions(
          // baseUrl: "https://delibrary.herokuapp.com/v1/",
          baseUrl: "http://localhost:8080/v1/",
          connectTimeout: 20000,
          receiveTimeout: 20000,
        ));

  Future<BookList> getPropertiesByPosition(String province,
      [String town = ""]) async {
    print(
        "[Properties services] Getting properties by position from Delibrary...");
    return _fetchProperties(
        "properties/$province${town.isEmpty ? '' : '/' + town}");
  }

  Future<BookList> _getBooksFromProperties(List<Property> propertyList) async {
    print(
        "[Properties services] Getting info for each book from Google Books...");
    List<Book> bookList = [];
    BookServices bookServices = BookServices();

    await Future.forEach(propertyList, (property) async {
      Book book = await bookServices.getById(property.bookId);
      bookList.add(Book(id: book.id, info: book.info, property: property));
    });

    return BookList(totalItems: bookList.length, items: bookList);
  }

  Future<BookList> _fetchProperties(String path) async {
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
    PropertyList propertyList = PropertyList.fromJson(response.data);
    return _getBooksFromProperties(propertyList.properties);
  }

  DelibraryAction removeProperty(Book book) {
    return DelibraryAction(
      text: "Rimuovi dalla libreria",
      execute: () async {
        // Remove property from server.
        Response response;
        try {
          response = await dio.delete(
              "users/${book.property.ownerUsername}/properties/${book.property.id}");
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
          // Remove property from local copy.
          _bookList.remove(book);
        } else
          throw Exception(
              "It was not possible to delete the property from the server.");
      },
    );
  }

  DelibraryAction addProperty(Book book) {
    return DelibraryAction(
      text: "Aggiungi alla libreria",
      execute: () async {
        // Remove property from server.
        Response response;
        // Envelope<User> user = await UserServices().validateUser();
        // String username = user.payload.username;
        // TODO: RETRIEVE USERNAME (from session);
        String username = "";
        try {
          // TODO: We have to retrieve the location BEFORE adding the property.
          response = await dio.post("users/$username/properties/new", data: {});
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
          throw Exception(
              "It was not possible to add the property to the server.");
      },
    );
  }

  DelibraryAction movePropertyToWishList(Book book) {
    return DelibraryAction(
        text: "Sposta nella wishlist", execute: () {/* TODO */});
  }

  Future<void> init(String username) async {
    print("[Properties services] Getting properties from Delibrary...");
    _bookList = await _fetchProperties("users/$username/properties");
  }
}
