import 'package:flutter/material.dart';

class DelibraryLogo extends StatelessWidget {
  final bool large;
  final bool animated;

  DelibraryLogo({this.large = false, this.animated = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        animated ? "lib/assets/loading.gif" : "lib/assets/logo.png",
        semanticLabel: "delibrary",
        width: MediaQuery.of(context).size.width * (large ? 0.6 : 0.35),
      ),
    );
  }
}
