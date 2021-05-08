import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/custom-app-bar.dart';
import 'package:delibrary/src/components/draggable-modal-page.dart';
import 'package:delibrary/src/components/info-fields.dart';
import 'package:delibrary/src/controller/exchange-services.dart';
import 'package:delibrary/src/controller/property-services.dart';
import 'package:delibrary/src/controller/wish-services.dart';
import 'package:delibrary/src/model/utils/action.dart';
import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:delibrary/src/shortcuts/padded-list-view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookInfoPage extends StatelessWidget {
  final Book book;
  final Exchange exchange;
  final bool wished;

  final PropertyServices _propertyServices = PropertyServices();
  final WishServices _wishServices = WishServices();
  final ExchangeServices _exchangeServices = ExchangeServices();

  BookInfoPage({@required this.book, this.exchange, this.wished = false})
      : assert(book != null);

  @override
  Widget build(BuildContext context) {
    String username = context.read<Session>().user.username;
    bool hasExchange = context.read<Session>().hasActiveExchange(book);
    bool hasProperty = book.property != null;
    bool userProperty = hasProperty && book.property.ownerUsername == username;
    bool hasWish = book.wish != null;
    bool userWish = hasWish && book.wish.ownerUsername == username;

    DelibraryAction primaryAction, secondaryAction;
    String alert;

    if (exchange != null) {
      primaryAction = _exchangeServices.agree(exchange, book);
    } else if (hasProperty) {
      if (userProperty) {
        // Property of current user
        primaryAction = _propertyServices.removeProperty(book);
        secondaryAction = _propertyServices.movePropertyToWishList(book);
        if (hasExchange) alert = "Questo libro è richiesto per uno scambio";
      } else {
        if (hasExchange)
          alert = "Questo libro è coinvolto in uno scambio attivo";
        else {
          // Property of another user, no active exchange
          primaryAction = _exchangeServices.propose(book.property);
          secondaryAction = _propertyServices.addProperty(book);
        }
      }
    } else if (userWish) {
      // Wish of current user
      primaryAction = _wishServices.removeWish(book);
      secondaryAction = _wishServices.moveWishToLibrary(book);
    } else {
      // Global search
      primaryAction = _propertyServices.addProperty(book);
      secondaryAction = _wishServices.addWish(book);
    }

    return Scaffold(
      appBar: CustomAppBar(),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.65,
            child: book.largeImage,
          ),
          if (wished)
            Positioned(
              top: 15.0,
              right: 15.0,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Theme.of(context).accentColor,
                child: Icon(Icons.favorite),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Il libro è nella wishlist"),
                    ),
                  );
                },
              ),
            ),
          DraggableModalPage(
            builder: (context, scrollController) => PaddedListView(
              extraPadding: true,
              controller: scrollController,
              children: [
                // Book information
                InfoTitle(book.title),
                if (book.subtitle.isNotEmpty) InfoTitle(book.subtitle, false),
                if (book.description.isNotEmpty)
                  InfoDescription(book.description),

                if (book.hasDetails)
                  InfoChips(
                    title: "Dettagli volume",
                    data: {
                      for (String author in book.authorsList)
                        author: InfoDataType.author,
                      if (book.publisher.isNotEmpty)
                        book.publisher: InfoDataType.publisher,
                      if (book.publishedDate.isNotEmpty)
                        book.publishedDate: InfoDataType.date,
                    },
                  ),

                // Property information
                if (hasProperty && !userProperty)
                  InfoChips(
                    title: "Dettagli copia fisica",
                    data: {
                      book.property.ownerUsername: InfoDataType.user,
                      book.property.positionString: InfoDataType.position,
                    },
                  ),

                // Active exchange alert
                if (alert != null)
                  PaddedContainer(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      alert,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Possible actions on the book
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
        ],
      ),
    );
  }
}
