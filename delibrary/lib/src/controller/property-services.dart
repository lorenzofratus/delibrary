import 'package:delibrary/src/controller/book-services.dart';
import 'package:delibrary/src/controller/services.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/property-list.dart';
import 'package:dio/dio.dart';

class PropertyServices extends Services {
  PropertyServices()
      : super(BaseOptions(
          baseUrl: "https://delibrary.herokuapp.com/v1/properties/",
          connectTimeout: 20000,
          receiveTimeout: 20000,
        ));

  Future<BookList> getBooksByPosition(String province,
      [String town = ""]) async {
    Response response;

    print("[Properties services] Getting properties from Delibrary...");

    try {
      response = await dio.get("$province${town.isEmpty ? '' : '/' + town}");
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
    return _getBooksFromProperties(PropertyList.fromJson(response.data));
  }

  Future<BookList> _getBooksFromProperties(PropertyList propertyList) async {
    print(
        "[Properties services] Getting info for each book from Google Books...");
    List<Book> bookList = [];
    BookServices bookServices = BookServices();

    await Future.forEach(propertyList.properties, (property) async {
      Book book = await bookServices.getById(property.bookId);
      bookList.add(Book(
          id: book.id, info: book.info, ownerUsername: property.ownerUsername));
    });

    return BookList(totalItems: bookList.length, items: bookList);
  }
}
