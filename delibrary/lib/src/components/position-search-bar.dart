import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/search-field.dart';
import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:flutter/material.dart';

class PositionSearchBar extends StatefulWidget {
  final void Function(String, String) onSearch;
  final Map<String, List<String>> provinces;

  PositionSearchBar({@required this.onSearch, @required this.provinces})
      : assert(provinces != null);

  @override
  State<StatefulWidget> createState() => _PositionSearchBarState();
}

class _PositionSearchBarState extends State<PositionSearchBar> {
  final _formKey = GlobalKey<FormState>();

  String _province = "";
  String _town = "";

  String _provinceValidator(String province) {
    province = province.trim().toLowerCase();
    if (province.isEmpty)
      return "La provincia non può essere vuota.";
    else if (!widget.provinces.containsKey(province))
      return "Questa provincia non esiste.";
    _province = province;
    return null;
  }

  String _townValidator(String town) {
    town = town.trim().toLowerCase();
    if (town.isNotEmpty && !widget.provinces[_province].contains(town))
      return "Questo comune non esiste nella provincia.";
    _town = town;
    return null;
  }

  void _onPressed() {
    if (widget.onSearch != null && _formKey.currentState.validate())
      widget.onSearch(_province, _town);
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
                  validator: _provinceValidator,
                  hint: "Provincia",
                ),
                SearchFormField(
                  validator: _townValidator,
                  hint: "Comune",
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
