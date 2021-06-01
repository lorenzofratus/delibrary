import 'package:delibrary/src/components/modals/draggable-modal-page.dart';
import 'package:delibrary/src/components/utils/button.dart';
import 'package:delibrary/src/components/utils/padded-grid.dart';
import 'package:flutter/material.dart';

class ConfirmModal extends StatefulWidget {
  final void Function() onSubmit;
  final void Function() onDiscard;
  final String title = "Sicuro di voler continuare?";
  final String description;

  ConfirmModal({
    @required this.onSubmit,
    @required this.onDiscard,
    this.description,
  });

  @override
  State<StatefulWidget> createState() => _ConfirmModalState();
}

class _ConfirmModalState extends State<ConfirmModal> {
  @override
  Widget build(BuildContext context) {
    return DraggableModalPage(
      builder: (context, scrollController) => PaddedGrid(
        controller: scrollController,
        grid: false,
        maxWidth: 350.0,
        leading: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 30.0),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.headline5.copyWith(
                    color: Theme.of(context).accentColor,
                  ),
            ),
          ),
          if (widget.description != null)
            Align(
              child: Text(
                widget.description,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
        ],
        children: [
          DelibraryButton(
            text: "Conferma",
            onPressed: widget.onSubmit,
          ),
          DelibraryButton(
            text: "Torna indietro",
            primary: false,
            onPressed: widget.onDiscard,
          ),
        ],
      ),
    );
  }
}
