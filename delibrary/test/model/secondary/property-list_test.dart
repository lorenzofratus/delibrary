import 'dart:convert';
import 'dart:io';

import 'package:delibrary/src/model/secondary/property-list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PropertyList should correctly be generated from JSON', () async {
    final File file = File('test_assets/property-list.json');
    final List<dynamic> json = jsonDecode(await file.readAsString());
    final PropertyList list = PropertyList.fromJson(json);

    for (int i = 0; i < json.length; i++) {
      expect(list.properties[i].id, json[i]["id"]);
    }
  });
}
