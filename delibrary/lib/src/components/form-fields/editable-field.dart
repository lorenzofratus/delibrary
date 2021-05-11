import 'package:delibrary/src/components/form-fields/obscurable-field.dart';
import 'package:flutter/material.dart';

class EditableFormField extends StatelessWidget {
  final String text;
  final String label;
  final String hint;
  final String Function(String) validator;
  final bool editing;
  final bool obscurable;

  EditableFormField({
    this.text = "",
    this.label = "",
    this.hint = "",
    @required this.validator,
    this.editing = false,
    this.obscurable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: ObscurableFormField(
        obscurable: obscurable,
        validator: validator,
        controller: TextEditingController(text: text),
        enabled: editing,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
