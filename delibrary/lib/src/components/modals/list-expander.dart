import 'package:delibrary/src/components/cards/item-cards-list.dart';
import 'package:delibrary/src/components/modals/draggable-modal-page.dart';
import 'package:delibrary/src/model/primary/item-list.dart';
import 'package:flutter/material.dart';

class ListExpander {
  static void display(BuildContext context, String title,
      Future<ItemList> Function(BuildContext) asyncProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Scaffold(
        // Scaffold is here as a workaround to display snackbars above the bottom sheet
        backgroundColor: Colors.transparent,
        body: FutureBuilder(
          future: asyncProvider(context),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return DraggableModalPage(
                builder: (context, scrollController) => ItemCardsList<ItemList>(
                  controller: scrollController,
                  itemList: snapshot.data,
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
                              title ?? "",
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
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
