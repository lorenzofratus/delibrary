import 'dart:convert';
import 'dart:io';

import 'package:delibrary/src/model/secondary/wish.dart';
import 'package:test/test.dart';

void main() {
  test('Wish should correctly be generated from JSON', () async {
    final File file = File('test_assets/wish.json');
    final Map<String, dynamic> json = jsonDecode(await file.readAsString());
    final Wish wish = Wish.fromJson(json);

    expect(wish.id, json["id"]);
    expect(wish.ownerUsername, json["user"]);
    expect(wish.bookId, json["bookId"]);
  });
}
