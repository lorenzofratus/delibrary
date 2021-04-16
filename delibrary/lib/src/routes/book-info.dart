import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/custom-app-bar.dart';
import 'package:delibrary/src/components/expandable-text.dart';
import 'package:delibrary/src/controller/property-services.dart';
import 'package:delibrary/src/controller/wish-services.dart';
import 'package:delibrary/src/model/action.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookInfoPage extends StatelessWidget {
  final Book book;
  final bool wished;

  final PropertyServices _propertyServices = PropertyServices();
  final WishServices _wishServices = WishServices();

  BookInfoPage({@required this.book, this.wished = false})
      : assert(book != null);

  @override
  Widget build(BuildContext context) {
    String username = context.read<Session>().user.username;
    bool hasProperty = book.property != null;
    bool userProperty = hasProperty && book.property.ownerUsername == username;
    bool hasWish = book.wish != null;
    bool userWish = hasWish && book.wish.ownerUsername == username;

    DelibraryAction primaryAction;
    DelibraryAction secondaryAction;

    // TODO implement exchange actions
    if (hasProperty) {
      if (userProperty) {
        // Property of current user
        primaryAction = _propertyServices.removeProperty(book);
        secondaryAction = _propertyServices.movePropertyToWishList(book);
      } else {
        // Property of another user
        primaryAction = DelibraryAction(
          //TODO implement exchange action
          text: "Proponi uno scambio",
          execute: (context) {},
        );
        secondaryAction = _propertyServices.addProperty(book);
      }
    } else if (userWish) {
      // Wish of current user
      primaryAction = _wishServices.removeWish(book);
      secondaryAction = _wishServices.moveWishToLibrary(book);
    } else {
      // Global search
      primaryAction = _propertyServices.addProperty(book);
      secondaryAction = _wishServices.addWish(book);
    }

    return Scaffold(
      appBar: CustomAppBar(),
      body: _DraggableSheet(
        book: book,
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
      margin: EdgeInsets.symmetric(vertical: 15.0),
      child: ExpandableText(
        text ?? "",
        style: Theme.of(context).textTheme.headline6,
        maxLines: 8,
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

class _Chips extends StatelessWidget {
  final String title;
  final Map<String, IconData> data;

  _Chips({this.title = "", this.data});

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
                .map((entry) => _Data(entry.key, type: entry.value))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _Data extends Chip {
  _Data(String text, {IconData type})
      : super(
          avatar: type != null ? Icon(type, size: 15.0) : null,
          label: Text(text),
        );
}

class _DraggableSheet extends StatefulWidget {
  final Widget background;
  final List<Widget> foreground;
  final Book book;
  final bool wished;

  _DraggableSheet({
    @required this.background,
    @required this.foreground,
    @required this.book,
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

  void _toggleWished() {
    if (widget.book != null) {
      if (widget.wished)
        WishServices().removeWish(widget.book).execute(context);
      else
        WishServices().addWish(widget.book).execute(context);
    }
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
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
                controller: scrollController,
                children: widget.foreground ?? [],
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
            onPressed: _toggleWished,
          ),
        ),
      ],
    );
  }
}