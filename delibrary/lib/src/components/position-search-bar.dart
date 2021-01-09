import 'package:delibrary/src/components/search-field.dart';
import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:flutter/material.dart';

import 'button.dart';
import 'search-field.dart';

class PositionSearchBar extends StatefulWidget {
  final Function onSearch;

  PositionSearchBar({
    @required this.onSearch,
  });

  @override
  State<StatefulWidget> createState() => _PositionSearchBarState();
}

class _PositionSearchBarState extends State<PositionSearchBar> {
  final _formKey = GlobalKey<FormState>();

  String _province = "";
  String _town = "";

  String _provinceValidator(String province) {
    province = province.trim();
    this._province = province;
    if (province.isEmpty)
      return "Il campo 'provincia' non può essere vuoto.";
    else
      return null;
  }

  String _townValidator(String town) {
    town = town.trim();
    this._town = town;
    return null;
  }

  void _onPressed() {
    if (this._formKey.currentState.validate())
      widget.onSearch(this._province, this._town);
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
            key: this._formKey,
            child: Column(
              children: [
                SearchFormField(
                  validator: _provinceValidator,
                  hint: "Provincia",
                ),
                SearchFormField(validator: _townValidator, hint: "Comune")
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
