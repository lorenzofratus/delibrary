import 'package:flutter/material.dart';

class DraggableModalPage extends StatelessWidget {
  final String title;
  final Widget child;
  final void Function() onClose;

  DraggableModalPage(
      {this.title, @required this.child, @required this.onClose});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: true,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
        ),
        child: Column(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              controller: scrollController,
              children: [
                _DraggableModalPill(),
                _DraggableModalTitle(title: title, onClose: onClose),
              ],
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _DraggableModalPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 25.0),
        width: 30.0,
        height: 3.0,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(Radius.circular(1.5)),
        ),
      ),
    );
  }
}

class _DraggableModalTitle extends StatelessWidget {
  final String title;
  final void Function() onClose;

  _DraggableModalTitle({this.title, @required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 15.0, left: 50.0, right: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).textTheme.headline4.color,
            elevation: 0.0,
            mini: true,
            child: Icon(Icons.close),
            onPressed: onClose,
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
          // To keep the title centered
          Opacity(
            opacity: 0.0,
            child: FloatingActionButton(
              mini: true,
              child: null,
              onPressed: null,
            ),
          ),
        ],
      ),
    );
  }
}
