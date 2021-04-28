import 'dart:collection';

import 'package:delibrary/src/model/exchange.dart';

class ExchangeList {
  final UnmodifiableListView<Exchange> items;
  ExchangeList({List<Exchange> items})
      : items = UnmodifiableListView(items ?? []);

  get proposed => items.where((e) => e.status == ExchangeStatus.PROPOSED);

  get refused => items.where((e) => e.status == ExchangeStatus.REFUSED);

  get agreed => items.where((e) => e.status == ExchangeStatus.AGREED);

  get happened => items.where((e) => e.status == ExchangeStatus.HAPPENED);

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

  Exchange getAt(int i) {
    if (items != null && 0 <= i && i < items.length) return items[i];
    return null;
  }
}
