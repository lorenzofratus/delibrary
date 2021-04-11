class Property {
  final int id;
  final String ownerUsername;
  final String bookId;
  final Position position;

  Property({this.id, this.ownerUsername, this.bookId, this.position});

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
        id: json["id"],
        ownerUsername: json["owner"],
        bookId: json["bookId"],
        position: Position(json["province"], json["town"]));
  }
}

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
}
