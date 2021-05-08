import 'dart:collection';

import 'package:delibrary/src/model/secondary/wish.dart';
import 'package:flutter/material.dart';

@immutable
class WishList {
  final UnmodifiableListView<Wish> wishes;

  WishList({List<Wish> wishes}) : wishes = UnmodifiableListView(wishes ?? []);

  factory WishList.fromJson(List<dynamic> wishList) {
    List<Wish> items = wishList.map((i) => Wish.fromJson(i)).toList();

    return WishList(wishes: items);
  }
}
