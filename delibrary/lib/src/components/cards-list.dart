import 'package:delibrary/src/components/card.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:flutter/material.dart';

class CardsList extends StatelessWidget {
  final BookList booksList;
  final ScrollController controller;
  final Function onTap;

  CardsList({@required this.booksList, this.controller, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (booksList.isEmpty)
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
          child: Text(
            "Nessun libro trovato",
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      );
    return ListView.builder(
      controller: this.controller,
      itemCount: booksList.length,
      itemBuilder: (context, index) {
        return BookCard(book: booksList.items[index], onTap: this.onTap);
      },
    );
  }
}
