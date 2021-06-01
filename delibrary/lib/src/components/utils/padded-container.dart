import 'package:flutter/material.dart';

class PaddedContainer extends Container {
  PaddedContainer(
      {Widget child,
      double width,
      Decoration decoration,
      AlignmentGeometry alignment})
      : super(
          padding: EdgeInsets.all(50.0),
          width: width,
          alignment: alignment,
          decoration: decoration,
          child: child,
        );
}
