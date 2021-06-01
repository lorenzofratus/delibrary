import 'package:delibrary/src/components/utils/button.dart';
import 'package:delibrary/src/components/utils/padded-container.dart';
import 'package:flutter/material.dart';

class EmptyListSign extends StatelessWidget {
  final bool large;
  final String buttonText;

  EmptyListSign({this.large = true, this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PaddedContainer(
          alignment: Alignment.center,
          child: Text(
            "Nessun elemento trovato",
            textAlign: TextAlign.center,
            style: large
                ? Theme.of(context).textTheme.headline5
                : Theme.of(context).textTheme.headline6,
          ),
        ),
        if (buttonText != null) DelibraryButton(text: buttonText),
      ],
    );
  }
}
