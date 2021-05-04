import 'package:delibrary/src/components/book-card.dart';
import 'package:delibrary/src/components/empty-list-sign.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/exchange.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookCardsList extends StatelessWidget {
  final BookList bookList;
  final Exchange exchange;
  final ScrollController controller;
  final bool reverse;
  final void Function() nextPage;
  final int _nextPageTreshold = 3;
  final List<Widget> leading;
  final bool showOwner;

  BookCardsList({
    @required this.bookList,
    this.exchange,
    this.controller,
    this.reverse = false,
    this.nextPage,
    this.leading,
    this.showOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    int leadLength = leading?.length ?? 0;
    int endOfList = leadLength + bookList.length;

    if (bookList?.isEmpty ?? true)
      return ListView(
        controller: controller,
        children: [
          if (leading != null) ...leading,
          EmptyListSign(),
        ],
      );

    BookList wishList = context.read<Session>().wishes;
    Map<Book, bool> wishMap = bookList.intersect(wishList);

    return ListView.builder(
      controller: controller,
      itemCount: endOfList + (bookList.isComplete ? 0 : 1),
      itemBuilder: (context, index) {
        // Check when to load next page
        if (index == endOfList - _nextPageTreshold && nextPage != null)
          nextPage();

        // Leading widgets
        if (index < leadLength) return leading[index];

        int realIdx = reverse ? endOfList + leadLength - index - 1 : index;
        // Trailing load indicator (only if loading a new page)
        if (realIdx == endOfList)
          return Center(heightFactor: 3.0, child: CircularProgressIndicator());

        // Real card list
        Book book = bookList.getAt(realIdx - leadLength);
        return BookCard(
          book: book,
          exchange: exchange,
          wished: wishMap[book],
          showOwner: showOwner,
        );
      },
    );
  }
}
