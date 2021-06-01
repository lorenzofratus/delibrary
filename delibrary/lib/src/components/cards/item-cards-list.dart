import 'package:delibrary/src/components/ui-elements/empty-list-sign.dart';
import 'package:delibrary/src/model/primary/book-list.dart';
import 'package:delibrary/src/model/primary/exchange-list.dart';
import 'package:delibrary/src/model/primary/item-list.dart';
import 'package:delibrary/src/model/primary/item.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

class ItemCardsList<T extends ItemList> extends StatelessWidget {
  final T itemList;
  final ScrollController controller;
  final bool reverse;
  final bool tappable;
  final List<Widget> leading;

  //Optional
  final void Function() nextPage;
  final int nextPageTreshold = 3;
  final bool showOwner;

  ItemCardsList({
    @required this.itemList,
    this.controller,
    this.reverse = false,
    this.tappable = true,
    this.leading,
    this.nextPage,
    this.showOwner = false,
  });

  int get leadingLength => leading?.length ?? 0;
  int get endOfList => leadingLength + itemList.length;

  @override
  Widget build(BuildContext context) {
    if (itemList?.isEmpty ?? true)
      return ListView(
        controller: controller,
        children: [
          if (leading != null) ...leading,
          EmptyListSign(),
        ],
      );

    Map<Item, bool> wishedMap =
        itemList.getWishedMap(context.read<Session>().wishes);

    final int count = context.layout.value(xs: 1, sm: 2, md: 3);
    final double extent = itemList is BookList
        ? 180.0 // BookCard height
        : itemList is ExchangeList
            ? 230.0 // ExchangeCard height
            : 0.0;

    return CustomScrollView(
      controller: controller,
      slivers: [
        if (leading != null && leading.length > 0)
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(leading),
            ),
          ),
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: extent,
              mainAxisSpacing: 20.0,
              crossAxisCount: count,
              crossAxisSpacing: 40.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Check when to load next page
                if (index == endOfList - nextPageTreshold && nextPage != null)
                  nextPage();

                int realIdx = reverse ? itemList.length - index - 1 : index;

                Item item = itemList.getAt(realIdx);
                return item.getCard(
                  wished: wishedMap[item],
                  tappable: tappable,
                  showOwner: showOwner,
                  parent: itemList.parent,
                );
              },
              childCount: itemList.length,
            ),
          ),
        ),
        if (!itemList.isComplete)
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(bottom: 40.0),
              child: Center(
                heightFactor: 3.0,
                child: CircularProgressIndicator(),
              ),
            ),
          )
      ],
    );
  }
}
