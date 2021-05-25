import 'package:delibrary/src/model/utils/action.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

void main() {
  test('DelibraryAction should be instantiable', () {
    void execute(BuildContext context) {}
    final DelibraryAction action =
        DelibraryAction(text: "Text", execute: execute);

    expect(action.text, "Text");
    expect(action.execute, execute);
  });
}
