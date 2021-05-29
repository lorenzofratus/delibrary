import 'dart:convert';
import 'dart:io';

import 'package:delibrary/src/components/cards/book-card.dart';
import 'package:delibrary/src/components/utils/button.dart';
import 'package:delibrary/src/controller/internal/exchange-services.dart';
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
  RichTextFinder richFinder;

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
    richFinder = RichTextFinder();
  });
  group('ExchangeInfoPage', () {
    test('should throw an AssertionError if the Exchange object is null', () {
      expect(() {
        ExchangeInfoPage(item: null);
      }, throwsA(isA<AssertionError>()));
    });
    testWidgets('should correctly render Exchange info', (tester) async {
      final widget = ExchangeInfoPage(item: fixedExchangeB);
      await mockNetworkImagesFor(() => tester.pumpWidget(wrapper.app(widget)));

      final listFinder = find.byType(ListView);
      expect(listFinder, findsOneWidget);

      final imageFinder = find.byType(FadeInImage);
      expect(imageFinder, findsOneWidget);
      final titleFinder = richFinder.matching(fixedExchangeB.title);
      expect(titleFinder, findsOneWidget);
      final descriptionFinder = richFinder.matching(fixedExchangeB.description);
      expect(descriptionFinder, findsOneWidget);

      final otherFinder = richFinder.matching(fixedExchangeB.otherUsername);
      expect(otherFinder, findsOneWidget);
    });
    testWidgets('should render contact info if agreed', (tester) async {
      final Exchange newExchange =
          fixedExchangeB.setStatus(ExchangeStatus.agreed);
      final widget = ExchangeInfoPage(item: newExchange);
      await mockNetworkImagesFor(() => tester.pumpWidget(wrapper.app(widget)));

      final listFinder = find.byType(ListView);
      expect(listFinder, findsOneWidget);

      final emailFinder = find.text(newExchange.otherEmail);
      await tester.dragUntilVisible(
        emailFinder,
        listFinder,
        Offset(0.0, -50.0),
      );
      expect(emailFinder, findsOneWidget);
    });
    testWidgets('should correctly render involved Books', (tester) async {
      final widget = ExchangeInfoPage(item: fixedExchangeB);
      await mockNetworkImagesFor(() => tester.pumpWidget(wrapper.app(widget)));

      final listFinder = find.byType(ListView);
      expect(listFinder, findsOneWidget);

      final cardFinder = find.byType(BookCard);
      await tester.dragUntilVisible(
        cardFinder,
        listFinder,
        Offset(0.0, -50.0),
      );
      await tester.drag(listFinder, Offset(0.0, -50.0));
      await tester.pump();
      expect(cardFinder, findsNWidgets(2));
    });
    group('actions', () {
      ExchangeServices exchangeServices;
      setUp(() {
        exchangeServices = ExchangeServices();
      });
      testWidgets('should be correct when status proposed and is buyer',
          (tester) async {
        final Exchange newExchange =
            fixedExchangeB.setStatus(ExchangeStatus.proposed);
        final widget = ExchangeInfoPage(item: newExchange);
        await mockNetworkImagesFor(
            () => tester.pumpWidget(wrapper.app(widget)));

        final listFinder = find.byType(ListView);
        expect(listFinder, findsOneWidget);

        final actionFinder1 =
            find.text(exchangeServices.remove(newExchange).text);
        await tester.dragUntilVisible(
          actionFinder1,
          listFinder,
          Offset(0.0, -50.0),
        );
        expect(actionFinder1, findsOneWidget);

        final actionsFinder = find.byType(DelibraryButton, skipOffstage: false);
        expect(actionsFinder, findsOneWidget);
      });
      testWidgets('should be correct when status proposed and is seller',
          (tester) async {
        final Exchange newExchange =
            fixedExchangeS.setStatus(ExchangeStatus.proposed);
        final widget = ExchangeInfoPage(item: newExchange);
        await mockNetworkImagesFor(
            () => tester.pumpWidget(wrapper.app(widget)));

        final listFinder = find.byType(ListView);
        expect(listFinder, findsOneWidget);

        final actionFinder1 = find.text("Scegli un libro");
        final actionFinder2 =
            find.text(exchangeServices.refuse(newExchange).text);
        await tester.dragUntilVisible(
          actionFinder2,
          listFinder,
          Offset(0.0, -50.0),
        );
        expect(actionFinder1, findsOneWidget);
        expect(actionFinder2, findsOneWidget);

        final actionsFinder = find.byType(DelibraryButton, skipOffstage: false);
        expect(actionsFinder, findsNWidgets(2));
      });
      testWidgets('should be correct when status agreed', (tester) async {
        final Exchange newExchange =
            fixedExchangeB.setStatus(ExchangeStatus.agreed);
        final widget = ExchangeInfoPage(item: newExchange);
        await mockNetworkImagesFor(
            () => tester.pumpWidget(wrapper.app(widget)));

        final listFinder = find.byType(ListView);
        expect(listFinder, findsOneWidget);

        final actionFinder1 =
            find.text(exchangeServices.happen(newExchange).text);
        final actionFinder2 =
            find.text(exchangeServices.refuse(newExchange).text);
        await tester.dragUntilVisible(
          actionFinder2,
          listFinder,
          Offset(0.0, -50.0),
        );
        expect(actionFinder1, findsOneWidget);
        expect(actionFinder2, findsOneWidget);

        final actionsFinder = find.byType(DelibraryButton, skipOffstage: false);
        expect(actionsFinder, findsNWidgets(2));
      });
      testWidgets('should be correct when status refused', (tester) async {
        final Exchange newExchange =
            fixedExchangeB.setStatus(ExchangeStatus.refused);
        final widget = ExchangeInfoPage(item: newExchange);
        await mockNetworkImagesFor(
            () => tester.pumpWidget(wrapper.app(widget)));

        final listFinder = find.byType(ListView);
        expect(listFinder, findsOneWidget);

        final actionsFinder = find.byType(DelibraryButton, skipOffstage: false);
        expect(actionsFinder, findsNothing);
      });
      testWidgets('should be correct when status happened', (tester) async {
        final Exchange newExchange =
            fixedExchangeB.setStatus(ExchangeStatus.refused);
        final widget = ExchangeInfoPage(item: newExchange);
        await mockNetworkImagesFor(
            () => tester.pumpWidget(wrapper.app(widget)));

        final listFinder = find.byType(ListView);
        expect(listFinder, findsOneWidget);

        final actionsFinder = find.byType(DelibraryButton, skipOffstage: false);
        expect(actionsFinder, findsNothing);
      });
    });
  });
}
