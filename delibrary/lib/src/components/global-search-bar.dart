import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/search-field.dart';
import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:flutter/material.dart';

class GlobalSearchBar extends StatefulWidget {
  final void Function(String) onSearch;

  GlobalSearchBar({@required this.onSearch}) : assert(onSearch != null);

  @override
  State<StatefulWidget> createState() => _GlobalSearchBarState();
}

class _GlobalSearchBarState extends State<GlobalSearchBar> {
  final _formKey = GlobalKey<FormState>();

  String _query = "";

  String _queryValidator(String query) {
    _query = query;
    return null;
  }

  void _onPressed() {
    if (_formKey.currentState.validate()) widget.onSearch(_query);
  }

  @override
  Widget build(BuildContext context) {
    return PaddedContainer(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50.0),
          bottomRight: Radius.circular(50.0),
        ),
      ),
      child: Column(
        children: [
          Text(
            "Che libro stai cercando?",
            style: Theme.of(context).textTheme.headline5,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                SearchFormField(
                  validator: _queryValidator,
                  hint: "Titolo, Autore, ISBN",
                ),
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
