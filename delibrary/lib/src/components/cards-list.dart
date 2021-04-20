import 'package:delibrary/src/components/card.dart';
import 'package:delibrary/src/components/empty-list-sign.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardsList extends StatelessWidget {
  final BookList bookList;
  final ScrollController controller;
  final bool reverse;
  final void Function() nextPage;
  final int _nextPageTreshold = 3;

  CardsList({
    @required this.bookList,
    this.controller,
    this.reverse = false,
    this.nextPage,
  });

  @override
  Widget build(BuildContext context) {
    if (bookList?.isEmpty ?? true) return EmptyListSign();

    BookList wishList = context.read<Session>().wishes;
    Map<Book, bool> wishMap = bookList.intersect(wishList);

    return ListView.builder(
      controller: controller,
      itemCount: bookList.length + (bookList.isComplete ? 0 : 1),
      itemBuilder: (context, index) {
        if (index == bookList.length - _nextPageTreshold && nextPage != null)
          nextPage();

        int realIdx = reverse ? bookList.length - index - 1 : index;
        if (realIdx == bookList.length)
          return Center(heightFactor: 3.0, child: CircularProgressIndicator());

        Book book = bookList.getAt(realIdx);
        return BookCard(book: book, wished: wishMap[book]);
      },
    );
  }
}
