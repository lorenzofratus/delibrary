import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/temp-exchange.dart';

class Exchange {
  final int id;
  final String buyerUsername;
  final String sellerUsername;
  final Book property;
  final Book payment;
  ExchangeStatus status;

  Exchange(
      {this.id,
      this.buyerUsername,
      this.sellerUsername,
      this.property,
      this.payment,
      this.status});

  factory Exchange.fromTemp(TempExchange tempExchange, Book property,
      [Book payment]) {
    return Exchange(
        id: tempExchange.id,
        buyerUsername: tempExchange.buyerUsername,
        sellerUsername: tempExchange.sellerUsername,
        property: property,
        payment: payment,
        status: ExchangeStatus.from[tempExchange.status]);
  }
}

enum ExchangeStatus { from, PROPOSED, AGREED, REFUSED, HAPPENED }

extension ExchangeStatusIndex on ExchangeStatus {
  operator [](String key) => (name) {
        switch (name) {
          case 'proposed':
            return ExchangeStatus.PROPOSED;
          case 'agreed':
            return ExchangeStatus.AGREED;
          case 'refused':
            return ExchangeStatus.REFUSED;
          case 'happened':
            return ExchangeStatus.HAPPENED;
          default:
            throw RangeError("Stato dell'Exchange non valido.");
        }
      }(key);
}
