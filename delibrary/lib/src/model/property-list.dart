import 'dart:collection';

import 'package:delibrary/src/model/property.dart';
import 'package:flutter/material.dart';

@immutable
class PropertyList {
  final UnmodifiableListView<Property> properties;

  PropertyList({List<Property> properties})
      : properties = UnmodifiableListView(properties ?? []);

  factory PropertyList.fromJson(List<dynamic> propertyList) {
    List<Property> items =
        propertyList.map((i) => Property.fromJson(i)).toList();

    return PropertyList(properties: items);
  }
}
