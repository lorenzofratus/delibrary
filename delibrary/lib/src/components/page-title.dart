import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String text;
  final Function action;
  final IconData actionIcon;

  PageTitle(this.text, {this.action, this.actionIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 10.0),
        height: 66.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child:
                  Text(this.text, style: Theme.of(context).textTheme.headline4),
            ),
            if (this.action != null)
              Container(
                margin: EdgeInsets.only(left: 5.0),
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: this.action,
                  child: Icon(
                    this.actionIcon,
                    size: 30.0,
                  ),
                ),
              ),
          ],
        ));
  }
}
