import 'package:flutter/material.dart';

class PaddedContainer extends Container {
  PaddedContainer(
      {Widget child, Decoration decoration, AlignmentGeometry alignment})
      : super(
          padding: EdgeInsets.all(50.0),
          alignment: alignment,
          decoration: decoration,
          child: child,
        );
}
