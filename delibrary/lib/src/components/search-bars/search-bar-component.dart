import 'dart:math';

import 'package:delibrary/src/components/utils/button.dart';
import 'package:delibrary/src/components/utils/padded-container.dart';
import 'package:flutter/material.dart';

class SearchBarComponent extends StatelessWidget {
  final String title;
  final GlobalKey<FormState> formKey;
  final List<Widget> fields;
  final void Function() onPressed;

  SearchBarComponent({
    this.title = "",
    this.formKey,
    this.fields,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PaddedContainer(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        reverse: true,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal:
                    max((MediaQuery.of(context).size.width - 450.0) / 2, 0)),
            child: DelibraryButton(
              text: "Cerca",
              onPressed: onPressed,
            ),
          ),
          Form(
            key: formKey,
            child: Column(
              children: fields,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
