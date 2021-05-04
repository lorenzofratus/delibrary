import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/exchange.dart';
import 'package:delibrary/src/routes/book-info.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final Exchange exchange;
  final bool wished;
  final bool showOwner;

  BookCard(
      {@required this.book,
      this.exchange,
      this.wished = false,
      this.showOwner = false});

  void _tappedBook(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookInfoPage(
          book: book,
          exchange: exchange,
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
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: book.smallImage,
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    flex: 6,
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BookInfo(text: book.title, bold: true),
                        _BookInfo(text: book.authors),
                        _BookInfo(text: book.publishedInfo, italic: true),
                        if (showOwner && book.property != null)
                          _BookInfo(
                            text: book.property.ownerUsername,
                            icon: Icons.person,
                          ),
                        if (showOwner && book.property != null)
                          _BookInfo(
                            text: book.property.positionString,
                            icon: Icons.place,
                          ),
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
        child: book.smallImage,
      ),
    );
  }
}

class _BookInfo extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool bold;
  final bool italic;

  _BookInfo({
    this.text = "",
    this.icon,
    this.bold = false,
    this.italic = false,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          if (icon != null)
            WidgetSpan(
              child: Icon(
                icon,
                size: Theme.of(context).textTheme.headline6.fontSize,
                color: Theme.of(context).accentColor,
              ),
            ),
          TextSpan(
            text: (icon != null ? " " : "") + text,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: italic ? FontStyle.italic : FontStyle.normal,
                ),
          ),
        ],
      ),
    );
  }
}
