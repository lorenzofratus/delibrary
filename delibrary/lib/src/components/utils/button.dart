import 'package:flutter/material.dart';

class _CustomButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;
  final bool primary;
  final bool loading;

  _CustomButton({
    this.child,
    this.onPressed,
    this.primary = true,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      constraints: BoxConstraints(maxWidth: 350.0),
      child: TextButton(
        child: child,
        style: TextButton.styleFrom(
          backgroundColor: onPressed != null || loading
              ? primary
                  ? Theme.of(context).accentColor
                  : Theme.of(context).cardColor
              : Theme.of(context).disabledColor,
          primary: primary ? Colors.black : Colors.white,
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
                primary ? Colors.black : Colors.white,
              ),
            ),
          ),
          onPressed: null,
          primary: primary,
          loading: true,
        );
}
