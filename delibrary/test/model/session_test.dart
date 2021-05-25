import 'package:delibrary/src/model/primary/book-list.dart';
import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange-list.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/model/primary/user.dart';
import 'package:delibrary/src/model/secondary/property.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:test/test.dart';

void main() {
  group('Session', () {
    test('should correctly detect if is valid or not', () {
      final Session session = Session();
      final User user = User(username: "username", email: "email");

      expect(session.isValid, false);

      session.user = user;
      expect(session.isValid, true);

      session.destroy();
      expect(session.isValid, false);
    });
  });
  group('Session for user', () {
    test('should correctly set and get the User object', () {
      final Session session = Session();
      final User userA = User(username: "username1", email: "emailA");
      final User userB = User(username: "username1", email: "emailB");
      final User userC = User(username: "usernameC", email: "emailC");

      int updates = 0;
      session.addListener(() {
        updates++;
      });

      expect(session.user, null);
      expect(updates, 0);

      session.user = userA;
      expect(session.user, userA);
      expect(updates, 1);

      session.user = userC;
      expect(session.user, userA);
      expect(updates, 1);

      session.user = userB;
      expect(session.user, userB);
      expect(updates, 2);
    });
  });
  group('Session for provinces', () {
    test('should correctly set and get the Map object', () {
      final Session session = Session();
      final Map<String, List<String>> provinces = {
        "A": ["A1", "A2"],
        "B": ["B1"]
      };

      int updates = 0;
      session.addListener(() {
        updates++;
      });

      expect(session.provinces, null);
      expect(updates, 0);

      session.provinces = provinces;
      expect(session.provinces, provinces);
      expect(updates, 1);
    });
  });
  group('Session for properties', () {
    test('should correctly set and get the BookList object', () {
      final Session session = Session();
      final BookList properties = BookList();

      int updates = 0;
      session.addListener(() {
        updates++;
      });

      expect(session.properties, isA<BookList>());
      expect(session.properties, isNot(properties));
      expect(updates, 0);

      session.properties = properties;
      expect(session.properties, properties);
      expect(updates, 1);
    });
    test('should correctly add and remove a Book', () {
      final Session session = Session();
      final Book book1 = Book(id: "1");
      final Book book2 = Book(id: "2");
      final Book book3 = Book(id: "3");
      final List<Book> innerList = [book1, book2];

      session.properties = BookList(items: innerList);
      expect(session.properties.items, innerList);

      int updates = 0;
      session.addListener(() {
        updates++;
      });

      session.addProperty(null);
      expect(session.properties.items, innerList);
      expect(updates, 0);
      session.addProperty(book1);
      expect(session.properties.items, innerList);
      expect(updates, 0);

      session.addProperty(book3);
      innerList.add(book3);
      expect(session.properties.items, innerList);
      expect(updates, 1);

      session.removeProperty(book2);
      innerList.remove(book2);
      expect(session.properties.items, innerList);
      expect(updates, 2);

      session.removeProperty(null);
      expect(session.properties.items, innerList);
      expect(updates, 2);
      session.removeProperty(book2);
      expect(session.properties.items, innerList);
      expect(updates, 2);
    });
    test('should correctly update a Book', () {
      final Session session = Session();
      final Book book1 = Book(id: "1", property: Property(id: 1));
      final Book book2 = Book(id: "1", property: Property(id: 2));
      final Book book3 = Book(id: "3");
      List<Book> innerList = [book1];

      session.properties = BookList(items: innerList);
      expect(session.properties.items, innerList);

      int updates = 0;
      session.addListener(() {
        updates++;
      });

      session.updateProperty(null, book2);
      expect(session.properties.items, innerList);
      expect(updates, 0);
      session.updateProperty(book1, null);
      expect(session.properties.items, innerList);
      expect(updates, 0);
      session.updateProperty(book3, book2);
      expect(session.properties.items, innerList);
      expect(updates, 0);

      session.updateProperty(book1, book2);
      innerList = [book2];
      expect(session.properties.items, innerList);
      expect(updates, 1);
    });
  });
  group('Session for wishes', () {
    test('should correctly set and get the BookList object', () {
      final Session session = Session();
      final BookList wishes = BookList();

      int updates = 0;
      session.addListener(() {
        updates++;
      });

      expect(session.wishes, isA<BookList>());
      expect(session.wishes, isNot(wishes));
      expect(updates, 0);

      session.wishes = wishes;
      expect(session.wishes, wishes);
      expect(updates, 1);
    });
    test('should correctly add and remove a Book', () {
      final Session session = Session();
      final Book book1 = Book(id: "1");
      final Book book2 = Book(id: "2");
      final Book book3 = Book(id: "3");
      final List<Book> innerList = [book1, book2];

      session.wishes = BookList(items: innerList);
      expect(session.wishes.items, innerList);

      int updates = 0;
      session.addListener(() {
        updates++;
      });

      session.addWish(null);
      expect(session.wishes.items, innerList);
      expect(updates, 0);
      session.addWish(book1);
      expect(session.wishes.items, innerList);
      expect(updates, 0);

      session.addWish(book3);
      innerList.add(book3);
      expect(session.wishes.items, innerList);
      expect(updates, 1);

      session.removeWish(book2);
      innerList.remove(book2);
      expect(session.wishes.items, innerList);
      expect(updates, 2);

      session.removeWish(null);
      expect(session.wishes.items, innerList);
      expect(updates, 2);
      session.removeWish(book2);
      expect(session.wishes.items, innerList);
      expect(updates, 2);
    });
  });
  group('Session for active exchanges', () {
    test('should correctly set and get the ExchangeList objects', () {
      final Session session = Session();
      final List<Exchange> waiting = [
        Exchange(id: '1', status: ExchangeStatus.proposed, isBuyer: false),
      ];
      final List<Exchange> sent = [
        Exchange(id: '2', status: ExchangeStatus.proposed, isBuyer: true),
      ];
      final List<Exchange> agreed = [
        Exchange(id: '3', status: ExchangeStatus.agreed),
      ];
      final List<Exchange> innerList = waiting + sent + agreed;
      final ExchangeList exchanges = ExchangeList(items: innerList);

      int updates = 0;
      session.addListener(() {
        updates++;
      });

      expect(session.exchanges, isA<ExchangeList>());
      expect(session.exchanges, isNot(exchanges));
      expect(session.waiting, isA<ExchangeList>());
      expect(session.waiting.items, isNot(waiting));
      expect(session.sent, isA<ExchangeList>());
      expect(session.sent.items, isNot(sent));
      expect(session.agreed, isA<ExchangeList>());
      expect(session.agreed.items, isNot(agreed));
      expect(updates, 0);

      session.exchanges = exchanges;
      expect(session.exchanges, exchanges);
      expect(session.waiting.items, waiting);
      expect(session.sent.items, sent);
      expect(session.agreed.items, agreed);
      expect(updates, 1);
    });
    test('should correctly add and remove an Exchange', () {
      final Session session = Session();
      final Exchange exchange1 = Exchange(id: "1");
      final Exchange exchange2 = Exchange(id: "2");
      final Exchange exchange3 = Exchange(id: "3");
      List<Exchange> innerList = [exchange1, exchange2];

      session.exchanges = ExchangeList(items: innerList);
      expect(session.exchanges.items, innerList);

      int updates = 0;
      session.addListener(() {
        updates++;
      });

      session.addExchange(null);
      expect(session.exchanges.items, innerList);
      expect(updates, 0);
      session.addExchange(exchange1);
      expect(session.exchanges.items, innerList);
      expect(updates, 0);

      session.addExchange(exchange3);
      innerList.add(exchange3);
      expect(session.exchanges.items, innerList);
      expect(updates, 1);

      session.removeExchange(exchange2);
      innerList.remove(exchange2);
      expect(session.exchanges.items, innerList);
      expect(updates, 2);

      session.removeExchange(null);
      expect(session.exchanges.items, innerList);
      expect(updates, 2);
      session.removeExchange(exchange2);
      expect(session.exchanges.items, innerList);
      expect(updates, 2);
    });
    test('should correctly update an Exchange', () {
      final Session session = Session();
      final Exchange exchange1 = Exchange(id: "1", isBuyer: true);
      final Exchange exchange2 = Exchange(id: "1", isBuyer: false);
      final Exchange exchange3 = Exchange(id: "3");
      List<Exchange> innerList = [exchange1];

      session.exchanges = ExchangeList(items: innerList);
      expect(session.exchanges.items, innerList);

      int updates = 0;
      session.addListener(() {
        updates++;
      });

      session.updateExchange(null);
      expect(session.exchanges.items, innerList);
      expect(updates, 0);
      session.updateExchange(exchange3);
      expect(session.exchanges.items, innerList);
      expect(updates, 0);

      session.updateExchange(exchange2);
      innerList = [exchange2];
      expect(session.exchanges.items, innerList);
      expect(updates, 1);
    });
    test('should correctly detect if a Book has an active exchange', () {
      final Session session = Session();
      final Book book1 = Book(id: "1");
      final Book book2 = Book(id: "2");
      final Book book3 = Book(id: "3");
      final Book book4 = Book(id: "4");
      final List<Exchange> waiting = [
        Exchange(
            id: '1',
            status: ExchangeStatus.proposed,
            isBuyer: false,
            property: book1),
      ];
      final List<Exchange> sent = [
        Exchange(
            id: '2',
            status: ExchangeStatus.proposed,
            isBuyer: true,
            property: book2),
      ];
      final List<Exchange> agreed = [
        Exchange(id: '3', status: ExchangeStatus.agreed, property: book3),
      ];
      final List<Exchange> innerList = waiting + sent + agreed;
      final ExchangeList exchanges = ExchangeList(items: innerList);
      session.exchanges = exchanges;

      expect(session.hasActiveExchange(book1), true);
      expect(session.hasActiveExchange(book2), true);
      expect(session.hasActiveExchange(book3), true);
      expect(session.hasActiveExchange(book4), false);
      expect(session.hasActiveExchange(null), false);
    });
  });
  group('Session for archived exchanges', () {
    test('should correctly set and get the ExchangeList objects', () {
      final Session session = Session();
      final List<Exchange> refused = [
        Exchange(id: '4', status: ExchangeStatus.refused),
        Exchange(id: '5', status: ExchangeStatus.refused),
        Exchange(id: '6', status: ExchangeStatus.refused),
      ];
      final List<Exchange> happened = [
        Exchange(id: '7', status: ExchangeStatus.happened),
      ];
      final List<Exchange> innerList = refused + happened;
      final ExchangeList archived = ExchangeList(items: innerList);

      int updates = 0;
      session.addListener(() {
        updates++;
      });

      expect(session.archived, isA<ExchangeList>());
      expect(session.archived, isNot(archived));
      expect(session.refused, isA<ExchangeList>());
      expect(session.refused.items, isNot(refused));
      expect(session.happened, isA<ExchangeList>());
      expect(session.happened.items, isNot(happened));
      expect(updates, 0);

      session.archived = archived;
      expect(session.archived, archived);
      expect(session.refused.items, refused);
      expect(session.happened.items, happened);
      expect(updates, 1);
    });
    test('should correctly add an Exchange', () {
      final Session session = Session();
      final Exchange exchange1 = Exchange(id: "1");
      final Exchange exchange2 = Exchange(id: "2");
      final Exchange exchange3 = Exchange(id: "3");
      List<Exchange> innerList = [exchange1, exchange2];

      session.archived = ExchangeList(items: innerList);
      expect(session.archived.items, innerList);

      int updates = 0;
      session.addListener(() {
        updates++;
      });

      session.addArchived(null);
      expect(session.archived.items, innerList);
      expect(updates, 0);
      session.addArchived(exchange1);
      expect(session.archived.items, innerList);
      expect(updates, 0);

      session.addArchived(exchange3);
      innerList.add(exchange3);
      expect(session.archived.items, innerList);
      expect(updates, 1);
    });
  });
}
