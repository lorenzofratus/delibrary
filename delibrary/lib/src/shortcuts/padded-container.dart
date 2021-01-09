import 'package:flutter/material.dart';

class PaddedContainer extends Container {
  PaddedContainer({Widget child, Decoration decoration})
      : super(
          padding: EdgeInsets.all(50.0),
          decoration: decoration,
          child: child,
        );
}
