import 'dart:convert';
import 'dart:io';

import 'package:delibrary/src/components/cards/exchange-card.dart';
import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

void main() {
  group('Item', () {
    test('should correctly match another Exchange with the same id', () {
      final Exchange exchangeA = Exchange(id: "1");
      final Exchange exchangeB = Exchange(id: "1");
      final Exchange exchangeC = Exchange(id: "2");

      expect(exchangeA.match(exchangeB), true);
      expect(exchangeB.match(exchangeA), true);
      expect(exchangeC.match(exchangeA), false);
      expect(exchangeB.match(exchangeC), false);
    });
  });
  group('Exchange', () {
    test('should correctly set an ExchangeStatus', () {
      final Exchange fixedExchange = Exchange(id: "1");
      Exchange exchange;
      ExchangeStatus status;

      status = ExchangeStatus.agreed;
      exchange = fixedExchange.setStatus(status);
      expect(exchange.id, fixedExchange.id);
      expect(exchange.status, status);

      status = ExchangeStatus.happened;
      exchange = exchange.setStatus(status);
      expect(exchange.id, fixedExchange.id);
      expect(exchange.status, status);

      status = ExchangeStatus.proposed;
      exchange = exchange.setStatus(status);
      expect(exchange.id, fixedExchange.id);
      expect(exchange.status, status);

      status = ExchangeStatus.refused;
      exchange = exchange.setStatus(status);
      expect(exchange.id, fixedExchange.id);
      expect(exchange.status, status);

      exchange = exchange.setStatus(null);
      expect(exchange.id, fixedExchange.id);
      expect(exchange.status, status);
    });
    test('should correctly set a Book as payment', () {
      final Book book1 = Book(id: "ID1");
      final Book book2 = Book(id: "ID2");
      final Exchange fixedExchange = Exchange(id: "1");
      Exchange exchange;

      exchange = fixedExchange.setPayment(null);
      expect(exchange, fixedExchange);
      expect(exchange.payment, null);

      exchange = exchange.setPayment(book1);
      expect(exchange.id, fixedExchange.id);
      expect(exchange.payment, book1);
      expect(exchange.status, ExchangeStatus.agreed);

      exchange = exchange.setPayment(book2);
      expect(exchange.id, fixedExchange.id);
      expect(exchange.payment, book1);
      expect(exchange.status, ExchangeStatus.agreed);
    });
    test('should correctly be generated from JSON if active', () async {
      final File file = File('test_assets/exchange-active.json');
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());
      final Exchange exchange = await Exchange.fromJsonProperty(json, true);

      expect(exchange.id, json["id"].toString());
      expect(exchange.title, isNot(null));
      expect(exchange.description, isNot(null));
      expect(exchange.myUsername, json["buyer"]["username"]);
      expect(exchange.otherUsername, json["seller"]["username"]);
      expect(exchange.otherEmail, json["seller"]["email"]);
      expect(exchange.myBookTitle, isNot(null));
      expect(exchange.otherBookTitle, isNot(null));
      expect(exchange.myBookImage, isA<FadeInImage>());
      expect(exchange.otherBookImage, isA<FadeInImage>());
      expect(exchange.isAgreed, json["status"] == "agreed");
      expect(exchange.isArchived, false);
      expect(exchange.backgroundImage, isA<FadeInImage>());
    });
    test('should correctly be generated from JSON if archived', () async {
      final File file = File('test_assets/exchange-archived.json');
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());
      final Exchange exchange = await Exchange.fromJsonBook(json, false);

      expect(exchange.id, json["id"].toString());
      expect(exchange.title, isNot(null));
      expect(exchange.description, isNot(null));
      expect(exchange.myUsername, json["seller"]["username"]);
      expect(exchange.otherUsername, json["buyer"]["username"]);
      expect(exchange.otherEmail, json["buyer"]["email"]);
      expect(exchange.myBookTitle, isNot(null));
      expect(exchange.otherBookTitle, isNot(null));
      expect(exchange.myBookImage, isA<FadeInImage>());
      expect(exchange.otherBookImage, isA<FadeInImage>());
      expect(exchange.isAgreed, json["status"] == "agreed");
      expect(exchange.isArchived, true);
      expect(exchange.backgroundImage, isA<FadeInImage>());
    });
    test('should generate a valid ExchangeCard', () async {
      final File file = File('test_assets/exchange-active.json');
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());
      final Exchange exchange = await Exchange.fromJsonProperty(json, true);

      final ExchangeCard card = exchange.getCard();

      expect(card.item, exchange);
      expect(card.preview, false);
      expect(card.tappable, true);
    });
    test('should correctly handle the image of a missing book', () async {
      final File file = File('test_assets/exchange-active.json');
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());
      json.remove("payment");
      final Exchange exchange = await Exchange.fromJsonProperty(json, true);

      expect(exchange.myBookImage, isA<Image>());
    });
    test('should correctly recognize if a book is involved', () async {
      final File file = File('test_assets/exchange-active.json');
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());
      final Exchange exchange = await Exchange.fromJsonProperty(json, true);

      expect(exchange.involves(null), false);
      expect(exchange.involves(Book(id: "Random")), false);
      expect(exchange.involves(exchange.property), true);
      expect(exchange.involves(exchange.payment), true);
    });
  });
  group('ExchangeStatus', () {
    test('should display a title and a description for each status', () {
      Exchange exchangeB = Exchange(id: "1", isBuyer: true);
      Exchange exchangeS = Exchange(id: "2", isBuyer: false);

      void check() {
        expect(exchangeB.title, isNot(null));
        expect(exchangeS.title, isNot(null));
        expect(exchangeB.title, isNot("Scambio"));
        expect(exchangeS.title, isNot("Scambio"));
        expect(exchangeB.description, isNot(null));
        expect(exchangeS.description, isNot(null));
        expect(exchangeB.description, isNot(""));
        expect(exchangeS.description, isNot(""));
      }

      exchangeB = exchangeB.setStatus(ExchangeStatus.from["proposed"]);
      exchangeS = exchangeS.setStatus(ExchangeStatus.from["proposed"]);
      check();

      exchangeB = exchangeB.setStatus(ExchangeStatus.from["agreed"]);
      exchangeS = exchangeS.setStatus(ExchangeStatus.from["agreed"]);
      check();

      exchangeB = exchangeB.setStatus(ExchangeStatus.from["refused"]);
      exchangeS = exchangeS.setStatus(ExchangeStatus.from["refused"]);
      check();

      exchangeB = exchangeB.setStatus(ExchangeStatus.from["happened"]);
      exchangeS = exchangeS.setStatus(ExchangeStatus.from["happened"]);
      check();
    });
    test("should throw error with invalid status", () async {
      final File file = File('test_assets/exchange-active.json');
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());
      json["status"] = "random";
      expect(() async {
        await Exchange.fromJsonProperty(json, true);
      }, throwsA(isA<RangeError>()));
    });
  });
}
