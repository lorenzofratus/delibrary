import 'package:delibrary/src/model/property.dart';

class PropertyList {
  final List<Property> properties;

  PropertyList({this.properties});

  factory PropertyList.fromJson(List<dynamic> propertyList) {
    List<Property> items =
        propertyList.map((i) => Property.fromJson(i)).toList();

    return PropertyList(properties: items);
  }
}
