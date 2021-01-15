import 'package:delibrary/src/components/obscurable-field.dart';
import 'package:flutter/material.dart';

class SearchFormField extends StatelessWidget {
  final Function validator;
  final String hint;
  final bool obscurable;

  SearchFormField({
    @required this.validator,
    this.hint,
    this.obscurable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30.0),
      child: ObscurableFormField(
        obscurable: obscurable,
        validator: this.validator,
        decoration: InputDecoration(
          hintText: this.hint,
          filled: true,
          fillColor: Theme.of(context).cardColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 25.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Theme.of(context).accentColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Theme.of(context).errorColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Theme.of(context).accentColor),
          ),
        ),
      ),
    );
  }
}
