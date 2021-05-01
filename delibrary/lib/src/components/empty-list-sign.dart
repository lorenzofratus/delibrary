import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:flutter/material.dart';

class EmptyListSign extends StatelessWidget {
  final bool large;
  final bool book;

  EmptyListSign({this.large = true, this.book = true});

  @override
  Widget build(BuildContext context) {
    return PaddedContainer(
      alignment: Alignment.center,
      child: Text(
        book ? "Nessun libro trovato" : "Nessuno scambio trovato",
        textAlign: TextAlign.center,
        style: large
            ? Theme.of(context).textTheme.headline5
            : Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
