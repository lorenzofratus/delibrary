import 'package:delibrary/src/components/utils/expandable-text.dart';
import 'package:flutter/material.dart';

class InfoTitle extends StatelessWidget {
  final String text;
  final bool primary;

  InfoTitle(this.text, [this.primary = true]);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: ExpandableText(
        text ?? "",
        style: primary
            ? Theme.of(context).textTheme.headline4.copyWith(
                  color: Theme.of(context).accentColor,
                )
            : Theme.of(context).textTheme.headline5.copyWith(
                  fontStyle: FontStyle.italic,
                ),
        textAlign: TextAlign.center,
        maxLines: 2,
      ),
    );
  }
}

class InfoTitleSmall extends StatelessWidget {
  final String text;
  final bool primary;

  InfoTitleSmall(this.text, [this.primary = true]);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: ExpandableText(
        text ?? "",
        style: primary
            ? Theme.of(context).textTheme.headline6.copyWith(
                  color: Theme.of(context).accentColor,
                )
            : Theme.of(context).textTheme.headline6.copyWith(
                  fontStyle: FontStyle.italic,
                ),
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    );
  }
}

class InfoDescription extends StatelessWidget {
  final String text;

  InfoDescription(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      child: ExpandableText(
        text ?? "",
        style: Theme.of(context).textTheme.headline6,
        maxLines: 8,
      ),
    );
  }
}

class InfoDataType {
  static const IconData author = Icons.edit;
  static const IconData publisher = Icons.store;
  static const IconData date = Icons.calendar_today;
  static const IconData user = Icons.person;
  static const IconData email = Icons.email;
  static const IconData position = Icons.place;
}

class InfoChips extends StatelessWidget {
  final String title;
  final Map<String, IconData> data;

  InfoChips({this.title = "", this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Theme.of(context).accentColor,
                ),
          ),
          Wrap(
            spacing: 10.0,
            children: (data?.entries ?? [])
                .map((entry) => InfoData(entry.key, type: entry.value))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class InfoData extends Chip {
  InfoData(String text, {IconData type})
      : super(
          avatar: type != null ? Icon(type, size: 15.0) : null,
          label: Text(text),
        );
}
