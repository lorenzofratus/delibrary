import 'dart:math';

import 'package:delibrary/src/components/utils/button.dart';
import 'package:delibrary/src/components/ui-elements/empty-list-sign.dart';
import 'package:delibrary/src/components/sections/container.dart';
import 'package:delibrary/src/components/modals/list-expander.dart';
import 'package:delibrary/src/model/primary/item-list.dart';
import 'package:delibrary/src/model/primary/item.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemsSectionContainer extends SectionContainer {
  final ItemList Function(BuildContext) provider;

  ItemsSectionContainer({
    String title = "",
    @required this.provider,
  })  : assert(provider != null),
        super(title: title, children: [
          _ItemsChildren(title: title, provider: provider),
        ]);
}

class _ItemsChildren extends StatelessWidget {
  final String title;
  final ItemList Function(BuildContext) provider;

  _ItemsChildren({this.title = "", @required this.provider});

  @override
  Widget build(BuildContext context) {
    ItemList itemList = provider(context);

    if (itemList?.isEmpty ?? true)
      return EmptyListSign(
        large: false,
        buttonText: "Vedi tutti",
      );

    Map<Item, bool> wishedMap =
        itemList.getWishedMap(context.read<Session>().wishes);

    return Column(
      children: [
        GridView.builder(
          padding: EdgeInsets.only(top: 30.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 30.0,
          ),
          primary: false,
          shrinkWrap: true,
          itemCount: min(itemList.length, 2),
          itemBuilder: (context, index) {
            int reverseIdx = itemList.length - index - 1;
            Item item = itemList?.getAt(reverseIdx);
            return item.getCard(
              preview: true,
              wished: wishedMap[item],
            );
          },
        ),
        DelibraryButton(
          onPressed: () => ListExpander.display(
              context, title, (context) async => provider(context)),
          text: "Vedi tutti",
        ),
      ],
    );
  }
}
