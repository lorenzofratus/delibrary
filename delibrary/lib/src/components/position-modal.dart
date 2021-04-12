import 'package:delibrary/src/components/search-field.dart';
import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:flutter/material.dart';

import 'button.dart';

class PositionModal extends StatefulWidget {
  final Function onSubmit;
  final Function onDiscard;
  final Map<String, List<String>> provinces;

  PositionModal({
    @required this.onSubmit,
    @required this.onDiscard,
    @required this.provinces,
  });

  @override
  State<StatefulWidget> createState() => _PositionModalState();
}

class _PositionModalState extends State<PositionModal> {
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
    if (town.isEmpty)
      return "Il comune non può essere vuoto.";
    else if (!widget.provinces[_province].contains(town))
      return "Questo comune non esiste nella provincia.";
    _town = town;
    return null;
  }

  void _onSubmit() {
    if (_formKey.currentState.validate()) widget.onSubmit(_province, _town);
  }

  @override
  Widget build(BuildContext context) {
    return PaddedContainer(
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            "Dove si trova il libro?",
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
            text: "Invia",
            onPressed: _onSubmit,
          ),
          DelibraryButton(
            text: "Annulla",
            primary: false,
            onPressed: widget.onDiscard,
          ),
        ],
      ),
    );
  }
}
