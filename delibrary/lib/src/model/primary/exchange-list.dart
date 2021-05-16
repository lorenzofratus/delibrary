import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/model/primary/item-list.dart';
import 'package:flutter/material.dart';

@immutable
class ExchangeList extends ItemList<Exchange> {
  ExchangeList({List<Exchange> items}) : super(items: items);

  @override
  bool get isComplete => true;

  @override
  Map<Exchange, bool> getWishedMap(BuildContext context) => {};

  static Future<ExchangeList> fromJsonProperties(
      Map<String, dynamic> jsonList, bool isBuyer) async {
    List<Exchange> items = [];
    for (Map json in jsonList['items'])
      items.add(await Exchange.fromJsonProperty(json, isBuyer));

    return ExchangeList(items: items);
  }

  static Future<ExchangeList> fromJsonBooks(
      Map<String, dynamic> jsonList, bool isBuyer) async {
    List<Exchange> items = [];
    for (Map json in jsonList['items'])
      items.add(await Exchange.fromJsonBook(json, isBuyer));

    return ExchangeList(items: items);
  }

  // Both waiting and sent are in the proposed state
  ExchangeList get waiting => _filter(ExchangeStatus.proposed, false);
  ExchangeList get sent => _filter(ExchangeStatus.proposed, true);
  ExchangeList get refused => _filter(ExchangeStatus.refused);
  ExchangeList get agreed => _filter(ExchangeStatus.agreed);
  ExchangeList get happened => _filter(ExchangeStatus.happened);

  ExchangeList _filter(ExchangeStatus status, [bool isBuyer]) {
    return ExchangeList(
      items: items.where(
        (e) {
          if (isBuyer != null)
            return e.isBuyer == isBuyer && e.status == status;
          return e.status == status;
        },
      ).toList(),
    );
  }

  bool containsBook(Book book) {
    return items.any((e) => e.involves(book));
  }

  ExchangeList add(Exchange exchange) {
    if (exchange == null || items.contains(exchange)) return this;
    List<Exchange> self = items.toList();
    self.add(exchange);
    return ExchangeList(items: self);
  }

  ExchangeList remove(Exchange exchange) {
    if (exchange == null || !items.contains(exchange)) return this;
    List<Exchange> self = items.toList();
    self.remove(exchange);
    return ExchangeList(items: self);
  }

  ExchangeList update(Exchange exchange) {
    Exchange oldExchange =
        items.firstWhere((e) => e.match(exchange), orElse: () => null);
    print("Updating exchange");
    print(exchange);
    print(oldExchange);
    if (exchange == null || oldExchange == null) return this;
    List<Exchange> self = items.toList();
    int index = self.indexOf(oldExchange);
    self.remove(oldExchange);
    self.insert(index, exchange);
    return ExchangeList(items: self);
  }
}
