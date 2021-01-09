import 'dart:convert';
import 'package:delibrary/src/controller/books-services.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/property-list.dart';
import 'package:http/http.dart' as http;

class PositionServices {
  static Future<BookList> getByQuery(String province, String town) async {
    province = _clean(province);
    town = _clean(town);
    _checkValidProvince(province);
    _checkValidTown(province, town);
    return _getBooksByPosition(province, town);
  }

  static String _clean(string) {
    string = string.trim();
    string = string.toLowerCase();
    string = Uri.encodeComponent(string);
    return string;
  }

  static void _checkValidProvince(String province) async {
    final response = await http
        .get("https://comuni-ita.herokuapp.com/api/province?onlyname=true");
    if (response.statusCode == 200) {
      final List<String> provinces =
          (jsonDecode(response.body) as List).map((l) => l.toString()).toList();
      if (provinces
          .map((province) => province.toLowerCase())
          .contains(province.toLowerCase()))
        return;
      else
        throw Exception("The given province does not exist.");
    } else {
      throw Exception("Comuni ITA API error while fetching provinces.");
    }
  }

  static void _checkValidTown(String province, String town) async {
    final response = await http.get(
        "https://comuni-ita.herokuapp.com/api/comuni/provincia/" +
            province +
            "?onlyname=true");
    if (response.statusCode == 200) {
      List<String> towns =
          (jsonDecode(response.body) as List).map((i) => i.toString()).toList();
      if (towns.map((town) => town.toLowerCase()).contains(town.toLowerCase()))
        return;
      else
        throw Exception("The given town does not exist in the given province.");
    } else {
      throw Exception("Comuni ITA API error while fetching towns.");
    }
  }

  static Future<BookList> _getBooksByPosition(
      String province, String town) async {
    final response = await http.get(
        "https://delibrary.herokuapp.com/v1/properties/" +
            province +
            "/" +
            town);
    if (response.statusCode == 200) {
      return _getBooksFromProperties(
          PropertyList.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception(
          "Delibrary API error while fetching books in given province and town.");
    }
  }

  static Future<BookList> _getBooksFromProperties(
      PropertyList propertyList) async {
    List<Book> bookList = [];
    BooksServices bookServices = BooksServices();

    await Future.forEach(propertyList.properties, (property) async {
      Book book = await bookServices.getById(property.bookId);
      bookList.add(book);
    });

    return BookList(totalItems: bookList.length, items: bookList);
  }
}
