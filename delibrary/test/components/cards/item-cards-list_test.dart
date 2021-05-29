import 'package:delibrary/src/components/cards/exchange-card.dart';
import 'package:delibrary/src/components/cards/item-cards-list.dart';
import 'package:delibrary/src/components/ui-elements/empty-list-sign.dart';
import 'package:delibrary/src/model/primary/book-list.dart';
import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange-list.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/test-utils.dart';

void main() {
  WidgetWrapper wrapper;
  setUp(() {
    wrapper = WidgetWrapper();
  });
  group('ItemCardsList', () {
    testWidgets('should correctly render leading widgets', (tester) async {
      final List<Widget> leading = [
        Container(key: Key('0')),
        Container(key: Key('1')),
        Container(key: Key('2')),
        Container(key: Key('3')),
      ];
      final widget = ItemCardsList<BookList>(
        itemList: BookList(),
        leading: leading,
      );
      await mockNetworkImagesFor(
          () => tester.pumpWidget(wrapper.scaffold(widget)));

      final listFinder = find.byType(ListView);
      expect(listFinder, findsOneWidget);

      for (Widget lead in leading) {
        final leadFinder = find.byWidget(lead, skipOffstage: false);
        expect(leadFinder, findsOneWidget);
      }
    });
    testWidgets('should show an empty sign when list is empty', (tester) async {
      final widget = ItemCardsList<BookList>(itemList: BookList());
      await mockNetworkImagesFor(
          () => tester.pumpWidget(wrapper.scaffold(widget)));

      final emptySignFinder = find.byType(EmptyListSign);
      expect(emptySignFinder, findsOneWidget);
    });
    testWidgets('should correctly render a complete list', (tester) async {
      final List<Exchange> exchanges = [
        Exchange(id: '1', isBuyer: true),
        Exchange(id: '2', isBuyer: true),
        Exchange(id: '3', isBuyer: true),
        Exchange(id: '4', isBuyer: true),
        Exchange(id: '5', isBuyer: true),
        Exchange(id: '6', isBuyer: true),
      ];
      final widget = ItemCardsList<ExchangeList>(
        itemList: ExchangeList(items: exchanges),
      );
      await mockNetworkImagesFor(
          () => tester.pumpWidget(wrapper.scaffold(widget)));

      final listFinder = find.byType(ListView);
      expect(listFinder, findsOneWidget);

      // Scroll to load all the elements
      await tester.drag(listFinder, Offset(0.0, -500.0));
      await tester.pump();

      final exchangeFinder = find.byType(ExchangeCard, skipOffstage: false);
      expect(exchangeFinder, findsNWidgets(exchanges.length));
    });
    testWidgets('should correctly load a new page', (tester) async {
      bool callbackCalled = false;
      final List<Book> books = [
        Book(id: '1'),
        Book(id: '2'),
        Book(id: '3'),
        Book(id: '4'),
        Book(id: '5'),
        Book(id: '6'),
      ];
      final widget = ItemCardsList<BookList>(
        itemList: BookList(totalItems: books.length + 1, items: books),
        nextPage: () => callbackCalled = true,
      );
      await mockNetworkImagesFor(
          () => tester.pumpWidget(wrapper.scaffold(widget)));

      final listFinder = find.byType(ListView);
      expect(listFinder, findsOneWidget);

      // Scroll to load all the elements
      await tester.drag(listFinder, Offset(0.0, -1000.0));
      await tester.pump();

      final loadingFinder = find.byType(CircularProgressIndicator);
      expect(loadingFinder, findsOneWidget);

      expect(callbackCalled, true);
    });
  });
}
