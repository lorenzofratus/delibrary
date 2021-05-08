import 'dart:collection';
import 'package:delibrary/src/model/primary/item.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ItemList<T extends Item> {
  final UnmodifiableListView<T> items;

  int get length => items?.length ?? 0;
  bool get isEmpty => items?.isEmpty ?? true;

  ItemList({List<T> items}) : items = UnmodifiableListView(items ?? []);

  T getAt(int i) {
    if (items != null && 0 <= i && i < items.length) return items[i];
    return null;
  }

  List<T> toList() => items.toList();

  bool contains(T item) => items.any((i) => i.match(item));
}
