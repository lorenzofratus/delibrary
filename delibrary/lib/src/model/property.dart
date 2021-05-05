import 'package:delibrary/src/model/position.dart';
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> property = Map<String, dynamic>();
    property["id"] = this.id;
    property["owner"] = this.ownerUsername;
    property["bookId"] = this.bookId;
    property["position"] = this.position.toJson();
    return property;
  }
}
