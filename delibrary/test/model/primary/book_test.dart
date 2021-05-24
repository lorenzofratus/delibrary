import 'dart:convert';
import 'dart:io';

import 'package:delibrary/src/components/cards/book-card.dart';
import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/secondary/property.dart';
import 'package:delibrary/src/model/secondary/wish.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:test/test.dart';

void main() {
  String parseHtml(String html) {
    dynamic document = parse(html ?? "");
    return parse(document.body.text).documentElement.text;
  }

  group('Item', () {
    test('should correctly match another Book with the same id', () {
      final Book bookA = Book(id: "1");
      final Book bookB = Book(id: "1");
      final Book bookC = Book(id: "2");

      expect(bookA.match(bookB), true);
      expect(bookB.match(bookA), true);
      expect(bookC.match(bookA), false);
      expect(bookB.match(bookC), false);
    });
  });
  group('Book', () {
    test('should allow one Property with no Wish', () {
      final Property property = Property();
      expect(() {
        Book(id: "ID", property: property);
      }, isNot(throwsA(isA<AssertionError>())));
    });
    test('should correctly set a Property', () {
      final Property property1 = Property(id: 1);
      final Property property2 = Property(id: 2);
      final Wish wish = Wish(id: 3);
      final Book fixedBook1 = Book(id: "ID1");
      final Book fixedBook2 = Book(id: "ID2", wish: wish);
      Book book;

      book = fixedBook1.setProperty(property1);
      expect(book.id, fixedBook1.id);
      expect(book.property, property1);

      book = book.setProperty(null);
      expect(book.id, fixedBook1.id);
      expect(book.property, property1);

      book = book.setProperty(property2);
      expect(book.id, fixedBook1.id);
      expect(book.property, property2);

      book = fixedBook2.setProperty(property1);
      expect(book.id, fixedBook2.id);
      expect(book.property, property1);
      expect(book.wish, null);
    });
    test('should correctly remove a Property', () {
      final Property property = Property(id: 1);
      final Wish wish = Wish(id: 2);
      final Book fixedBook1 = Book(id: "ID1", property: property);
      final Book fixedBook2 = Book(id: "ID2", wish: wish);
      Book book;

      book = fixedBook1.removeProperty();
      expect(book.id, fixedBook1.id);
      expect(book.property, null);

      book = book.removeProperty();
      expect(book.id, fixedBook1.id);
      expect(book.property, null);

      book = fixedBook2.removeProperty();
      expect(book.id, fixedBook2.id);
      expect(book.property, null);
      expect(book.wish, wish);
    });
    test('should allow one Wish with no Property', () {
      final Wish wish = Wish();
      expect(() {
        Book(id: "ID", wish: wish);
      }, isNot(throwsA(isA<AssertionError>())));
    });
    test('should correctly set a Wish', () {
      final Wish wish1 = Wish(id: 1);
      final Wish wish2 = Wish(id: 2);
      final Property property = Property(id: 3);
      final Book fixedBook1 = Book(id: "ID1");
      final Book fixedBook2 = Book(id: "ID2", property: property);
      Book book;

      book = fixedBook1.setWish(wish1);
      expect(book.id, fixedBook1.id);
      expect(book.wish, wish1);

      book = book.setWish(null);
      expect(book.id, fixedBook1.id);
      expect(book.wish, wish1);

      book = book.setWish(wish2);
      expect(book.id, fixedBook1.id);
      expect(book.wish, wish2);

      book = fixedBook2.setWish(wish1);
      expect(book.id, fixedBook2.id);
      expect(book.wish, wish1);
      expect(book.property, null);
    });
    test('should correctly remove a Wish', () {
      final Wish wish = Wish(id: 1);
      final Property property = Property(id: 2);
      final Book fixedBook1 = Book(id: "ID1", wish: wish);
      final Book fixedBook2 = Book(id: "ID2", property: property);
      Book book;

      book = fixedBook1.removeWish();
      expect(book.id, fixedBook1.id);
      expect(book.wish, null);

      book = book.removeWish();
      expect(book.id, fixedBook1.id);
      expect(book.wish, null);

      book = fixedBook2.removeWish();
      expect(book.id, fixedBook2.id);
      expect(book.wish, null);
      expect(book.property, property);
    });
    test('should not allow one Wish and one Property', () {
      final Property property = Property();
      final Wish wish = Wish();
      expect(() {
        Book(id: "ID", property: property, wish: wish);
      }, throwsA(isA<AssertionError>()));
    });
    test('should correctly be generated from JSON', () async {
      final File file = File('test_assets/book.json');
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());
      final Book book = Book.fromJson(json);

      expect(book.hasDetails, true);
      expect(book.hasProperty, false);
      expect(book.hasWish, false);
      expect(book.userProperty("any"), false);
      expect(book.userWish("any"), false);

      expect(book.id, json["id"]);
      expect(book.title, parseHtml(json["volumeInfo"]["title"]));
      expect(book.subtitle, parseHtml(json["volumeInfo"]["subtitle"]));
      expect(book.authorsList, json["volumeInfo"]["authors"]);
      expect(book.authors, json["volumeInfo"]["authors"].join(', '));
      String publisher = parseHtml(json["volumeInfo"]["publisher"]);
      expect(book.publisher, publisher);
      String date = parseHtml(json["volumeInfo"]["publishedDate"]);
      String year = RegExp(r"[0-9]{4}").firstMatch(date).group(0);
      expect(book.publishedYear, year);
      expect(book.publishedDate, date);
      expect(book.publishedInfo, "$publisher, $year");
      expect(book.description, parseHtml(json["volumeInfo"]["description"]));
      expect(book.smallImage, isA<FadeInImage>());
      expect(book.largeImage, isA<FadeInImage>());
      expect(book.backgroundImage, isA<FadeInImage>());
    });
    test('should correctly manage books with no images', () {
      final Book book = Book.fromJson(null);
      expect(book.smallImage, isA<Image>());
      expect(book.largeImage, isA<Image>());
      expect(book.backgroundImage, isA<Image>());
    });
    test('should correctly manage all image sizes for smallImage', () async {
      final File file = File('test_assets/book.json');
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());
      final Map<String, dynamic> images = json["volumeInfo"]["imageLinks"];
      Book book;

      String strip(String url) {
        return url.split("://").last;
      }

      book = Book.fromJson(json);
      expect(strip(book.smallImageURL), strip(images["thumbnail"]));
      images.remove("thumbnail");
      book = Book.fromJson(json);
      expect(strip(book.smallImageURL), strip(images["small"]));
      images.remove("small");
      book = Book.fromJson(json);
      expect(strip(book.smallImageURL), strip(images["smallThumbnail"]));
      images.remove("smallThumbnail");
      book = Book.fromJson(json);
      expect(strip(book.smallImageURL), strip(images["medium"]));
      images.remove("medium");
      book = Book.fromJson(json);
      expect(strip(book.smallImageURL), strip(images["large"]));
      images.remove("large");
      book = Book.fromJson(json);
      expect(strip(book.smallImageURL), strip(images["extraLarge"]));
    });
    test('should correctly manage all image sizes for largeImage', () async {
      final File file = File('test_assets/book.json');
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());
      final Map<String, dynamic> images = json["volumeInfo"]["imageLinks"];
      Book book;

      String strip(String url) {
        return url.split("://").last;
      }

      book = Book.fromJson(json);
      expect(strip(book.largeImageURL), strip(images["extraLarge"]));
      images.remove("extraLarge");
      book = Book.fromJson(json);
      expect(strip(book.largeImageURL), strip(images["large"]));
      images.remove("large");
      book = Book.fromJson(json);
      expect(strip(book.largeImageURL), strip(images["medium"]));
      images.remove("medium");
      book = Book.fromJson(json);
      expect(strip(book.largeImageURL), strip(images["small"]));
      images.remove("small");
      book = Book.fromJson(json);
      expect(strip(book.largeImageURL), strip(images["thumbnail"]));
      images.remove("thumbnail");
      book = Book.fromJson(json);
      expect(strip(book.largeImageURL), strip(images["smallThumbnail"]));
      images.remove("smallThumbnail");
    });
    test('should generate a valid BookCard', () async {
      final File file = File('test_assets/book.json');
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());
      final Book book = Book.fromJson(json);

      final BookCard card = book.getCard();

      expect(card.item, book);
      expect(card.preview, false);
      expect(card.tappable, true);
      expect(card.exchange, null);
      expect(card.wished, false);
      expect(card.showOwner, false);
    });
  });
}
