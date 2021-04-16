import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/routes/book-info.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final bool wished;

  BookCard({@required this.book, this.wished = false});

  void _tappedBook(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookInfoPage(
          book: book,
          wished: wished,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (book == null) return null;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: () => _tappedBook(context),
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Row(
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
                        _BookInfo(text: book.title, bold: true),
                        _BookInfo(text: book.authors),
                        _BookInfo(text: book.publishedInfo, italic: true),
                      ],
                    ),
                  ),
                ],
              ),
              if (wished)
                Icon(
                  Icons.favorite,
                  color: Theme.of(context).accentColor,
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
  final bool wished;

  BookCardPreview({@required this.book, this.wished = false});

  void _tappedBook(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookInfoPage(
          book: book,
          wished: wished,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (book == null) return null;
    return InkWell(
      onTap: () => _tappedBook(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: book.previewImage,
      ),
    );
  }
}

class _BookInfo extends StatelessWidget {
  final String text;
  final bool bold;
  final bool italic;

  _BookInfo({this.text = "", this.bold = false, this.italic = false});

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
