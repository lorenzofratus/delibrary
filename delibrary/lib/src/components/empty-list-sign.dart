import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:flutter/material.dart';

class EmptyListSign extends StatelessWidget {
  final bool large;

  EmptyListSign({this.large = true});

  @override
  Widget build(BuildContext context) {
    return PaddedContainer(
      alignment: Alignment.center,
      child: Text(
        "Nessun elemento trovato",
        textAlign: TextAlign.center,
        style: large
            ? Theme.of(context).textTheme.headline5
            : Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
