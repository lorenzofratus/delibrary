import 'package:delibrary/src/components/book-cards-list.dart';
import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/custom-app-bar.dart';
import 'package:delibrary/src/components/info-fields.dart';
import 'package:delibrary/src/controller/exchange-services.dart';
import 'package:delibrary/src/model/action.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/exchange.dart';
import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:flutter/material.dart';

class ExchangeInfoPage extends StatelessWidget {
  final Exchange exchange;

  final ExchangeServices _exchangeServices = ExchangeServices();

  ExchangeInfoPage({@required this.exchange}) : assert(exchange != null);

  @override
  Widget build(BuildContext context) {
    List<Book> items =
        [exchange.property, exchange.payment].where((b) => b != null).toList();
    BookList bookList = BookList(items: items, totalItems: items.length);

    DelibraryAction primaryAction, secondaryAction;
    switch (exchange.status) {
      case ExchangeStatus.proposed:
        if (exchange.isBuyer) {
          secondaryAction = _exchangeServices.remove(exchange);
        } else {
          //TODO: display list of books
          primaryAction =
              DelibraryAction(text: "Scegli un libro", execute: (context) {});
          secondaryAction = _exchangeServices.refuse(exchange);
        }
        break;
      case ExchangeStatus.agreed:
        primaryAction = _exchangeServices.happen(exchange);
        secondaryAction = _exchangeServices.refuse(exchange);
        break;
      default:
        break;
    }

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Theme.of(context).primaryColor,
      body: BookCardsList(
        bookList: bookList,
        showOwner: true,
        leading: [
          PaddedContainer(
            child: Column(
              children: [
                InfoTitle(exchange.status.string),
                InfoDescription(exchange.status.description),
                if (primaryAction != null)
                  DelibraryButton(
                    text: primaryAction.text,
                    onPressed: () => primaryAction.execute(context),
                  ),
                if (secondaryAction != null)
                  DelibraryButton(
                    text: secondaryAction.text,
                    onPressed: () => secondaryAction.execute(context),
                    primary: false,
                  ),
              ],
            ),
          ),
          InfoTitle("Libri coinvolti", false),
        ],
      ),
    );
  }
}
