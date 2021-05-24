import 'dart:convert';
import 'dart:io';

import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange-list.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:test/test.dart';

void main() {
  group('ItemList', () {
    test('should correctly compute the length of the list', () {
      ExchangeList list;

      list = ExchangeList(items: [Exchange(id: "1"), Exchange(id: "2")]);
      expect(list.length, 2);
      expect(list.isEmpty, false);

      list = ExchangeList(items: []);
      expect(list.length, 0);
      expect(list.isEmpty, true);

      list = ExchangeList();
      expect(list.length, 0);
      expect(list.isEmpty, true);
    });
    test('should correctly return the list or one item given its index', () {
      final List<Exchange> innerList = [Exchange(id: "1"), Exchange(id: "2")];
      final ExchangeList list = ExchangeList(items: innerList);

      expect(list.toList(), innerList);
      expect(list.getAt(0), innerList[0]);
      expect(list.getAt(1), innerList[1]);
      expect(list.getAt(null), null);
      expect(list.getAt(-1), null);
      expect(list.getAt(3), null);
    });
    test('should correctly recognize if the list contains an Exchange', () {
      final List<Exchange> innerList = [Exchange(id: "1"), Exchange(id: "2")];
      final ExchangeList list = ExchangeList(items: innerList);

      expect(list.contains(innerList[0]), true);
      expect(list.contains(innerList[1]), true);
      expect(list.contains(null), false);
      expect(list.contains(Exchange(id: "3")), false);
    });
  });
  group('ExchangeList', () {
    test('should always be complete', () {
      ExchangeList list;

      list = ExchangeList(items: [Exchange(id: "1"), Exchange(id: "2")]);
      expect(list.isComplete, true);

      list = ExchangeList(items: []);
      expect(list.isComplete, true);

      list = ExchangeList();
      expect(list.isComplete, true);
    });
    test('should always return an empty wishMap', () {
      final ExchangeList wishList = ExchangeList();
      ExchangeList list;

      list = ExchangeList(items: [Exchange(id: "1"), Exchange(id: "2")]);
      expect(list.getWishedMap(wishList), {});

      list = ExchangeList(items: []);
      expect(list.getWishedMap(wishList), {});

      list = ExchangeList();
      expect(list.getWishedMap(wishList), {});
    });
    test('should correctly be generated from JSON if active', () async {
      final File file = File('test_assets/exchange-list-active.json');
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());
      final List<dynamic> items = json["items"];
      final ExchangeList list =
          await ExchangeList.fromJsonProperties(json, false);

      for (int i = 0; i < items.length; i++) {
        expect(list.getAt(i).id, items[i]["id"].toString());
      }
    });
    test('should correctly be generated from JSON if archived', () async {
      final File file = File('test_assets/exchange-list-archived.json');
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());
      final List<dynamic> items = json["items"];
      final ExchangeList list = await ExchangeList.fromJsonBooks(json, false);

      for (int i = 0; i < items.length; i++) {
        expect(list.getAt(i).id, items[i]["id"].toString());
      }
    });
    test('should correctly filter by status', () {
      final List<Exchange> waiting = [
        Exchange(id: '1', status: ExchangeStatus.proposed, isBuyer: false),
      ];
      final List<Exchange> sent = [
        Exchange(id: '2', status: ExchangeStatus.proposed, isBuyer: true),
      ];
      final List<Exchange> agreed = [
        Exchange(id: '3', status: ExchangeStatus.agreed),
      ];
      final List<Exchange> refused = [
        Exchange(id: '4', status: ExchangeStatus.refused),
        Exchange(id: '5', status: ExchangeStatus.refused),
        Exchange(id: '6', status: ExchangeStatus.refused),
      ];
      final List<Exchange> happened = [];
      final List<Exchange> innerList =
          waiting + sent + agreed + refused + happened;
      final ExchangeList list = ExchangeList(items: innerList);

      expect(list.waiting.toList(), waiting);
      expect(list.sent.toList(), sent);
      expect(list.agreed.toList(), agreed);
      expect(list.refused.toList(), refused);
      expect(list.happened.toList(), happened);
    });
    test('should correctly recognize if a Book is contained in any Exchange',
        () {
      final Book book1 = Book(id: '1');
      final Book book2 = Book(id: '2');
      final Book book3 = Book(id: '3');
      final List<Exchange> innerList = [
        Exchange(id: '1', property: book1),
        Exchange(id: '2', property: book1, payment: book2),
      ];
      final ExchangeList list = ExchangeList(items: innerList);

      expect(list.containsBook(book1), true);
      expect(list.containsBook(book2), true);
      expect(list.containsBook(book3), false);
      expect(list.containsBook(null), false);
    });
    test('should correctly add and remove an Exchange', () {
      final Exchange exchange1 = Exchange(id: "1");
      final Exchange exchange2 = Exchange(id: "2");
      final Exchange exchange3 = Exchange(id: "3");
      List<Exchange> innerList = [exchange1, exchange2];
      ExchangeList list = ExchangeList(items: innerList);

      expect(list.add(null), list);
      expect(list.add(exchange1), list);

      list = list.add(exchange3);
      innerList.add(exchange3);
      expect(list.toList(), innerList);

      list = list.remove(exchange2);
      innerList.remove(exchange2);
      expect(list.toList(), innerList);

      expect(list.remove(null), list);
      expect(list.remove(exchange2), list);
    });
    test('should correctly update an Exchange', () {
      final Exchange exchange1 = Exchange(id: "1", isBuyer: true);
      final Exchange exchange2 = Exchange(id: "1", isBuyer: false);
      final Exchange exchange3 = Exchange(id: "3");
      ExchangeList list = ExchangeList(items: [exchange1]);

      expect(list.update(null), list);
      expect(list.update(exchange3), list);

      list = list.update(exchange2);
      expect(list.toList(), [exchange2]);
    });
  });
}
