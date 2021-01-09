import 'package:delibrary/src/components/card.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:flutter/material.dart';

class CardsList extends StatelessWidget {
  final BookList booksList;
  final ScrollController controller;
  final Function onTap;

  CardsList({@required this.booksList, this.controller, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (booksList.isEmpty)
      return PaddedContainer(
        child: Text(
          "Nessun libro trovato",
          style: Theme.of(context).textTheme.headline5,
        ),
      );
    return ListView.builder(
      controller: this.controller,
      itemCount: booksList.length + (booksList.isComplete ? 0 : 1),
      itemBuilder: (context, index) {
        if (index == booksList.length)
          return Center(heightFactor: 3.0, child: CircularProgressIndicator());
        return BookCard(book: booksList.items[index], onTap: this.onTap);
      },
    );
  }
}
