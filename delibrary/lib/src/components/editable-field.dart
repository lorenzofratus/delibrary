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
        validator: this.validator,
        controller: TextEditingController(text: this.text),
        enabled: this.editing,
        decoration: InputDecoration(
          labelText: this.label,
          hintText: this.hint,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
