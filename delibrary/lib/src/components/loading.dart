import 'package:delibrary/src/components/logo.dart';
import 'package:flutter/material.dart';

class DelibraryLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DelibraryLogo(large: true),
          Container(
            padding: EdgeInsets.all(50.0),
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
