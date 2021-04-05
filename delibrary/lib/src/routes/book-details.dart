import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/model/action.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/shortcuts/padded-list-view.dart';
import 'package:flutter/material.dart';

class BookDetailsPage extends StatelessWidget {
  final Book book;
  final DelibraryAction primaryAction;
  final DelibraryAction secondaryAction;

  const BookDetailsPage(
      {Key key, this.book, this.primaryAction, this.secondaryAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String bookPubData = [book.publisher, book.publishedYear]
        .where((d) => d.isNotEmpty)
        .join(",");
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: false,
              expandedHeight: MediaQuery.of(context).size.height * 0.4,
              title: DelibraryLogo(),
              flexibleSpace: FlexibleSpaceBar(
                background: book.largeImage,
              ),
            )
          ];
        },
        body: PaddedListView(
          children: [
            if (book.title.isNotEmpty) _BookInfo(book.title, bold: true),
            if (book.authors.isNotEmpty) _BookInfo(book.authors),
            if (bookPubData.isNotEmpty) _BookInfo(bookPubData, italic: true),
            if (book.description.isNotEmpty)
              Text(
                book.description,
                style: Theme.of(context).textTheme.headline6,
              ),
            if (primaryAction.text.isNotEmpty)
              DelibraryButton(
                text: primaryAction.text,
                onPressed: () {
                  primaryAction.execute(context);
                },
              ),
            if (secondaryAction.text.isNotEmpty)
              DelibraryButton(
                text: secondaryAction.text,
                primary: false,
                onPressed: () {
                  secondaryAction.execute(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _BookInfo extends StatelessWidget {
  final String text;
  final bool bold;
  final bool italic;

  _BookInfo(this.text, {this.bold = false, this.italic = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline5.copyWith(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            ),
      ),
    );
  }
}
