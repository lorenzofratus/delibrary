import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/search-field.dart';
import 'package:delibrary/src/model/position.dart';
import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:flutter/material.dart';

class PositionSearchBar extends StatefulWidget {
  final void Function(Position) onSearch;
  final Map<String, List<String>> provinces;

  PositionSearchBar({@required this.onSearch, @required this.provinces})
      : assert(provinces != null);

  @override
  State<StatefulWidget> createState() => _PositionSearchBarState();
}

class _PositionSearchBarState extends State<PositionSearchBar> {
  final _formKey = GlobalKey<FormState>();
  PositionBuilder _tempPosition;

  @override
  void initState() {
    super.initState();
    _tempPosition = PositionBuilder(widget.provinces);
  }

  void _onPressed() {
    if (widget.onSearch != null && _formKey.currentState.validate())
      widget.onSearch(_tempPosition.position);
  }

  @override
  Widget build(BuildContext context) {
    return PaddedContainer(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
      ),
      child: Column(
        children: [
          Text(
            "Dove vuoi effettuare la ricerca?",
            style: Theme.of(context).textTheme.headline5,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                SearchFormField(
                  validator: _tempPosition.provinceField.validator,
                  hint: _tempPosition.provinceField.label,
                ),
                SearchFormField(
                  validator: _tempPosition.townFieldNullable.validator,
                  hint: _tempPosition.townFieldNullable.label,
                )
              ],
            ),
          ),
          DelibraryButton(
            text: "Cerca",
            onPressed: _onPressed,
          ),
        ],
      ),
    );
  }
}
