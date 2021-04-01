import 'package:delibrary/src/model/book.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final Function onTap;

  BookCard({@required this.book, this.onTap});

  void _tappedBook() {
    if (onTap != null) onTap(book);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: _tappedBook,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  child: book.smallImage,
                  width: MediaQuery.of(context).size.width * 0.2,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                width: MediaQuery.of(context).size.width * 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BookInfo(book.title, bold: true),
                    _BookInfo(book.authors),
                    _BookInfo(
                        [book.publisher, book.publishedYear]
                            .where((x) => x.isNotEmpty)
                            .join(", "),
                        italic: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookCardPreview extends StatelessWidget {
  final Book book;
  final Function onTap;

  BookCardPreview({this.book, this.onTap});

  void _tappedBook() {
    if (onTap != null && book != null) onTap(book);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _tappedBook,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: book != null ? book.previewImage : Book.placeholderPreviewImage,
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
    return Text(
      text,
      style: Theme.of(context).textTheme.headline6.copyWith(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
