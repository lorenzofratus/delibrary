import 'package:delibrary/src/components/cards/item-card.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:flutter/material.dart';

@immutable
abstract class Item {
  final String id;

  Item({this.id});

  bool match(Item item) => item?.id == id;

  Widget get backgroundImage;

  ItemCard getCard({
    bool preview = false,
    bool wished = false,
    bool showOwner = false,
    Exchange parent,
  });
}
