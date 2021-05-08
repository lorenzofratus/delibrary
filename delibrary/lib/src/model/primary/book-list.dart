import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/item-list.dart';
import 'package:flutter/material.dart';

@immutable
class BookList extends ItemList<Book> {
  final int totalItems;

  BookList({this.totalItems = 0, List<Book> items}) : super(items: items);

  bool get isComplete => length >= totalItems;

  factory BookList.fromJson(Map<String, dynamic> json) {
    if (json["totalItems"] == 0) return BookList();

    var bookList = json["items"] as List;
    List<Book> items = bookList.map((i) => Book.fromJson(i)).toList();

    return BookList(
      totalItems: json["totalItems"],
      items: items,
    );
  }

  //TODO Revise this method
  Map<Book, bool> intersect(BookList bookList) {
    Map<Book, bool> map = Map();
    items.forEach((book) {
      map[book] = bookList?.contains(book) ?? false;
    });
    return map;
  }

  BookList addPage(BookList newList) {
    if (newList == null || newList.length == 0) return this;
    List<Book> self = items.toList();
    self.addAll(newList.toList());
    return BookList(
      totalItems: totalItems,
      items: self,
    );
  }

  BookList add(Book book) {
    if (book == null || items.contains(book)) return this;
    List<Book> self = items.toList();
    self.add(book);
    return BookList(
      totalItems: totalItems + 1,
      items: self,
    );
  }

  BookList remove(Book book) {
    if (book == null || !items.contains(book)) return this;
    List<Book> self = items.toList();
    if (self.remove(book))
      return BookList(
        totalItems: totalItems - 1,
        items: self,
      );
    return this;
  }
}
