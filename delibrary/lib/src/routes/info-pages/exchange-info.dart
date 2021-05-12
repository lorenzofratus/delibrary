import 'package:delibrary/src/components/cards/item-cards-list.dart';
import 'package:delibrary/src/components/utils/info-fields.dart';
import 'package:delibrary/src/components/modals/list-expander.dart';
import 'package:delibrary/src/model/utils/action.dart';
import 'package:delibrary/src/model/primary/book-list.dart';
import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/routes/info-pages/item-info.dart';
import 'package:delibrary/src/components/utils/padded-container.dart';
import 'package:flutter/material.dart';

class ExchangeInfoPage extends ItemInfoPage<Exchange> {
  ExchangeInfoPage({@required Exchange item})
      : super(item: item, wished: false, parent: null);

  @override
  State<StatefulWidget> createState() => _ExchangeInfoPageState(item);
}

class _ExchangeInfoPageState extends ItemInfoPageState<Exchange> {
  BookList bookList;

  _ExchangeInfoPageState(Exchange item) : super(item);

  DelibraryAction get _chooseBook => DelibraryAction(
        text: "Scegli un libro",
        execute: (context) => ListExpander.display(
          context,
          "I libri di " + item.otherUsername,
          (context) =>
              propertyServices.getPropertiesFromExchange(context, item),
        ),
      );

  @override
  void setup(BuildContext context) {
    List<Book> items =
        [item.property, item.payment].where((b) => b != null).toList();
    bookList = BookList(items: items, totalItems: items.length);
  }

  @override
  void computeActions(BuildContext context) {
    switch (item.status) {
      case ExchangeStatus.proposed:
        if (item.isBuyer) {
          addAction(exchangeServices.remove(item));
        } else {
          addAction(_chooseBook);
          addAction(exchangeServices.refuse(item));
        }
        break;
      case ExchangeStatus.agreed:
        addAction(exchangeServices.happen(item));
        addAction(exchangeServices.refuse(item));
        break;
      default:
        break;
    }
  }

  @override
  Widget getContent(BuildContext context, ScrollController scrollController) {
    return ItemCardsList<BookList>(
      controller: scrollController,
      itemList: bookList,
      showOwner: true,
      leading: [
        PaddedContainer(
          child: Column(
            children: [
              InfoTitle(item.status.string),
              InfoDescription(item.status.description),
              InfoChips(
                title: "Altro utente",
                data: {
                  item.otherUsername: InfoDataType.user,
                  item.otherEmail: InfoDataType.email,
                },
              ),
              ...getButtons(context),
            ],
          ),
        ),
        InfoTitle("Libri coinvolti", false),
      ],
    );
  }
}
