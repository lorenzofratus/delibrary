import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:flutter/material.dart';

class DelibraryLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DelibraryLogo(large: true),
          PaddedContainer(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
