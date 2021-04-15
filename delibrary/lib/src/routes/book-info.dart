import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/expandable-text.dart';
import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/model/action.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookInfoPage extends StatelessWidget {
  final Book book;
  final bool wished;
  final DelibraryAction primaryAction;
  final DelibraryAction secondaryAction;

  const BookInfoPage({
    @required this.book,
    this.wished = false,
    this.primaryAction,
    this.secondaryAction,
  }) : assert(book != null);

  @override
  Widget build(BuildContext context) {
    bool hasProperty = book.property != null;
    bool userProperty = hasProperty &&
        book.property.ownerUsername == context.read<Session>().user.username;

    return Scaffold(
      appBar: AppBar(
        title: DelibraryLogo(),
      ),
      body: _DraggableSheet(
        wished: wished,
        background: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.65,
          child: book.largeImage,
        ),
        foreground: [
          // Book information
          _Title(book.title),
          if (book.subtitle.isNotEmpty) _Title(book.subtitle, false),
          if (book.description.isNotEmpty) _Description(book.description),

          if (book.hasDetails)
            _Chips(
              title: "Dettagli volume",
              data: {
                for (String author in book.authorsList)
                  author: _DataType.author,
                if (book.publisher.isNotEmpty)
                  book.publisher: _DataType.publisher,
                if (book.publishedDate.isNotEmpty)
                  book.publishedDate: _DataType.date,
              },
            ),

          if (hasProperty && !userProperty)
            _Chips(
              title: "Dettagli copia fisica",
              data: {
                book.property.ownerUsername: _DataType.user,
                book.property.positionString: _DataType.position,
              },
            ),

          // Possible actions on the book
          if (primaryAction != null)
            DelibraryButton(
              text: primaryAction.text,
              onPressed: () => primaryAction.execute(context),
            ),
          if (secondaryAction != null)
            DelibraryButton(
              text: secondaryAction.text,
              onPressed: () => secondaryAction.execute(context),
              primary: false,
            ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;
  final bool primary;

  _Title(this.text, [this.primary = true]);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 15.0),
      child: ExpandableText(
        text,
        style: primary
            ? Theme.of(context).textTheme.headline4.copyWith(
                  color: Theme.of(context).accentColor,
                )
            : Theme.of(context).textTheme.headline5.copyWith(
                  fontStyle: FontStyle.italic,
                ),
        maxLines: 2,
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String text;

  _Description(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: ExpandableText(
        text,
        style: Theme.of(context).textTheme.headline6,
        maxLines: 8,
      ),
    );
  }
}

class _Chips extends StatelessWidget {
  final String title;
  final Map<String, IconData> data;

  _Chips({this.title, this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
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
            children: data.entries
                .map((entry) => _Data(entry.key, type: entry.value))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _DataType {
  static const IconData author = Icons.edit;
  static const IconData publisher = Icons.store;
  static const IconData date = Icons.calendar_today;
  static const IconData user = Icons.person;
  static const IconData position = Icons.place;
}

class _Data extends StatelessWidget {
  final String text;
  final IconData type;

  _Data(this.text, {this.type});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: type != null
          ? Icon(
              type,
              size: 15.0,
            )
          : null,
      label: Text(text),
    );
  }
}

class _DraggableSheet extends StatefulWidget {
  final Widget background;
  final List<Widget> foreground;
  final bool wished;

  _DraggableSheet({
    @required this.background,
    @required this.foreground,
    this.wished = false,
  });

  @override
  State<StatefulWidget> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<_DraggableSheet> {
  double _initialSheetChildSize = 0.4;
  double _dragScrollSheetExtent = 0;

  double _widgetHeight = 0;
  double _fabPosition = 0;
  double _fabPositionPadding = 30;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _fabPosition = _initialSheetChildSize * context.size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.background,
        NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            setState(() {
              _widgetHeight = context.size.height;
              _dragScrollSheetExtent = notification.extent;

              _fabPosition = _dragScrollSheetExtent * _widgetHeight;
            });
            return;
          },
          child: DraggableScrollableSheet(
            initialChildSize: _initialSheetChildSize,
            minChildSize: _initialSheetChildSize,
            maxChildSize: 0.9,
            builder: (context, scrollController) => Container(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 80.0),
                controller: scrollController,
                children: widget.foreground,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: _fabPosition - _fabPositionPadding,
          right: _fabPositionPadding,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).accentColor,
            child: Icon(
              widget.wished ? Icons.favorite : Icons.favorite_outline,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
