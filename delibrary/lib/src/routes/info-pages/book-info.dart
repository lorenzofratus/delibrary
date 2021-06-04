import 'package:delibrary/src/components/utils/info-fields.dart';
import 'package:delibrary/src/components/utils/padded-grid.dart';
import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:delibrary/src/routes/info-pages/item-info.dart';
import 'package:delibrary/src/components/utils/padded-container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookInfoPage extends ItemInfoPage<Book> {
  BookInfoPage({@required Book item, bool wished = false, Exchange parent})
      : super(item: item, wished: wished, parent: parent);

  @override
  State<StatefulWidget> createState() => _BookInfoPageState(item);
}

class _BookInfoPageState extends ItemInfoPageState<Book> {
  String alert;
  String username = '';
  bool hasExchange = false;
  bool userProperty = false;
  bool userWish = false;

  _BookInfoPageState(Book item) : super(item);

  @override
  void setup(BuildContext context) {
    username = context.read<Session>()?.user?.username;
    hasExchange = context.read<Session>()?.hasActiveExchange(item) ?? false;
    userProperty = item.hasProperty && item.userProperty(username);
    userWish = item.hasWish && item.userWish(username);
  }

  @override
  void computeActions(BuildContext context) {
    if (widget.parent != null) {
      addAction(exchangeServices.agree(widget.parent, item));
    } else if (item.hasProperty) {
      if (userProperty) {
        // Property of current user
        addAction(propertyServices.removeProperty(item));
        addAction(propertyServices.movePropertyToWishList(item));
        addAction(propertyServices.changePropertyPosition(item));
        if (hasExchange) alert = "Questo libro è richiesto per uno scambio";
      } else {
        if (hasExchange)
          alert = "Questo libro è coinvolto in uno scambio attivo";
        else {
          // Property of another user, no active exchange
          addAction(exchangeServices.propose(item.property));
          // addAction(propertyServices.addProperty(item));
        }
      }
    } else if (userWish) {
      // Wish of current user
      addAction(wishServices.removeWish(item));
      addAction(wishServices.moveWishToLibrary(item));
    } else {
      // Global search
      addAction(propertyServices.addProperty(item));
      addAction(wishServices.addWish(item));
    }
  }

  @override
  Widget getContent(BuildContext context, ScrollController scrollController) {
    return PaddedGrid(
      controller: scrollController,
      grid: false,
      maxWidth: 500.0,
      leading: [
        InfoTitle(item.title),
        if (item.subtitle.isNotEmpty) InfoTitle(item.subtitle, false),
      ],
      children: [
        if (item.description.isNotEmpty) InfoDescription(item.description),
        if (item.hasDetails)
          InfoChips(
            title: "Dettagli volume",
            data: {
              for (String author in item.authorsList)
                author: InfoDataType.author,
              if (item.publisher.isNotEmpty)
                item.publisher: InfoDataType.publisher,
              if (item.publishedDate.isNotEmpty)
                item.publishedDate: InfoDataType.date,
            },
          ),
        if (userProperty)
          InfoChips(
            title: "Dettagli copia fisica",
            data: {
              item.property.ownerUsername: InfoDataType.user,
              item.property.positionString: InfoDataType.position,
            },
          ),
        if (alert != null)
          PaddedContainer(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 30.0,
                  color: Theme.of(context).accentColor,
                ),
                Text(
                  alert,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ...getButtons(context),
      ],
    );
  }
}
