import 'package:delibrary/src/components/cards/item-card.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/routes/exchange-info.dart';
import 'package:flutter/material.dart';

class ExchangeCard extends ItemCard<Exchange> {
  ExchangeCard({
    @required Exchange exchange,
    bool preview,
  }) : super(item: exchange, preview: preview);

  @override
  Widget getInfoPage(BuildContext context) {
    return ExchangeInfoPage(exchange: item);
  }

  @override
  Widget getCardChild(BuildContext context) {
    return Row(
      children: [
        getImage(context, item.myBookImage, "Cedi"),
        Spacer(),
        Flexible(
          flex: imageFlex - 1,
          fit: FlexFit.tight,
          child: FittedBox(
            child: Icon(
              Icons.swap_horiz,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        Spacer(),
        getImage(context, item.otherBookImage, "Ricevi"),
      ],
    );
  }

  @override
  Widget getPreviewChild(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: item.isBuyer ? item.otherBookImage : item.myBookImage,
          ),
        ),
        FloatingActionButton(
          heroTag: null,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).accentColor,
          onPressed: null,
          child: Icon(item.isBuyer ? Icons.login : Icons.logout),
          mini: true,
        ),
      ],
    );
  }
}
