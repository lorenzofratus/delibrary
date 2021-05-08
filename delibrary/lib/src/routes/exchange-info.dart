import 'package:delibrary/src/components/book-cards-list.dart';
import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/custom-app-bar.dart';
import 'package:delibrary/src/components/draggable-modal-page.dart';
import 'package:delibrary/src/components/info-fields.dart';
import 'package:delibrary/src/controller/internal/exchange-services.dart';
import 'package:delibrary/src/controller/internal/property-services.dart';
import 'package:delibrary/src/model/utils/action.dart';
import 'package:delibrary/src/model/primary/book-list.dart';
import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:flutter/material.dart';

class ExchangeInfoPage extends StatelessWidget {
  final Exchange exchange;

  final ExchangeServices _exchangeServices = ExchangeServices();
  final PropertyServices _propertyServices = PropertyServices();

  ExchangeInfoPage({@required this.exchange}) : assert(exchange != null);

  void _chooseBook(BuildContext context) async {
    Future<BookList> bookList = _propertyServices.getPropertiesOf(
      context,
      exchange.otherUsername,
    );
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Scaffold(
        // Scaffold is here as a workaround to display snackbars above the bottom sheet
        backgroundColor: Colors.transparent,
        body: FutureBuilder(
          future: bookList,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return DraggableModalPage(
                builder: (context, scrollController) => BookCardsList(
                  controller: scrollController,
                  bookList: snapshot.data,
                  exchange: exchange,
                  reverse: true,
                  leading: [
                    Container(
                      margin:
                          EdgeInsets.only(top: 30.0, left: 40.0, right: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // To keep the title centered
                          IconButton(
                            icon: Icon(Icons.close),
                            disabledColor: Colors.transparent,
                            onPressed: null,
                          ),
                          Flexible(
                            child: Text(
                              "I libri di " + exchange.otherUsername,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    color: Theme.of(context).accentColor,
                                  ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            else
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
          },
        ),
      ),
    );
  }

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
              DelibraryAction(text: "Scegli un libro", execute: _chooseBook);
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
                InfoChips(
                  title: "Altro utente",
                  data: {
                    exchange.otherUsername: InfoDataType.user,
                  },
                ),
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
