import 'package:delibrary/src/model/utils/position.dart';
import 'package:test/test.dart';

void main() {
  group('Position', () {
    test('should correctly be generated from JSON', () async {
      final Map<String, dynamic> json = {
        "province": "Province",
        "town": "Town"
      };
      final Position position = Position.fromJson(json);
      expect(position.province, json["province"].toLowerCase());
      expect(position.town, json["town"].toLowerCase());
    });
    test('should correctly be exported as JSON', () async {
      final Position position = Position("Province", "Town");
      final Map<String, dynamic> json = position.toJson();
      expect(json["province"], position.province);
      expect(json["town"], position.town);
    });
    test('should correctly detect if is empty or not', () async {
      Position position;

      position = Position("Province", "Town");
      expect(position.isEmpty, false);
      expect(position.isNotEmpty, true);

      position = Position("", "Town");
      expect(position.isEmpty, false);
      expect(position.isNotEmpty, true);

      position = Position("Province", "");
      expect(position.isEmpty, false);
      expect(position.isNotEmpty, true);

      position = Position("", "");
      expect(position.isEmpty, true);
      expect(position.isNotEmpty, false);
    });
    test('should correctly match another Position', () async {
      final Position position1 = Position("Position", "Town");
      final Position position2 = Position("Position", "Town");
      final Position position3 = Position("Position", "");
      final Position position4 = Position("Pos", "Tow");

      expect(position1.match(position2), true);
      expect(position2.match(position1), true);
      expect(position1.match(position3), false);
      expect(position1.match(position4), false);
    });
    test('should correctly be exported as String', () async {
      final Position position1 = Position("position", "town");
      final Position position2 = Position("Position", "");
      final Position position3 = Position("", "Town");
      final Position position4 = Position("", "");

      expect(position1.toString(), "Town - Position");
      expect(position2.toString(), " - Position");
      expect(position3.toString(), "Town - ");
      expect(position4.toString(), " - ");
    });
  });

  group('PositionBuilder', () {
    test('should correctly be generated from a Position', () {
      final Position position = Position("Position", "Town");
      final PositionBuilder builder = PositionBuilder(null, position);

      expect(builder.toJson(), position.toJson());
    });
    test('should correctly generate a Position', () {
      final Position position = Position("Position", "Town");
      final PositionBuilder builder = PositionBuilder(null, position);
      final Position newPosition = builder.position;

      expect(newPosition.toJson(), position.toJson());
    });
    test('should correctly get FieldData for all fields', () {
      final Position position = Position("Position", "Town");
      final PositionBuilder builder = PositionBuilder(null, position);

      void check(field, text) {
        expect(field.text, text);
        expect(field.label, isNot(null));
        expect(field.validator, isNot(null));
        expect(field.obscurable, false);
      }

      check(builder.provinceField, position.province);
      check(builder.townField, position.town);
      check(builder.townFieldNullable, position.town);
    });
    test('should correctly set province', () {
      final Map<String, List<String>> provinces = {
        "province": ["town"]
      };
      final PositionBuilder builder = PositionBuilder(provinces);

      final String empty = "";
      expect(builder.setProvince(empty), isNot(null));
      final String nulled = null;
      expect(builder.setProvince(nulled), isNot(null));
      final String invalid = "Invalid";
      expect(builder.setProvince(invalid), isNot(null));
      final String valid = "Province";
      expect(builder.setProvince(valid), null);
    });
    test('should correctly set town if nullable', () {
      final Map<String, List<String>> provinces = {
        "province": ["town"]
      };
      final Position position = Position("Province", "");
      final PositionBuilder builder = PositionBuilder(provinces, position);
      final Function validator = builder.townFieldNullable.validator;

      final String invalid = "Invalid";
      expect(validator(invalid), isNot(null));
      final String empty = "";
      expect(validator(empty), null);
      final String nulled = null;
      expect(validator(nulled), null);
      final String valid = "Town";
      expect(validator(valid), null);
    });
    test('should correctly set town if not nullable', () {
      final Map<String, List<String>> provinces = {
        "province": ["town"]
      };
      final Position position = Position("Province", "");
      final PositionBuilder builder = PositionBuilder(provinces, position);
      final Function validator = builder.townField.validator;

      final String invalid = "Invalid";
      expect(validator(invalid), isNot(null));
      final String empty = "";
      expect(validator(empty), isNot(null));
      final String nulled = null;
      expect(validator(nulled), isNot(null));
      final String valid = "Town";
      expect(validator(valid), null);
    });
    test('should correctly be exported as JSON', () {
      final Position position = Position("Province", "Town");
      final PositionBuilder builder = PositionBuilder(null, position);
      final Map<String, dynamic> json = builder.toJson();
      expect(json["province"], position.province);
      expect(json["town"], position.town);
    });
  });
}
