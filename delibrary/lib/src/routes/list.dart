import 'package:delibrary/src/components/cards-list.dart';
import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/components/page-title.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:delibrary/src/shortcuts/refreshable.dart';
import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  final String title;
  final BookList bookList;
  final Function onTap;
  final Function onRefresh;

  ListPage(
      {this.title = "", @required this.bookList, this.onTap, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: DelibraryLogo()),
      body: Refreshable(
        onRefresh: onRefresh,
        child: Column(
          children: [
            PaddedContainer(child: PageTitle(title)),
            Expanded(
              child: CardsList(
                booksList: bookList,
                onTap: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
