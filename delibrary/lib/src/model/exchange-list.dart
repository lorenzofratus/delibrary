import 'dart:collection';

import 'package:delibrary/src/model/exchange.dart';
import 'package:flutter/material.dart';

@immutable
class ExchangeList {
  final UnmodifiableListView<Exchange> exchanges;
  ExchangeList({List<Exchange> exchanges})
      : exchanges = UnmodifiableListView(exchanges ?? []);

  factory ExchangeList.fromJson(List<dynamic> exchangeList) {
    List<Exchange> items =
        exchangeList.map((i) => Exchange.fromJson(i)).toList();
    return ExchangeList(exchanges: items);
  }
}
