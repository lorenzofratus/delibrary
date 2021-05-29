import 'package:delibrary/src/model/utils/field-data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FieldData should be instantiable', () {
    String validator(String string) {
      return null;
    }

    final FieldData action = FieldData(
        text: "Text", label: "Label", validator: validator, obscurable: true);

    expect(action.text, "Text");
    expect(action.label, "Label");
    expect(action.validator, validator);
    expect(action.obscurable, true);
  });
}
