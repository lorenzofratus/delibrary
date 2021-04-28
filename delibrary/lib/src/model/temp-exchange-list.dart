import 'dart:collection';

import 'package:delibrary/src/model/temp-exchange.dart';
import 'package:flutter/material.dart';

@immutable
class TempExchangeList {
  final UnmodifiableListView<TempExchange> exchanges;
  TempExchangeList({List<TempExchange> exchanges})
      : exchanges = UnmodifiableListView(exchanges ?? []);

  factory TempExchangeList.fromJson(List<dynamic> exchangeList) {
    List<TempExchange> items =
        exchangeList.map((i) => TempExchange.fromJson(i)).toList();
    return TempExchangeList(exchanges: items);
  }
}
