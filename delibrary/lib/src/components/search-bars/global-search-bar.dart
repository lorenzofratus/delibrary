import 'package:delibrary/src/components/search-bars/search-bar-component.dart';
import 'package:delibrary/src/components/form-fields/search-field.dart';
import 'package:flutter/material.dart';

class GlobalSearchBar extends StatefulWidget {
  final Future<void> Function(String) onSearch;
  final String title = "Che libro stai cercando?";

  final double height = 318.0;

  GlobalSearchBar({@required this.onSearch}) : assert(onSearch != null);

  @override
  State<StatefulWidget> createState() => _GlobalSearchBarState();
}

class _GlobalSearchBarState extends State<GlobalSearchBar> {
  final _formKey = GlobalKey<FormState>();
  String _query;

  @override
  void initState() {
    super.initState();
    _query = "";
  }

  void _onPressed() {
    if (widget.onSearch != null && _formKey.currentState.validate())
      widget.onSearch(_query);
  }

  String _queryValidator(String query) {
    _query = query;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SearchBarComponent(
      title: widget.title,
      formKey: _formKey,
      fields: [
        SearchFormField(
          validator: _queryValidator,
          hint: "Titolo, Autore, ISBN",
        ),
      ],
      onPressed: _onPressed,
    );
  }
}
