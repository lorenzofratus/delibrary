import 'dart:collection';

import 'package:delibrary/src/model/book.dart';
import 'package:flutter/material.dart';

@immutable
class BookList {
  final int totalItems;
  final UnmodifiableListView<Book> items;

  BookList({this.totalItems = 0, List<Book> items})
      : items = UnmodifiableListView(items ?? []);

  int get length => items?.length ?? 0;
  bool get isEmpty => items?.isEmpty ?? true;
  bool get isComplete => length >= totalItems;

  Book getAt(int i) {
    if (items != null && 0 <= i && i < items.length) return items[i];
    return null;
  }

  factory BookList.fromJson(Map<String, dynamic> json) {
    if (json["totalItems"] == 0) return BookList();

    var bookList = json["items"] as List;
    List<Book> items = bookList.map((i) => Book.fromJson(i)).toList();

    return BookList(
      totalItems: json["totalItems"],
      items: items,
    );
  }

  List<Book> toList() => items.toList();

  BookList addPage(BookList newList) {
    if (newList == null || newList.length == 0) return this;
    List<Book> self = items.toList();
    self.addAll(newList.toList());
    return BookList(
      totalItems: totalItems,
      items: self,
    );
  }

  BookList remove(Book book) {
    if (book == null || !items.contains(book)) return this;
    List<Book> self = items.toList();
    self.remove(book);
    return BookList(
      totalItems: totalItems - 1,
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

  bool contains(Book book) => items.any((b) => b.match(book));

  //TODO Revise this method
  Map<Book, bool> intersect(BookList bookList) {
    Map<Book, bool> map = Map();
    items.forEach((book) {
      map[book] = bookList?.contains(book) ?? false;
    });
    return map;
  }
}
