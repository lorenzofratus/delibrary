import 'package:flutter/material.dart';

class DelibraryButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool primary;

  DelibraryButton({
    @required this.text,
    @required this.onPressed,
    this.primary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30.0),
      child: FlatButton(
        child: Text(
          text,
          style: Theme.of(context).textTheme.button.copyWith(
                color: primary ? Colors.black : Colors.white,
              ),
        ),
        color: primary
            ? Theme.of(context).accentColor
            : Theme.of(context).cardColor,
        height: 50.0,
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
