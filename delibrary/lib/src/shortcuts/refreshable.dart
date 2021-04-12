import 'package:flutter/material.dart';

class Refreshable extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  Refreshable({@required this.onRefresh, @required this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: child,
      onRefresh: onRefresh,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
