import 'package:delibrary/src/components/search-bars/search-bar-component.dart';
import 'package:delibrary/src/components/form-fields/search-field.dart';
import 'package:delibrary/src/model/utils/position.dart';
import 'package:flutter/material.dart';

class PositionSearchBar extends StatefulWidget {
  final Future<void> Function(Position) onSearch;
  final Map<String, List<String>> provinces;
  final String title = "Dove vuoi effettuare la ricerca?";

  PositionSearchBar({@required this.onSearch, @required this.provinces})
      : assert(provinces != null);

  @override
  State<StatefulWidget> createState() => _PositionSearchBarState();
}

class _PositionSearchBarState extends State<PositionSearchBar> {
  final _formKey = GlobalKey<FormState>();
  PositionBuilder _query;

  @override
  void initState() {
    super.initState();
    _query = PositionBuilder(widget.provinces);
  }

  void _onPressed() {
    if (widget.onSearch != null && _formKey.currentState.validate())
      widget.onSearch(_query.position);
  }

  @override
  Widget build(BuildContext context) {
    return SearchBarComponent(
      title: widget.title,
      formKey: _formKey,
      fields: [
        SearchFormField(
          validator: _query.provinceField.validator,
          hint: _query.provinceField.label,
        ),
        SearchFormField(
          validator: _query.townFieldNullable.validator,
          hint: _query.townFieldNullable.label,
        ),
      ],
      onPressed: _onPressed,
    );
  }
}
