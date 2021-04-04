import 'package:flutter/material.dart';

class Envelope<T> {
  final T payload;
  final String error;

  Envelope({this.payload, this.error})
      : assert((payload != null) ^ (error != null));

  Widget get message => SnackBar(content: Text(error));
}
