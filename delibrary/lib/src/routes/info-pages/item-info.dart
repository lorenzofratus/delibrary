import 'package:delibrary/src/components/utils/button.dart';
import 'package:delibrary/src/components/ui-elements/custom-app-bar.dart';
import 'package:delibrary/src/components/modals/draggable-modal-page.dart';
import 'package:delibrary/src/controller/internal/exchange-services.dart';
import 'package:delibrary/src/controller/internal/property-services.dart';
import 'package:delibrary/src/controller/internal/wish-services.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/model/primary/item.dart';
import 'package:delibrary/src/model/utils/action.dart';
import 'package:flutter/material.dart';

abstract class ItemInfoPage<T extends Item> extends StatefulWidget {
  final T item;
  final bool wished;

  // "parent" is not null only if this is a book of another user involved in an exchange
  final Exchange parent;

  ItemInfoPage({@required this.item, this.wished = false, this.parent})
      : assert(item != null);
}

abstract class ItemInfoPageState<T extends Item> extends State<ItemInfoPage> {
  final ExchangeServices exchangeServices = ExchangeServices();
  final PropertyServices propertyServices = PropertyServices();
  final WishServices wishServices = WishServices();

  final T item;
  List<DelibraryAction> actions = [];

  ItemInfoPageState(this.item);

  void addAction(DelibraryAction action) {
    if (action != null) actions.add(action);
  }

  List<Widget> getButtons(BuildContext context) {
    List<Widget> buttons = [];
    for (DelibraryAction action in actions)
      buttons.add(DelibraryButton(
        text: action.text,
        onPressed: () => action.execute(context),
        primary: actions.indexOf(action) == 0,
      ));
    return buttons;
  }

  void setup(BuildContext context);

  void computeActions(BuildContext context);

  Widget getContent(BuildContext context, ScrollController scrollController);

  @override
  Widget build(BuildContext context) {
    setup(context);
    computeActions(context);
    return Scaffold(
      appBar: CustomAppBar(),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.65,
            child: item.backgroundImage,
          ),
          if (widget.wished)
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
          DraggableModalPage(builder: getContent),
        ],
      ),
    );
  }
}
