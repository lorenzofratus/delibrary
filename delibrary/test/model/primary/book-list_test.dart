import 'dart:convert';
import 'dart:io';

import 'package:delibrary/src/model/primary/book-list.dart';
import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/model/secondary/property.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ItemList', () {
    test('should correctly compute the length of the list', () {
      BookList list;

      list = BookList(items: [Book(id: "1"), Book(id: "2")]);
      expect(list.length, 2);
      expect(list.isEmpty, false);

      list = BookList(items: []);
      expect(list.length, 0);
      expect(list.isEmpty, true);

      list = BookList();
      expect(list.length, 0);
      expect(list.isEmpty, true);
    });
    test('should correctly return the list or one item given its index', () {
      final List<Book> innerList = [Book(id: "1"), Book(id: "2")];
      final BookList list = BookList(items: innerList);

      expect(list.toList(), innerList);
      expect(list.getAt(0), innerList[0]);
      expect(list.getAt(1), innerList[1]);
      expect(list.getAt(null), null);
      expect(list.getAt(-1), null);
      expect(list.getAt(3), null);
    });
    test('should correctly recognize if the list contains an Exchange', () {
      final List<Book> innerList = [Book(id: "1"), Book(id: "2")];
      final BookList list = BookList(items: innerList);

      expect(list.contains(innerList[0]), true);
      expect(list.contains(innerList[1]), true);
      expect(list.contains(null), false);
      expect(list.contains(Book(id: "3")), false);
    });
  });
  group('BookList', () {
    test('should be complete only if has at least totalLength items', () {
      final List<Book> innerList = [Book(id: "1"), Book(id: "1")];
      final BookList greaterList = BookList(totalItems: 1, items: innerList);
      final BookList equalList = BookList(totalItems: 2, items: innerList);
      final BookList smallerList = BookList(totalItems: 3, items: innerList);

      expect(greaterList.isComplete, true);
      expect(equalList.isComplete, true);
      expect(smallerList.isComplete, false);
    });
    test('should correctly compute the wishedMap', () {
      final Book book1 = Book(id: "1");
      final Book book2 = Book(id: "2");
      final Book book3 = Book(id: "3");
      final Book book4 = Book(id: "4");
      final Book book5 = Book(id: "5");
      final List<Book> innerList = [book1, book2, book3];
      final List<Book> innerWish = [book2, book3, book4, book5];
      final BookList list = BookList(items: innerList);
      final BookList wish = BookList(items: innerWish);
      Map<Book, bool> map;

      map = list.getWishedMap(null);
      map.forEach((key, value) {
        expect(innerList.contains(key), true);
        expect(value, false);
      });

      map = list.getWishedMap(wish);
      map.forEach((key, value) {
        expect(innerList.contains(key), true);
        expect(value, innerWish.contains(key));
      });
    });
    test('should correctly be generated from JSON', () async {
      final File file = File('test_assets/book-list.json');
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());
      final List<dynamic> items = json["items"];
      final BookList list = BookList.fromJson(json);

      for (int i = 0; i < items.length; i++) {
        expect(list.getAt(i).id, items[i]["id"].toString());
      }
    });
    test('should correctly merge with another BookList', () {
      final List<Book> innerList = [Book(id: "1"), Book(id: "2")];
      final List<Book> addList = [Book(id: "3")];
      final BookList fixedList = BookList(totalItems: 10, items: innerList);

      expect(fixedList.addPage(null), fixedList);
      expect(fixedList.addPage(BookList(items: [])), fixedList);

      final BookList newList = fixedList.addPage(BookList(items: addList));
      expect(newList.totalItems, fixedList.totalItems);
      expect(newList.toList(), innerList + addList);
    });
    test('should correctly add and remove a Book', () {
      final Book book1 = Book(id: "1");
      final Book book2 = Book(id: "2");
      final Book book3 = Book(id: "3");
      List<Book> innerList = [book1, book2];
      BookList list = BookList(items: innerList);

      expect(list.add(null), list);
      expect(list.add(book1), list);

      list = list.add(book3);
      innerList.add(book3);
      expect(list.toList(), innerList);

      list = list.remove(book2);
      innerList.remove(book2);
      expect(list.toList(), innerList);

      expect(list.remove(null), list);
      expect(list.remove(book2), list);
    });
    test('should correctly update a Book', () {
      final Book book1 = Book(id: "1", property: Property(id: 1));
      final Book book2 = Book(id: "1", property: Property(id: 2));
      final Book book3 = Book(id: "3");
      BookList list = BookList(items: [book1]);

      expect(list.update(null, book2), list);
      expect(list.update(book1, null), list);
      expect(list.update(book3, book2), list);

      list = list.update(book1, book2);
      expect(list.toList(), [book2]);
    });
    test('should correctly set a parent Exchange', () {
      final Exchange parent1 = Exchange(id: "1");
      final Exchange parent2 = Exchange(id: "2");
      BookList list = BookList();

      expect(list.setParent(null), list);
      list = list.setParent(parent1);
      expect(list.parent, parent1);
      list = list.setParent(parent2);
      expect(list.parent, parent2);
    });
  });
}
