import 'package:delibrary/src/components/ui-elements/empty-list-sign.dart';
import 'package:delibrary/src/model/primary/item-list.dart';
import 'package:delibrary/src/model/primary/item.dart';
import 'package:flutter/material.dart';

class ItemCardsList<T extends ItemList> extends StatelessWidget {
  final T itemList;
  final ScrollController controller;
  final bool reverse;
  final List<Widget> leading;

  //Optional
  final void Function() nextPage;
  final int nextPageTreshold = 3;
  final bool showOwner;

  ItemCardsList({
    @required this.itemList,
    this.controller,
    this.reverse = false,
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

    Map<Item, bool> wishedMap = itemList.getWishedMap(context);

    return ListView.builder(
      controller: controller,
      itemCount: endOfList + (itemList.isComplete ? 0 : 1),
      itemBuilder: (context, index) {
        // Check when to load next page
        if (index == endOfList - nextPageTreshold && nextPage != null)
          nextPage();

        // Leading widgets
        if (index < leadingLength) return leading[index];

        int realIdx = reverse ? endOfList + leadingLength - index - 1 : index;
        // Trailing load indicator (only if loading a new page)
        if (realIdx == endOfList)
          return Center(heightFactor: 3.0, child: CircularProgressIndicator());

        // Real card list
        Item item = itemList.getAt(realIdx - leadingLength);
        return item.getCard(
          wished: wishedMap[item],
          showOwner: showOwner,
          parent: itemList.parent,
        );
      },
    );
  }
}
