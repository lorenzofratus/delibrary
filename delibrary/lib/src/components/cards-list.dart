import 'package:delibrary/src/components/card.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardsList extends StatelessWidget {
  final BookList bookList;
  final ScrollController controller;
  final Function onTap;
  final bool reverse;

  CardsList({
    @required this.bookList,
    this.controller,
    this.onTap,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    if (bookList.isEmpty)
      return PaddedContainer(
        child: Text(
          "Nessun libro trovato",
          style: Theme.of(context).textTheme.headline5,
        ),
      );

    BookList wishList = context.read<Session>().wishes;
    Map<Book, bool> wishMap = bookList.intersect(wishList);

    return ListView.builder(
      controller: controller,
      itemCount: bookList.length + (bookList.isComplete ? 0 : 1),
      itemBuilder: (context, index) {
        var realIdx = reverse ? bookList.length - index - 1 : index;
        if (realIdx == bookList.length)
          return Center(heightFactor: 3.0, child: CircularProgressIndicator());
        Book book = bookList.getAt(realIdx);
        return BookCard(book: book, onTap: onTap, wished: wishMap[book]);
      },
    );
  }
}
