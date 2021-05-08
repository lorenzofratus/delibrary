import 'package:delibrary/src/model/utils/field-data.dart';
import 'package:flutter/material.dart';

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

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      json["province"],
      json["town"],
    );
  }

  bool get isEmpty => province == "" && town == "";
  bool get isNotEmpty => !isEmpty;

  bool match(Position position) {
    return position != null &&
        province == position.province &&
        town == position.town;
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

class PositionBuilder {
  String _province;
  String _town;
  Map<String, List<String>> _provinces;

  PositionBuilder([Map<String, List<String>> provinces, Position position]) {
    _province = position?.province ?? "";
    _town = position?.town ?? "";
    _provinces = provinces ?? Map();
  }

  Position get position => Position.fromJson(this.toJson());

  FieldData get provinceField =>
      FieldData(text: _province, label: "Provincia", validator: setProvince);
  FieldData get townFieldNullable => FieldData(
        text: _town,
        label: "Comune",
        validator: (newValue) => setTown(newValue, true),
      );
  FieldData get townField => FieldData(
        text: _town,
        label: "Comune",
        validator: (newValue) => setTown(newValue, false),
      );

  String setProvince(newValue) {
    newValue = newValue.trim().toLowerCase();
    if (newValue.isEmpty)
      return "La provincia non può essere vuota.";
    else if (!_provinces.containsKey(newValue))
      return "Questa provincia non esiste.";
    _province = newValue;
    return null;
  }

  String setTown(newValue, nullable) {
    newValue = newValue.trim().toLowerCase();
    if (!nullable && newValue.isEmpty) return "Il comune non può essere vuoto";
    if (newValue.isNotEmpty && !_provinces[_province].contains(newValue))
      return "Questo comune non esiste nella provincia.";
    _town = newValue;
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> position = Map<String, dynamic>();
    position["province"] = _province;
    position["town"] = _town;
    return position;
  }
}
