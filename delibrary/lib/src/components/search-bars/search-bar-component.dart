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
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
          Form(
            key: formKey,
            child: Column(children: fields),
          ),
          DelibraryButton(
            text: "Cerca",
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}
