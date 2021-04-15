import 'package:flutter/material.dart';

@immutable
class Property {
  final int id;
  final String ownerUsername;
  final String bookId;
  final Position position;

  Property({this.id, this.ownerUsername, this.bookId, this.position});

  String get positionString => position.toString();

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
        id: json["id"],
        ownerUsername: json["owner"],
        bookId: json["bookId"],
        position: Position(json["province"], json["town"]));
  }
}

@immutable
class Position {
  final String province;
  final String town;

  Position(this.province, this.town);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> position = Map<String, dynamic>();
    position["province"] = province;
    position["town"] = town;
    return position;
  }

  String _capitalize(String text) {
    List<String> words = text.split(" ");
    words = words
        .map((word) => word.substring(0, 1).toUpperCase() + word.substring(1))
        .toList();
    return words.join(" ");
  }

  @override
  String toString() {
    return _capitalize(town) + " - " + _capitalize(province);
  }
}
