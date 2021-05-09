import 'package:delibrary/src/model/primary/item.dart';
import 'package:flutter/material.dart';

abstract class ItemCard<T extends Item> extends StatelessWidget {
  final T item;
  final bool preview;
  final int imageFlex = 3;

  ItemCard({@required this.item, this.preview = false});

  void _tappedItem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: getInfoPage),
    );
  }

  Widget getInfoPage(BuildContext context);
  Widget getCardChild(BuildContext context);
  Widget getPreviewChild(BuildContext context);

  Widget getImage(BuildContext context, Widget image, [String title]) {
    return Flexible(
      flex: imageFlex,
      fit: FlexFit.tight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Theme.of(context).accentColor,
                  ),
            ),
          if (title != null) SizedBox(height: 10.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: image,
          ),
        ],
      ),
    );
  }

  Widget getText(BuildContext context, String text,
      {IconData icon, bool bold = false, bool italic = false}) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          if (icon != null)
            WidgetSpan(
              child: Icon(
                icon,
                size: Theme.of(context).textTheme.headline6.fontSize,
                color: Theme.of(context).accentColor,
              ),
            ),
          TextSpan(
            text: (icon != null ? " " : "") + text,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: italic ? FontStyle.italic : FontStyle.normal,
                ),
          ),
        ],
      ),
    );
  }

  Widget _getCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: InkWell(
        onTap: () => _tappedItem(context),
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: getCardChild(context),
        ),
      ),
    );
  }

  Widget _getPreview(BuildContext context) {
    return InkWell(
      onTap: () => _tappedItem(context),
      child: getPreviewChild(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (item == null) return null;
    return preview ? _getPreview(context) : _getCard(context);
  }
}
