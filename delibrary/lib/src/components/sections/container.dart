import 'package:flutter/material.dart';

class SectionContainer extends StatelessWidget {
  final String title;
  final List<Widget> children;

  SectionContainer({
    this.title,
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      padding: EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title,
              style: Theme.of(context).textTheme.headline5.copyWith(
                    color: Theme.of(context).accentColor,
                  ),
            ),
          ...children,
        ],
      ),
    );
  }
}
