import 'package:flutter/material.dart';

class PaddedListView extends ListView {
  PaddedListView(
      {ScrollController controller,
      List<Widget> children,
      bool extraPadding = false})
      : super(
          padding: extraPadding
              ? EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0)
              : EdgeInsets.all(40.0),
          controller: controller,
          children: children,
        );
}
