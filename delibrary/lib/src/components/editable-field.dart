import 'package:flutter/material.dart';

class EditableFormField extends StatelessWidget {
  final String text;
  final String label;
  final String hint;
  final Function validator;
  final bool editing;

  EditableFormField({
    this.text = "",
    this.label = "",
    this.hint = "",
    @required this.validator,
    this.editing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
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
