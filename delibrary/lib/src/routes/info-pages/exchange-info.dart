import 'dart:math';

import 'package:delibrary/src/components/cards/book-card.dart';
import 'package:delibrary/src/components/utils/info-fields.dart';
import 'package:delibrary/src/components/modals/list-expander.dart';
import 'package:delibrary/src/components/utils/padded-grid.dart';
import 'package:delibrary/src/controller/services.dart';
import 'package:delibrary/src/model/utils/action.dart';
import 'package:delibrary/src/model/primary/book-list.dart';
import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/routes/info-pages/item-info.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExchangeInfoPage extends ItemInfoPage<Exchange> {
  ExchangeInfoPage({@required Exchange item})
      : super(item: item, wished: false, parent: null);

  @override
  State<StatefulWidget> createState() => _ExchangeInfoPageState(item);
}

class _ExchangeInfoPageState extends ItemInfoPageState<Exchange> {
  bool tappable = true;
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

  void _launchEmail(BuildContext context) async {
    final Uri params = Uri(
      scheme: "mailto",
      path: item.otherEmail,
      query:
          'subject=[Delibrary] Nuovo Scambio&body=Ciao ${item.otherUsername},\n\nTi contatto riguardo al nostro scambio su Delibrary.\nIl mio libro: ${item.myBookTitle}\nIl tuo libro: ${item.otherBookTitle}\n',
    );
    String url = params.toString();
    if (await canLaunch(url))
      await launch(url);
    else
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(ErrorMessage.cannotOpenEmail)));
  }

  @override
  void setup(BuildContext context) {
    List<Book> items =
        [item.property, item.payment].where((b) => b != null).toList();
    bookList = BookList(items: items, totalItems: items.length);
    tappable = !item.isArchived;
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
    final double maxWidth = 500.0;
    final double bookWidth = 400.0;
    final double columnWidth = min(MediaQuery.of(context).size.width, maxWidth);
    final double booksPad = max((columnWidth - bookWidth) / 2, 0.0);
    return PaddedGrid(
      controller: scrollController,
      grid: false,
      maxWidth: 500.0,
      leading: [
        InfoTitle(item.title),
      ],
      children: [
        InfoDescription(item.description),
        InfoChips(
          title: "Altro utente",
          data: {
            item.otherUsername: InfoDataType.user,
          },
        ),
        if (item.isAgreed)
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: InkWell(
              onTap: () => _launchEmail(context),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    InfoTitleSmall("Contatta ${item.otherUsername}"),
                    InfoTitleSmall(item.otherEmail, false),
                  ],
                ),
              ),
            ),
          ),
        ...getButtons(context),
        SizedBox(height: 60.0),
        InfoTitle("Libri coinvolti", false),
        ...bookList.items
            .map(
              (e) => Container(
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: booksPad,
                ),
                child: BookCard(
                  book: e,
                  showOwner: true,
                  tappable: tappable,
                  preview: false,
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
