import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DelibraryAction {
  final String text;
  final Function(BuildContext) execute;

  DelibraryAction({@required this.text, @required this.execute});
}
