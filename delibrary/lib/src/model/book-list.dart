import 'package:delibrary/src/model/book.dart';

class BookList {
  final int totalItems;
  final List<Book> items;

  BookList({this.totalItems, this.items});

  int get length => this.items.length;
  bool get isEmpty => this.items.isEmpty;
  bool get isComplete => this.items.length >= this.totalItems;

  factory BookList.fromJson(Map<String, dynamic> json) {
    if (json["totalItems"] == 0)
      return BookList(
        totalItems: 0,
        items: List<Book>(),
      );

    var bookList = json["items"] as List;
    List<Book> items = bookList.map((i) => Book.fromJson(i)).toList();

    return BookList(
      totalItems: json["totalItems"],
      items: items,
    );
  }

  void addAll(BookList newList) {
    this.items.addAll(newList.items);
  }
}
