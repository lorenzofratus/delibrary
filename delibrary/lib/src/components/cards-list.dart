import 'package:delibrary/src/components/card.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    BookList wishList = context.read<Session>().wishes;
    Map<Book, bool> wishMap = booksList.intersect(wishList);

    return ListView.builder(
      controller: controller,
      itemCount: booksList.length + (booksList.isComplete ? 0 : 1),
      itemBuilder: (context, index) {
        if (index == booksList.length)
          return Center(heightFactor: 3.0, child: CircularProgressIndicator());
        Book book = booksList.items[index];
        return BookCard(book: book, onTap: onTap, wished: wishMap[book]);
      },
    );
  }
}
