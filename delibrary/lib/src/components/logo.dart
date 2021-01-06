import 'package:flutter/material.dart';

class DelibraryLogo extends StatelessWidget {
  final bool large;

  DelibraryLogo({this.large = false});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "lib/assets/logo.png",
      semanticLabel: "delibrary",
      width: MediaQuery.of(context).size.width * (this.large ? 0.6 : 0.35),
    );
  }
}
