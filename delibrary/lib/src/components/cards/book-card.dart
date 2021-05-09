import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/routes/book-info.dart';
import 'package:flutter/material.dart';

import 'item-card.dart';

class BookCard extends ItemCard<Book> {
  final Exchange exchange;
  final bool wished;
  final bool showOwner;

  BookCard(
      {@required Book book,
      bool preview,
      this.exchange,
      this.wished = false,
      this.showOwner = false})
      : super(item: book, preview: preview);

  @override
  Widget getInfoPage(BuildContext context) {
    return BookInfoPage(book: item, exchange: exchange, wished: wished);
  }

  @override
  Widget getCardChild(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Row(
          children: [
            getImage(context, item.smallImage),
            Spacer(),
            Flexible(
              flex: imageFlex * 2,
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getText(context, item.title, bold: true),
                  getText(context, item.authors),
                  getText(context, item.publishedInfo, italic: true),
                  if (showOwner && item.property != null)
                    getText(
                      context,
                      item.property.ownerUsername,
                      icon: Icons.person,
                    ),
                  if (showOwner && item.property != null)
                    getText(
                      context,
                      item.property.positionString,
                      icon: Icons.place,
                    ),
                ],
              ),
            ),
          ],
        ),
        if (wished) Icon(Icons.favorite, color: Theme.of(context).accentColor),
      ],
    );
  }

  @override
  Widget getPreviewChild(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: item.smallImage,
    );
  }
}
