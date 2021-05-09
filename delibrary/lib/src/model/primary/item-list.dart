import 'dart:collection';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/model/primary/item.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ItemList<T extends Item> {
  final UnmodifiableListView<T> items;

  // "parent" is not null only if this is a list of books of another user involved in an exchange
  final Exchange parent;

  ItemList({List<T> items, this.parent})
      : items = UnmodifiableListView(items ?? []);

  int get length => items?.length ?? 0;
  bool get isEmpty => items?.isEmpty ?? true;
  bool get isComplete;

  Map<T, bool> getWishedMap(BuildContext context);

  T getAt(int i) {
    if (items != null && 0 <= i && i < items.length) return items[i];
    return null;
  }

  List<T> toList() => items.toList();

  bool contains(T item) => items.any((i) => i.match(item));
}
