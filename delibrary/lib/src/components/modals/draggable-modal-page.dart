import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

class DraggableModalPage extends StatefulWidget {
  final Widget Function(BuildContext, ScrollController) builder;

  DraggableModalPage({@required this.builder}) : assert(builder != null);

  @override
  _DraggableModalPageState createState() => _DraggableModalPageState();
}

class _DraggableModalPageState extends State<DraggableModalPage> {
  Widget cachedChild;

  Widget _getChild(BuildContext context, ScrollController scrollController) {
    if (cachedChild == null)
      cachedChild = widget.builder(context, scrollController);
    return cachedChild;
  }

  @override
  Widget build(BuildContext context) {
    final double minSize = context.layout.value(xs: 0.5, sm: 0.4);
    return DraggableScrollableSheet(
      initialChildSize: minSize,
      minChildSize: minSize,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        child: _getChild(context, scrollController),
      ),
    );
  }
}
