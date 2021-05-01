import 'package:delibrary/src/components/empty-list-sign.dart';
import 'package:delibrary/src/components/exchange-card.dart';
import 'package:delibrary/src/model/exchange-list.dart';
import 'package:delibrary/src/model/exchange.dart';
import 'package:flutter/material.dart';

class ExchangeCardsList extends StatelessWidget {
  final ExchangeList exchangeList;
  final ScrollController controller;
  final bool reverse;
  final List<Widget> leading;

  ExchangeCardsList({
    @required this.exchangeList,
    this.controller,
    this.reverse = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    int leadLength = leading?.length ?? 0;
    int endOfList = leadLength + exchangeList.length;

    if (exchangeList?.isEmpty ?? true)
      return ListView(
        controller: controller,
        children: [
          if (leading != null) ...leading,
          EmptyListSign(),
        ],
      );

    return ListView.builder(
      controller: controller,
      itemCount: endOfList,
      itemBuilder: (context, index) {
        // Leading widgets
        if (index < leadLength) return leading[index];

        int realIdx = reverse ? endOfList + leadLength - index - 1 : index;
        // Real card list
        Exchange exchange = exchangeList.getAt(realIdx - leadLength);
        return ExchangeCard(exchange: exchange);
      },
    );
  }
}
