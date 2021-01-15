import 'package:flutter/material.dart';

class ObscurableFormField extends StatefulWidget {
  final Function validator;
  final TextEditingController controller;
  final InputDecoration decoration;
  final bool enabled;
  final bool obscurable;

  ObscurableFormField({
    @required this.validator,
    this.controller,
    @required this.decoration,
    this.enabled = true,
    this.obscurable = false,
  });

  @override
  State<StatefulWidget> createState() => _ObscurableFormFieldState(obscurable);
}

class _ObscurableFormFieldState extends State<ObscurableFormField> {
  bool obscured;

  _ObscurableFormFieldState(this.obscured);

  void _toggleObscured() {
    if (widget.obscurable)
      setState(() {
        obscured = !obscured;
      });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      decoration: widget.decoration.copyWith(
        suffixIcon: widget.obscurable
            ? InkWell(
                borderRadius: BorderRadius.circular(25.0),
                onTap: _toggleObscured,
                child: Icon(
                  obscured ? Icons.visibility_off : Icons.visibility,
                ),
              )
            : null,
      ),
      enabled: widget.enabled,
      obscureText: obscured,
      enableSuggestions: !obscured,
      autocorrect: !obscured,
    );
  }
}
