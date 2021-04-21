import 'package:delibrary/src/components/draggable-modal-page.dart';
import 'package:delibrary/src/components/search-field.dart';
import 'package:delibrary/src/model/position.dart';
import 'package:delibrary/src/shortcuts/padded-list-view.dart';
import 'package:flutter/material.dart';

import 'button.dart';

class PositionModal extends StatefulWidget {
  final void Function(Position) onSubmit;
  final void Function() onDiscard;
  final Map<String, List<String>> provinces;

  PositionModal({
    @required this.onSubmit,
    @required this.onDiscard,
    @required this.provinces,
  }) : assert(provinces != null);

  @override
  State<StatefulWidget> createState() => _PositionModalState();
}

class _PositionModalState extends State<PositionModal> {
  final _formKey = GlobalKey<FormState>();
  PositionBuilder _tempPosition;

  @override
  void initState() {
    super.initState();
    _tempPosition = PositionBuilder(widget.provinces);
  }

  void _onSubmit() {
    if (widget.onSubmit != null && _formKey.currentState.validate())
      widget.onSubmit(_tempPosition.position);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableModalPage(
      builder: (context, scrollController) => PaddedListView(
        controller: scrollController,
        children: [
          Align(
            child: Text(
              "Dove si trova il libro?",
              style: Theme.of(context).textTheme.headline5,
            ),
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
                  validator: _tempPosition.townField.validator,
                  hint: _tempPosition.townField.label,
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
