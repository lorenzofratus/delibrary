import 'dart:convert';
import 'package:delibrary/src/controller/books-services.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/property-list.dart';
import 'package:http/http.dart' as http;

class PositionServices {
  static List<String> _provinces;

  static Future<void> initProvinces() async {
    print("[Position services] Downloading provinces from comuni ita API...");
    final response = await http
        .get("https://comuni-ita.herokuapp.com/api/province?onlyname=true");
    if (response.statusCode == 200) {
      _provinces = (jsonDecode(response.body) as List)
          .map((l) => l.toString())
          .map((province) => province.toLowerCase())
          .toList();
    } else {
      throw Exception("Comuni ITA API error while fetching provinces.");
    }
  }

  static Future<BookList> getByQuery(String province, String town) async {
    province = _clean(province);
    _checkValidProvince(province);
    if (town.isNotEmpty) {
      town = _clean(town);
      _checkValidTown(province, town);
      return _getBooksByPosition(province, town);
    }
    return _getBooksByPosition(province);
  }

  static String _clean(string) {
    string = string.trim();
    string = string.toLowerCase();
    string = Uri.encodeComponent(string);
    return string;
  }

  static void _checkValidProvince(String province) async {
    print("[Position services] Checking province " + province + "...");
    if (_provinces.contains(province.toLowerCase())) {
      return;
    } else
      throw Exception("The given province does not exist.");
  }

  static void _checkValidTown(String province, String town) async {
    print("[Position services] Checking town " +
        town +
        " in province " +
        province +
        "...");
    final response = await http.get(
        "https://comuni-ita.herokuapp.com/api/comuni/provincia/" +
            province +
            "?onlyname=true");
    if (response.statusCode == 200) {
      List<String> towns =
          (jsonDecode(response.body) as List).map((i) => i.toString()).toList();
      if (towns
          .map((town) => town.toLowerCase())
          .contains(town.toLowerCase())) {
        return;
      } else
        throw Exception("The given town does not exist in the given province.");
    } else {
      throw Exception("Comuni ITA API error while fetching towns.");
    }
  }

  static Future<BookList> _getBooksByPosition(String province,
      [String town]) async {
    print("[Position services] Getting properties from Delibrary...");
    final url = "https://delibrary.herokuapp.com/v1/properties/" +
        province +
        (town != null ? ("/" + town) : "");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return _getBooksFromProperties(
          PropertyList.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception(
          "Delibrary API error while fetching books in given province and/or town.");
    }
  }

  static Future<BookList> _getBooksFromProperties(
      PropertyList propertyList) async {
    print(
        "[Position services] Getting info for each book from Google Books...");
    List<Book> bookList = [];

    await Future.forEach(propertyList.properties, (property) async {
      Book book = await BooksServices.getById(property.bookId);
      bookList.add(book);
    });

    return BookList(totalItems: bookList.length, items: bookList);
  }
}
