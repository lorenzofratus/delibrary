import 'dart:convert';
import 'dart:io';

import 'package:delibrary/src/model/secondary/wish-list.dart';
import 'package:test/test.dart';

void main() {
  test('WishList should correctly be generated from JSON', () async {
    final File file = File('test_assets/wish-list.json');
    final List<dynamic> json = jsonDecode(await file.readAsString());
    final WishList list = WishList.fromJson(json);

    for (int i = 0; i < json.length; i++) {
      expect(list.wishes[i].id, json[i]["id"]);
    }
  });
}
