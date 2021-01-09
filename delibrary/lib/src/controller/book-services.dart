import 'package:delibrary/src/controller/services.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:dio/dio.dart';

class BookServices extends Services {
  BookServices()
      : super(BaseOptions(
          baseUrl: "https://www.googleapis.com/books/v1/volumes",
          connectTimeout: 10000,
          receiveTimeout: 10000,
        ));

  Future<Book> getById(String id) async {
    Response response;

    id = cleanParameter(id, caseSensitive: true);

    try {
      response = await dio.get("/$id?projection=lite");
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        throw Exception(
            "Google Books API server responded with ${e.response.statusCode}");
      } else {
        print(e.request);
        print(e.message);
        throw Exception(
            "Error while setting up or sending the request to Google Books API");
      }
    }

    return Book.fromJson(response.data);
  }

  Future<BookList> getByQuery(String query,
      {int startIndex = 0, int maxResults = 10}) async {
    Response response;

    query = cleanParameter(query);

    try {
      response = await dio.get(
          "?q=$query&startIndex=$startIndex&maxResults=$maxResults&projection=lite");
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        throw Exception(
            "Google Books API server responded with ${e.response.statusCode}");
      } else {
        print(e.request);
        print(e.message);
        throw Exception(
            "Error while setting up or sending the request to Google Books API");
      }
    }

    return BookList.fromJson(response.data);
  }
}
