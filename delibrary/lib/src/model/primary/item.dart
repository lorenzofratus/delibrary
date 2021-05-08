import 'package:flutter/material.dart';

@immutable
abstract class Item {
  final String id;

  Item({this.id});

  bool match(Item item) => item?.id == id;
}
