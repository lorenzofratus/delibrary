import 'package:flutter/material.dart';

class DelibraryLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "lib/assets/logo.png",
      semanticLabel: "delibrary",
      width: MediaQuery.of(context).size.width * 0.35,
    );
  }
}
