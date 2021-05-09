import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/model/primary/item-list.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@immutable
class BookList extends ItemList<Book> {
  final int totalItems;

  BookList({this.totalItems = 0, List<Book> items, Exchange parent})
      : super(items: items, parent: parent);

  @override
  bool get isComplete => length >= totalItems;

  @override
  Map<Book, bool> getWishedMap(BuildContext context) {
    BookList wishList = context.read<Session>().wishes;
    return intersect(wishList);
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

  BookList setParent(Exchange parent) {
    if (parent == null) return this;
    return BookList(
      totalItems: totalItems,
      items: items,
      parent: parent,
    );
  }
}
