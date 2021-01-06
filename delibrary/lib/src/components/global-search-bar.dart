import 'package:delibrary/src/components/search-field.dart';
import 'package:flutter/material.dart';

import 'button.dart';

class GlobalSearchBar extends StatefulWidget {
  final Function onSearch;

  GlobalSearchBar({
    @required this.onSearch,
  });

  @override
  State<StatefulWidget> createState() => _GlobalSearchBarState();
}

class _GlobalSearchBarState extends State<GlobalSearchBar> {
  final _formKey = GlobalKey<FormState>();

  String _query = "";

  String _queryValidator(String query) {
    query = query.trim();
    this._query = query;
    return null;
  }

  void _onPressed() {
    if (this._formKey.currentState.validate()) widget.onSearch(this._query);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50.0),
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
            key: this._formKey,
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
            onPressed: this._onPressed,
          ),
        ],
      ),
    );
  }
}
