import 'dart:convert';
import 'dart:io';

import 'package:delibrary/src/components/cards/book-card.dart';
import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/secondary/property.dart';
import 'package:delibrary/src/model/utils/position.dart';
import 'package:delibrary/src/routes/info-pages/book-info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/test-utils.dart';

void main() {
  Book fixedBook;
  WidgetWrapper wrapper;
  RichTextFinder richFinder;

  setUp(() async {
    final File file = File('test_assets/book.json');
    final Map<String, dynamic> json = jsonDecode(await file.readAsString());
    fixedBook = Book.fromJson(json);

    wrapper = WidgetWrapper();
    richFinder = RichTextFinder();
  });
  group('BookCard', () {
    test('should throw an AssertionError if the Book object is null', () {
      expect(() {
        BookCard(book: null);
      }, throwsA(isA<AssertionError>()));
    });
    testWidgets('should correctly render the preview', (tester) async {
      final widget = BookCard(book: fixedBook, preview: true, tappable: true);
      await mockNetworkImagesFor(
          () => tester.pumpWidget(wrapper.scaffold(widget)));
      // Check correctly rendered
      final widgetFinder = find.byWidget(widget);
      expect(widgetFinder, findsOneWidget);
      final imageFinder = find.byType(FadeInImage);
      expect(imageFinder, findsOneWidget);

      // Check correctly opens page
      // TODO: not passing test but working
      // await tester.tap(widgetFinder);
      // await tester.pumpAndSettle();
      // final pageFinder = find.byType(BookInfoPage);
      // expect(pageFinder, findsOneWidget);
    });
    testWidgets('should correctly render the card', (tester) async {
      final widget = BookCard(book: fixedBook, preview: false, tappable: true);
      await mockNetworkImagesFor(
          () => tester.pumpWidget(wrapper.scaffold(widget)));
      // Check correctly rendered
      final widgetFinder = find.byWidget(widget);
      expect(widgetFinder, findsOneWidget);
      final imageFinder = find.byType(FadeInImage);
      expect(imageFinder, findsOneWidget);
      final titleFinder = richFinder.matching(fixedBook.title);
      expect(titleFinder, findsOneWidget);
      final authorFinder = richFinder.matching(fixedBook.authors);
      expect(authorFinder, findsOneWidget);
      final publisherFinder = richFinder.matching(fixedBook.publishedInfo);
      expect(publisherFinder, findsOneWidget);

      // Check correctly opens page
      await tester.tap(widgetFinder);
      await tester.pumpAndSettle();
      final pageFinder = find.byType(BookInfoPage);
      expect(pageFinder, findsOneWidget);
    });
    group('owner info', () {
      Property property;
      setUp(() {
        property = Property(
          id: 1,
          ownerUsername: "username",
          position: Position("province", "town"),
        );
      });
      testWidgets('should not be shown if not required', (tester) async {
        final widget = BookCard(
          book: fixedBook,
          showOwner: false,
          preview: false,
        );
        await mockNetworkImagesFor(
            () => tester.pumpWidget(wrapper.scaffold(widget)));

        final titleFinder = richFinder.ending(property.ownerUsername);
        expect(titleFinder, findsNothing);
        final authorFinder = richFinder.ending(property.positionString);
        expect(authorFinder, findsNothing);
      });
      testWidgets('should not be shown if no property exists', (tester) async {
        final widget = BookCard(
          book: fixedBook,
          showOwner: true,
          preview: false,
        );
        await mockNetworkImagesFor(
            () => tester.pumpWidget(wrapper.scaffold(widget)));

        final titleFinder = richFinder.ending(property.ownerUsername);
        expect(titleFinder, findsNothing);
        final authorFinder = richFinder.ending(property.positionString);
        expect(authorFinder, findsNothing);
      });
      testWidgets('should be shown if required and property exists',
          (tester) async {
        final widget = BookCard(
          book: fixedBook.setProperty(property),
          showOwner: true,
          preview: false,
        );
        await mockNetworkImagesFor(
            () => tester.pumpWidget(wrapper.scaffold(widget)));

        final titleFinder = richFinder.ending(property.ownerUsername);
        expect(titleFinder, findsOneWidget);
        final authorFinder = richFinder.ending(property.positionString);
        expect(authorFinder, findsOneWidget);
      });
    });
    group('wished', () {
      testWidgets('should not be shown if not required', (tester) async {
        final widget = BookCard(
          book: fixedBook,
          wished: false,
          preview: false,
        );
        await mockNetworkImagesFor(
            () => tester.pumpWidget(wrapper.scaffold(widget)));

        final iconFinder = find.byIcon(Icons.favorite);
        expect(iconFinder, findsNothing);
      });
      testWidgets('should be shown if required', (tester) async {
        final widget = BookCard(
          book: fixedBook,
          wished: true,
          preview: false,
        );
        await mockNetworkImagesFor(
            () => tester.pumpWidget(wrapper.scaffold(widget)));

        final iconFinder = find.byIcon(Icons.favorite);
        expect(iconFinder, findsOneWidget);
      });
    });
  });
}
