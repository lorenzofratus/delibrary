import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/model/primary/item-list.dart';
import 'package:flutter/material.dart';

@immutable
class BookList extends ItemList<Book> {
  final int totalItems;

  BookList({this.totalItems = 0, List<Book> items, Exchange parent})
      : super(items: items, parent: parent);

  @override
  bool get isComplete => length >= totalItems;

  @override
  Map<Book, bool> getWishedMap(ItemList wishList) {
    Map<Book, bool> map = Map();
    items.forEach((book) {
      map[book] = wishList?.contains(book) ?? false;
    });
    return map;
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

  BookList update(Book oldBook, Book newBook) {
    if (oldBook == null || newBook == null) return this;
    List<Book> self = items.toList();
    int index = self.indexOf(oldBook);
    if (index == -1) return this;
    self.remove(oldBook);
    self.insert(index, newBook);
    return BookList(items: self);
  }

  BookList setParent(Exchange parent) {
    if (parent == null) return this;
    return BookList(
      totalItems: totalItems,
      items: items,
      parent: parent,
    );
  }
}
