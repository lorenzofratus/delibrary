import 'package:delibrary/src/controller/services.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:dio/dio.dart';

class BookServices extends Services {
  BookServices()
      : super(
          BaseOptions(
            baseUrl: "https://www.googleapis.com/books/v1/volumes",
            connectTimeout: 10000,
            receiveTimeout: 10000,
          ),
          true,
        );

  // Returns null in case of error
  Future<Book> getById(String id) async {
    Response response;

    id = cleanParameter(id, caseSensitive: true);

    try {
      response = await dio.get("/$id?projection=lite");
    } on DioError catch (e) {
      if (e.response != null) {
        errorOnResponse(e, false);
      } else {
        errorOnRequest(e, false);
      }
      return null;
    }

    return Book.fromJson(response.data);
  }

  // Returns empty list in case of error
  Future<BookList> getByQuery(String query,
      {int startIndex = 0, int maxResults = 10}) async {
    Response response;

    query = cleanParameter(query);

    try {
      response = await dio.get(
          "?q=$query&startIndex=$startIndex&maxResults=$maxResults&projection=lite");
    } on DioError catch (e) {
      if (e.response != null) {
        errorOnResponse(e, false);
      } else {
        errorOnRequest(e, false);
      }
      return BookList();
    }

    return BookList.fromJson(response.data);
  }
}
