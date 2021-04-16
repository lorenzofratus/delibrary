import 'dart:math';

import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/card.dart';
import 'package:delibrary/src/components/cards-list.dart';
import 'package:delibrary/src/components/editable-field.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:delibrary/src/model/user.dart';
import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'draggable-modal-page.dart';

class SectionContainer extends StatelessWidget {
  final String title;
  final Widget child;

  SectionContainer({
    this.title = "",
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      padding: EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline5.copyWith(
                  color: Theme.of(context).accentColor,
                ),
          ),
          child,
        ],
      ),
    );
  }
}

class FormSectionContainer extends StatelessWidget {
  final String title;
  final Key formKey;
  final bool editing;
  final void Function() startEditing;
  final void Function() saveEditing;
  final void Function() cancelEditing;
  final List<FieldData> fields;

  FormSectionContainer({
    this.title = "",
    @required this.formKey,
    this.editing = false,
    this.startEditing,
    this.saveEditing,
    this.cancelEditing,
    @required this.fields,
  }) : assert((startEditing != null) ^ (saveEditing == null));

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: title,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            if (fields != null)
              for (FieldData data in fields)
                EditableFormField(
                  text: data.text,
                  label: data.label,
                  validator: data.validator,
                  editing: data.validator != null ? editing : false,
                  obscurable: data.obscurable,
                ),
            if (startEditing != null)
              editing
                  ? DelibraryButton(text: "Salva", onPressed: saveEditing)
                  : DelibraryButton(text: "Modifica", onPressed: startEditing),
            if (cancelEditing != null)
              AnimatedContainer(
                height: editing ? 80.0 : 0.0,
                child: DelibraryButton(
                  text: "Annulla",
                  onPressed: editing ? cancelEditing : null,
                  primary: false,
                ),
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
              ),
          ],
        ),
      ),
    );
  }
}

class BooksSectionContainer extends StatelessWidget {
  final String title;
  final BookList Function(BuildContext) provider;

  BooksSectionContainer({this.title = "", @required this.provider})
      : assert(provider != null);

  void _expand(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Scaffold(
        // Scaffold is here as a workaround to display snackbars above the bottom sheet
        backgroundColor: Colors.transparent,
        body: DraggableModalPage(
          title: title,
          child: CardsList(
            bookList: provider(context),
            reverse: true,
          ),
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BookList bookList = provider(context);

    if (bookList?.isEmpty ?? true)
      return SectionContainer(
        title: title,
        child: PaddedContainer(
          alignment: Alignment.center,
          child: Text(
            "Nessun libro trovato",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      );

    BookList wishList = context.read<Session>().wishes;
    Map<Book, bool> wishMap = bookList.intersect(wishList);

    return SectionContainer(
      title: title,
      child: Column(
        children: [
          GridView.builder(
            padding: EdgeInsets.only(top: 30.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 30.0,
            ),
            primary: false,
            shrinkWrap: true,
            itemCount: min(bookList.length, 2),
            itemBuilder: (context, index) {
              int reverseIdx = bookList.length - index - 1;
              Book book = bookList?.getAt(reverseIdx);
              return BookCardPreview(book: book, wished: wishMap[book]);
            },
          ),
          DelibraryButton(
            onPressed: () => _expand(context),
            text: "Vedi tutti",
          ),
        ],
      ),
    );
  }
}
