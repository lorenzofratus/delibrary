import 'dart:convert';
import 'dart:io';

import 'package:delibrary/src/components/cards/exchange-card.dart';
import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/model/primary/user.dart';
import 'package:delibrary/src/routes/info-pages/exchange-info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/test-utils.dart';

void main() {
  Exchange fixedExchangeB;
  Exchange fixedExchangeS;
  WidgetWrapper wrapper;

  setUp(() async {
    final File file = File('test_assets/exchange-active.json');
    final Map<String, dynamic> json = jsonDecode(await file.readAsString());
    final User buyer = User.fromJson(json['buyer']);
    final User seller = User.fromJson(json['seller']);
    final File file2 = File('test_assets/book.json');
    final Map<String, dynamic> json2 = jsonDecode(await file2.readAsString());
    final Book book = Book.fromJson(json2);
    fixedExchangeB = Exchange(
      id: json['id'].toString(),
      buyer: buyer,
      seller: seller,
      isBuyer: true,
      status: ExchangeStatus.from[json['status']],
      property: book,
      payment: book,
    );
    fixedExchangeS = Exchange(
      id: json['id'].toString(),
      buyer: buyer,
      seller: seller,
      isBuyer: false,
      status: ExchangeStatus.from[json['status']],
      property: book,
      payment: book,
    );

    wrapper = WidgetWrapper();
  });
  group('ExchangeCard', () {
    test('should throw an AssertionError if the Exchange object is null', () {
      expect(() {
        ExchangeCard(exchange: null);
      }, throwsA(isA<AssertionError>()));
    });
    testWidgets('should correctly render the buyer preview', (tester) async {
      final widget =
          ExchangeCard(exchange: fixedExchangeB, preview: true, tappable: true);
      await mockNetworkImagesFor(
          () => tester.pumpWidget(wrapper.scaffold(widget)));
      // Check correctly rendered
      final widgetFinder = find.byWidget(widget);
      expect(widgetFinder, findsOneWidget);
      final imageFinder = find.byType(FadeInImage);
      expect(imageFinder, findsOneWidget);
      final iconFinder = find.byIcon(Icons.login);
      expect(iconFinder, findsOneWidget);

      // Check correctly opens page
      await tester.tap(widgetFinder);
      await tester.pumpAndSettle();
      final pageFinder = find.byType(ExchangeInfoPage);
      expect(pageFinder, findsOneWidget);
    });
    testWidgets('should correctly render the seller preview', (tester) async {
      final widget =
          ExchangeCard(exchange: fixedExchangeS, preview: true, tappable: true);
      await mockNetworkImagesFor(
          () => tester.pumpWidget(wrapper.scaffold(widget)));
      // Check correctly rendered
      final widgetFinder = find.byWidget(widget);
      expect(widgetFinder, findsOneWidget);
      final imageFinder = find.byType(FadeInImage);
      expect(imageFinder, findsOneWidget);
      final iconFinder = find.byIcon(Icons.logout);
      expect(iconFinder, findsOneWidget);

      // Check correctly opens page
      await tester.tap(widgetFinder);
      await tester.pumpAndSettle();
      final pageFinder = find.byType(ExchangeInfoPage);
      expect(pageFinder, findsOneWidget);
    });
    testWidgets('should correctly render the card', (tester) async {
      final widget = ExchangeCard(
          exchange: fixedExchangeS, preview: false, tappable: true);
      await mockNetworkImagesFor(
          () => tester.pumpWidget(wrapper.scaffold(widget)));
      // Check correctly rendered
      final widgetFinder = find.byWidget(widget);
      expect(widgetFinder, findsOneWidget);
      final imageFinder = find.byType(FadeInImage);
      expect(imageFinder, findsNWidgets(2));
      final iconFinder = find.byIcon(Icons.swap_horiz);
      expect(iconFinder, findsOneWidget);

      // Check correctly opens page
      await tester.tap(widgetFinder);
      await tester.pumpAndSettle();
      final pageFinder = find.byType(ExchangeInfoPage);
      expect(pageFinder, findsOneWidget);
    });
  });
}
