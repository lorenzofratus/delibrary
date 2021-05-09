import 'dart:math';

import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/cards/item-cards-list.dart';
import 'package:delibrary/src/components/draggable-modal-page.dart';
import 'package:delibrary/src/components/empty-list-sign.dart';
import 'package:delibrary/src/components/sections/container.dart';
import 'package:delibrary/src/model/primary/item-list.dart';
import 'package:delibrary/src/model/primary/item.dart';
import 'package:flutter/material.dart';

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

  void _expandSection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Scaffold(
        // Scaffold is here as a workaround to display snackbars above the bottom sheet
        backgroundColor: Colors.transparent,
        body: DraggableModalPage(
          builder: (context, scrollController) => ItemCardsList(
            controller: scrollController,
            itemList: provider(context),
            reverse: true,
            leading: [_ExpandedLeading(title)],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ItemList itemList = provider(context);

    if (itemList?.isEmpty ?? true) return EmptyListSign(large: false);

    Map<Item, bool> wishedMap = itemList.getWishedMap(context);

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
          onPressed: () => _expandSection(context),
          text: "Vedi tutti",
        ),
      ],
    );
  }
}

class _ExpandedLeading extends StatelessWidget {
  final String title;

  _ExpandedLeading([this.title = ""]);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0, left: 40.0, right: 40.0),
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
              title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline5.copyWith(
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
    );
  }
}
