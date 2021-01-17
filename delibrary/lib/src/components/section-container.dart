import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/card.dart';
import 'package:delibrary/src/components/editable-field.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/user.dart';
import 'package:delibrary/src/routes/list.dart';
import 'package:flutter/material.dart';

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
  final Function startEditing;
  final Function saveEditing;
  final Function cancelEditing;
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
  final BookList bookList;
  final Function onTap;

  BooksSectionContainer({this.title = "", @required this.bookList, this.onTap});

  void _seeMore(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListPage(
          title: title,
          bookList: bookList,
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: title,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BookCardPreview(book: bookList?.get(0), onTap: onTap),
                SizedBox(width: 30.0),
                BookCardPreview(book: bookList?.get(1), onTap: onTap),
              ],
            ),
          ),
          DelibraryButton(
            onPressed: () => _seeMore(context),
            text: "Vedi tutti",
          ),
        ],
      ),
    );
  }
}
