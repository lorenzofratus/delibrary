import 'package:flutter/material.dart';

class PaddedListView extends ListView {
  PaddedListView({List<Widget> children})
      : super(padding: EdgeInsets.all(50.0), children: children);
}
