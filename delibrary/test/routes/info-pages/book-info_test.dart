import 'dart:convert';
import 'dart:io';

import 'package:delibrary/src/components/utils/button.dart';
import 'package:delibrary/src/components/utils/padded-list-view.dart';
import 'package:delibrary/src/controller/internal/exchange-services.dart';
import 'package:delibrary/src/controller/internal/property-services.dart';
import 'package:delibrary/src/controller/internal/wish-services.dart';
import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/model/primary/user.dart';
import 'package:delibrary/src/model/secondary/property.dart';
import 'package:delibrary/src/model/secondary/wish.dart';
import 'package:delibrary/src/model/session.dart';
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
  group('BookInfoPage', () {
    test('should throw an AssertionError if the Book object is null', () {
      expect(() {
        BookInfoPage(item: null);
      }, throwsA(isA<AssertionError>()));
    });
    testWidgets('should correctly render Book info', (tester) async {
      final widget = BookInfoPage(item: fixedBook);
      await mockNetworkImagesFor(() => tester.pumpWidget(wrapper.app(widget)));

      final listFinder = find.byType(PaddedListView);
      expect(listFinder, findsOneWidget);

      final imageFinder = find.byType(FadeInImage);
      expect(imageFinder, findsOneWidget);
      final titleFinder = richFinder.matching(fixedBook.title);
      expect(titleFinder, findsOneWidget);
      final subtitleFinder = richFinder.matching(fixedBook.subtitle);
      expect(subtitleFinder, findsOneWidget);
      final descriptionFinder = richFinder.matching(fixedBook.description);
      expect(descriptionFinder, findsOneWidget);

      for (String author in fixedBook.authorsList) {
        final authorFinder = find.text(author, skipOffstage: false);
        expect(authorFinder, findsOneWidget);
      }
      final publisherFinder =
          find.text(fixedBook.publisher, skipOffstage: false);
      expect(publisherFinder, findsOneWidget);
      final publishedDateFinder =
          find.text(fixedBook.publishedDate, skipOffstage: false);
      expect(publishedDateFinder, findsOneWidget);
    });
    testWidgets('should correctly render Property info', (tester) async {
      final Property property = Property(
        id: 1,
        ownerUsername: "username",
        position: Position("province", "town"),
      );
      final Session session = Session();
      session.user = User(username: property.ownerUsername, email: '');
      final widget = BookInfoPage(item: fixedBook.setProperty(property));
      await mockNetworkImagesFor(() => tester.pumpWidget(
            wrapper.app(widget, session),
          ));

      final ownerFinder =
          find.text(property.ownerUsername, skipOffstage: false);
      expect(ownerFinder, findsOneWidget);
      final positionFinder =
          find.text(property.positionString, skipOffstage: false);
      expect(positionFinder, findsOneWidget);
    });
    testWidgets('should display wished mark when needed', (tester) async {
      final widget = BookInfoPage(item: fixedBook, wished: true);
      await mockNetworkImagesFor(() => tester.pumpWidget(
            wrapper.app(widget),
          ));

      final wishFinder = find.byIcon(Icons.favorite);
      expect(wishFinder, findsOneWidget);
    });
    testWidgets('should not display wished mark when not needed',
        (tester) async {
      final widget = BookInfoPage(item: fixedBook, wished: false);
      await mockNetworkImagesFor(() => tester.pumpWidget(
            wrapper.app(widget),
          ));

      final wishFinder = find.byIcon(Icons.favorite);
      expect(wishFinder, findsNothing);
    });
    group('actions', () {
      ExchangeServices exchangeServices;
      PropertyServices propertyServices;
      WishServices wishServices;
      setUp(() {
        exchangeServices = ExchangeServices();
        propertyServices = PropertyServices();
        wishServices = WishServices();
      });
      testWidgets('should be correct when coming from an Exchange',
          (tester) async {
        final Exchange exchange = Exchange(id: "1");
        final widget = BookInfoPage(item: fixedBook, parent: exchange);
        await mockNetworkImagesFor(
          () => tester.pumpWidget(wrapper.app(widget)),
        );

        final listFinder = find.byType(PaddedListView);
        expect(listFinder, findsOneWidget);

        final actionFinder1 =
            find.text(exchangeServices.agree(exchange, fixedBook).text);
        await tester.dragUntilVisible(
          actionFinder1,
          listFinder,
          Offset(0.0, -50.0),
        );
        expect(actionFinder1, findsOneWidget);

        final actionsFinder = find.byType(DelibraryButton, skipOffstage: false);
        expect(actionsFinder, findsOneWidget);
      });
      group('with Property', () {
        Property property;
        Book newBook;
        setUp(() {
          property = Property(
            id: 1,
            ownerUsername: "username",
            position: Position("province", "town"),
          );
          newBook = fixedBook.setProperty(property);
        });
        group('with Exchange', () {
          Session session;
          setUp(() {
            final Exchange exchange = Exchange(
              id: "1",
              property: newBook,
              status: ExchangeStatus.proposed,
              isBuyer: true,
            );
            session = Session();
            session.addExchange(exchange);
          });
          testWidgets('should be correct when belongs to the user',
              (tester) async {
            final User user = User(username: property.ownerUsername, email: '');
            session.user = user;

            final widget = BookInfoPage(item: newBook);
            await mockNetworkImagesFor(
              () => tester.pumpWidget(wrapper.app(widget, session)),
            );

            final listFinder = find.byType(PaddedListView);
            expect(listFinder, findsOneWidget);

            final alertFinder = find.byIcon(Icons.warning_amber_rounded);
            await tester.dragUntilVisible(
              alertFinder,
              listFinder,
              Offset(0.0, -50.0),
            );
            expect(alertFinder, findsOneWidget);

            final actionFinder1 =
                find.text(propertyServices.removeProperty(newBook).text);
            final actionFinder2 = find
                .text(propertyServices.movePropertyToWishList(newBook).text);
            final actionFinder3 = find
                .text(propertyServices.changePropertyPosition(newBook).text);
            await tester.dragUntilVisible(
              actionFinder3,
              listFinder,
              Offset(0.0, -50.0),
            );
            expect(actionFinder1, findsOneWidget);
            expect(actionFinder2, findsOneWidget);
            expect(actionFinder3, findsOneWidget);

            final actionsFinder =
                find.byType(DelibraryButton, skipOffstage: false);
            expect(actionsFinder, findsNWidgets(3));
          });
          testWidgets('should be correct when does not belong to the user',
              (tester) async {
            final widget = BookInfoPage(item: newBook);
            await mockNetworkImagesFor(
              () => tester.pumpWidget(wrapper.app(widget, session)),
            );

            final listFinder = find.byType(PaddedListView);
            expect(listFinder, findsOneWidget);

            final alertFinder = find.byIcon(Icons.warning_amber_rounded);
            await tester.dragUntilVisible(
              alertFinder,
              listFinder,
              Offset(0.0, -50.0),
            );
            expect(alertFinder, findsOneWidget);

            final actionsFinder =
                find.byType(DelibraryButton, skipOffstage: false);
            expect(actionsFinder, findsNothing);
          });
        });
        group('without Exchange', () {
          testWidgets('should be correct when belongs to the user',
              (tester) async {
            final Session session = Session();
            final User user = User(username: property.ownerUsername, email: '');
            session.user = user;

            final widget = BookInfoPage(item: newBook);
            await mockNetworkImagesFor(
              () => tester.pumpWidget(wrapper.app(widget, session)),
            );

            final listFinder = find.byType(PaddedListView);
            expect(listFinder, findsOneWidget);

            final actionFinder1 =
                find.text(propertyServices.removeProperty(newBook).text);
            final actionFinder2 = find
                .text(propertyServices.movePropertyToWishList(newBook).text);
            final actionFinder3 = find
                .text(propertyServices.changePropertyPosition(newBook).text);
            await tester.dragUntilVisible(
              actionFinder3,
              listFinder,
              Offset(0.0, -50.0),
            );
            expect(actionFinder1, findsOneWidget);
            expect(actionFinder2, findsOneWidget);
            expect(actionFinder3, findsOneWidget);

            final actionsFinder =
                find.byType(DelibraryButton, skipOffstage: false);
            expect(actionsFinder, findsNWidgets(3));
          });
          testWidgets('should be correct when does not belong to the user',
              (tester) async {
            final widget = BookInfoPage(item: newBook);
            await mockNetworkImagesFor(
              () => tester.pumpWidget(wrapper.app(widget)),
            );

            final listFinder = find.byType(PaddedListView);
            expect(listFinder, findsOneWidget);

            final actionFinder1 =
                find.text(exchangeServices.propose(property).text);
            final actionFinder2 =
                find.text(propertyServices.addProperty(newBook).text);
            await tester.dragUntilVisible(
              actionFinder2,
              listFinder,
              Offset(0.0, -50.0),
            );
            expect(actionFinder1, findsOneWidget);
            expect(actionFinder2, findsOneWidget);

            final actionsFinder =
                find.byType(DelibraryButton, skipOffstage: false);
            expect(actionsFinder, findsNWidgets(2));
          });
        });
      });
      testWidgets('with Wish should be correct', (tester) async {
        final Session session = Session();
        final Wish wish = Wish(
          id: 1,
          ownerUsername: "username",
        );
        final User user = User(username: wish.ownerUsername, email: '');
        session.user = user;
        final Book newBook = fixedBook.setWish(wish);

        final widget = BookInfoPage(item: newBook);
        await mockNetworkImagesFor(
          () => tester.pumpWidget(wrapper.app(widget, session)),
        );

        final listFinder = find.byType(PaddedListView);
        expect(listFinder, findsOneWidget);

        final actionFinder1 = find.text(wishServices.removeWish(newBook).text);
        await tester.dragUntilVisible(
          actionFinder1,
          listFinder,
          Offset(0.0, -50.0),
        );
        expect(actionFinder1, findsOneWidget);

        final actionsFinder = find.byType(DelibraryButton, skipOffstage: false);
        expect(actionsFinder, findsOneWidget);
      });
      testWidgets('should be correct for a third part Book', (tester) async {
        final widget = BookInfoPage(item: fixedBook);
        await mockNetworkImagesFor(
          () => tester.pumpWidget(wrapper.app(widget)),
        );

        final listFinder = find.byType(PaddedListView);
        expect(listFinder, findsOneWidget);

        final actionFinder1 =
            find.text(propertyServices.addProperty(fixedBook).text);
        final actionFinder2 = find.text(wishServices.addWish(fixedBook).text);
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
    });
  });
}
