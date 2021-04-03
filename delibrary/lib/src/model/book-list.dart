import 'package:delibrary/src/model/book.dart';

class BookList {
  final int totalItems;
  final List<Book> items;

  BookList({this.totalItems, this.items});

  int get length => items != null ? items.length : 0;
  bool get isEmpty => items != null ? items.isEmpty : true;
  bool get isComplete => items != null ? items.length >= totalItems : true;

  Book get(int i) {
    if (items != null && 0 <= i && i < items.length) return items[i];
    return null;
  }

  factory BookList.fromJson(Map<String, dynamic> json) {
    if (json["totalItems"] == 0)
      return BookList(
        totalItems: 0,
        items: [],
      );

    var bookList = json["items"] as List;
    List<Book> items = bookList.map((i) => Book.fromJson(i)).toList();

    return BookList(
      totalItems: json["totalItems"],
      items: items,
    );
  }

  void addAll(BookList newList) {
    items.addAll(newList.items);
  }

  void remove(Book book) {
    items.remove(book);
  }

  void add(Book book) {
    items.add(book);
  }
}
