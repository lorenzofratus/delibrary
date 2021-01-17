import 'package:delibrary/src/model/wish.dart';

class WishList {
  final List<Wish> wishes;

  WishList({this.wishes});

  factory WishList.fromJson(List<dynamic> wishList) {
    List<Wish> items = wishList.map((i) => Wish.fromJson(i)).toList();

    return WishList(wishes: items);
  }
}
