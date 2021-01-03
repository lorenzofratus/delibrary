import 'package:delibrary/src/components/search-field.dart';
import 'package:flutter/material.dart';

import 'button.dart';

class SearchBar extends StatefulWidget {
  final Function onSearch;
  final bool globalSearch;

  SearchBar({
    @required this.onSearch,
    this.globalSearch = false,
  });

  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _formKey = GlobalKey<FormState>();

  String _query = "";
  String _filter = "";

  String _queryValidator(String query) {
    query = query.trim();
    this._query = query;
    return null;
  }

  String _filterValidator(String filter) {
    filter = filter.trim();
    //TODO check right filter
    this._filter = filter;
    return null;
  }

  void _onPressed() {
    if (this._formKey.currentState.validate())
      widget.onSearch(this._query, this._filter);
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
                if (!widget.globalSearch)
                  SearchFormField(
                    validator: _filterValidator,
                    hint: "Città, Provincia, Regione",
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
