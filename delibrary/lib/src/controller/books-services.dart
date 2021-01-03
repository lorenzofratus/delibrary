import 'dart:convert';

import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:http/http.dart' as http;

class BooksServices {
  static Future<Book> getById(String id) async {
    final response = await http.get(
        "https://www.googleapis.com/books/v1/volumes/" +
            id +
            "?projection=lite");

    if (response.statusCode == 200) {
      return Book.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load book");
    }
  }

  static Future<BookList> getByQuery(String query,
      {int startIndex = 0, int maxResults = 10}) async {
    query = Uri.encodeComponent(query);
    final response = await http.get(
        "https://www.googleapis.com/books/v1/volumes?q=" +
            query +
            "&startIndex=" +
            startIndex.toString() +
            "&maxResults=" +
            maxResults.toString() +
            "&projection=lite");

    if (response.statusCode == 200) {
      return BookList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to perform book query");
    }
  }
}
