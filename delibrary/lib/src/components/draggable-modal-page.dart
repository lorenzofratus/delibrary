import 'package:flutter/material.dart';

class DraggableModalPage extends StatelessWidget {
  final Widget Function(BuildContext, ScrollController) builder;

  DraggableModalPage({@required this.builder}) : assert(builder != null);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        child: builder(context, scrollController),
      ),
    );
  }
}
