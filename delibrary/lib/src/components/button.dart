import 'package:flutter/material.dart';

class _CustomButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final bool primary;

  _CustomButton({
    @required this.child,
    @required this.onPressed,
    this.primary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30.0),
      child: FlatButton(
        child: child,
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
    return _CustomButton(
      child: Text(
        text,
        style: Theme.of(context).textTheme.button.copyWith(
              color: primary ? Colors.black : Colors.white,
            ),
      ),
      onPressed: onPressed,
      primary: primary,
    );
  }
}

class LoadingButton extends StatelessWidget {
  final bool primary;
  LoadingButton({this.primary = true});

  @override
  Widget build(BuildContext context) {
    return _CustomButton(
      child: SizedBox(
        height: 25.0,
        width: 25.0,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(
            primary ? Colors.black : Colors.white,
          ),
        ),
      ),
      onPressed: () => {},
      primary: primary,
    );
  }
}
