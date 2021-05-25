import 'dart:convert';
import 'dart:io';

import 'package:delibrary/src/model/secondary/property.dart';
import 'package:delibrary/src/model/utils/position.dart';
import 'package:test/test.dart';

void main() {
  group('Property', () {
    test('should correctly get its Position as string', () {
      final Position position = Position("Province", "Town");
      final Property property = Property(id: 1, position: position);

      expect(property.positionString, "Town - Province");
    });
    test('should correctly be generated from JSON', () async {
      final File file = File('test_assets/property.json');
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());
      final Property property = Property.fromJson(json);

      expect(property.id, json["id"]);
      expect(property.ownerUsername, json["owner"]);
      expect(property.bookId, json["bookId"]);
      expect(property.position.province, json["province"]);
      expect(property.position.town, json["town"]);
    });
    test('should correctly be exported in JSON', () async {
      final File file = File('test_assets/property.json');
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());
      final Map<String, dynamic> property = Property.fromJson(json).toJson();

      expect(property["id"], json["id"]);
      expect(property["owner"], json["owner"]);
      expect(property["bookId"], json["bookId"]);
      expect(property["position"]["province"], json["province"]);
      expect(property["position"]["town"], json["town"]);
    });
  });
}
