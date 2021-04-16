import 'package:flutter/material.dart';

class _CustomButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;
  final bool primary;

  _CustomButton({
    this.child,
    this.onPressed,
    this.primary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      child: TextButton(
        child: child,
        style: TextButton.styleFrom(
          backgroundColor: primary
              ? Theme.of(context).accentColor
              : Theme.of(context).cardColor,
          primary: primary ? Colors.black : Colors.white70,
          minimumSize: Size.fromHeight(50.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class DelibraryButton extends _CustomButton {
  DelibraryButton({
    String text = "",
    void Function() onPressed,
    bool primary = true,
  }) : super(
          child: Text(text),
          onPressed: onPressed,
          primary: primary,
        );
}

class LoadingButton extends _CustomButton {
  LoadingButton({bool primary = true})
      : super(
          child: SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                primary ? Colors.black : Colors.white70,
              ),
            ),
          ),
          onPressed: null,
          primary: primary,
        );
}
