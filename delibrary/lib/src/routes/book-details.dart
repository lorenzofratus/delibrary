import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:flutter/material.dart';

class BookPage extends StatelessWidget {
  final Book book;
  final String primaryActionText;
  final String secondaryActionText;

  BookPage({
    @required this.book,
    this.primaryActionText = "",
    this.secondaryActionText = "",
  });

  @override
  Widget build(BuildContext context) {
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
                background: this.book.large,
              ),
            )
          ];
        },
        body: ListView(
          padding: EdgeInsets.all(50.0),
          children: [
            if (this.book.title.isNotEmpty)
              _BookInfo(this.book.title, bold: true),
            if (this.book.authors.isNotEmpty) _BookInfo(this.book.authors),
            if (this.book.publisher.isNotEmpty ||
                this.book.publishedYear.isNotEmpty)
              _BookInfo(
                  [book.publisher, book.publishedYear]
                      .where((x) => x.isNotEmpty)
                      .join(", "),
                  italic: true),
            if (this.book.description.isNotEmpty)
              Text(
                this.book.description,
                style: Theme.of(context).textTheme.headline6,
              ),
            if (this.primaryActionText.isNotEmpty)
              DelibraryButton(
                text: this.primaryActionText,
                onPressed: () => {Navigator.pop(context, 1)},
              ),
            if (this.secondaryActionText.isNotEmpty)
              DelibraryButton(
                text: this.secondaryActionText,
                primary: false,
                onPressed: () => {Navigator.pop(context, 2)},
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
        this.text,
        style: Theme.of(context).textTheme.headline5.copyWith(
              fontWeight: this.bold ? FontWeight.bold : FontWeight.normal,
              fontStyle: this.italic ? FontStyle.italic : FontStyle.normal,
            ),
      ),
    );
  }
}
