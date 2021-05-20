import 'package:delibrary/src/components/cards/book-card.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/model/primary/item.dart';
import 'package:delibrary/src/model/secondary/property.dart';
import 'package:delibrary/src/model/secondary/wish.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

@immutable
class Book extends Item {
  final Property property;
  final Wish wish;
  final _VolumeInfo info;

  static final AssetImage placeholder =
      AssetImage("lib/assets/placeholder.png");

  Book({id, this.info, this.property, this.wish})
      : assert((property == null) || (wish == null)),
        super(id: id);

  bool get hasDetails => info?.hasDetails ?? false;
  bool get hasProperty => property != null;
  bool get hasWish => wish != null;

  String get title => info?.title ?? "No title";
  String get subtitle => info?.subtitle ?? "";
  List<String> get authorsList => info?.authors ?? [];
  String get authors => info?.authors?.join(", ") ?? "";
  String get publisher => info?.publisher ?? "";
  String get publishedYear =>
      info?.publishedDate?.split("-")?.first.toString() ?? "";
  String get publishedDate => info?.publishedDate ?? "";
  String get publishedInfo =>
      [publisher, publishedYear].where((x) => x.isNotEmpty).join(", ");
  String get description => info?.description ?? "";

  Widget get smallImage => _getImage(info?.small, 130.0);
  Widget get largeImage => _getImage(info?.large, null);

  @override
  Widget get backgroundImage => largeImage;

  static Widget _getImage(String url, [double height]) {
    return url == null || url.isEmpty
        ? Image(
            image: placeholder,
            fit: BoxFit.cover,
            height: height,
          )
        : FadeInImage(
            placeholder: placeholder,
            image: NetworkImage(url),
            fit: BoxFit.cover,
            fadeOutCurve: Curves.easeInOutCubic,
            fadeOutDuration: Duration(milliseconds: 200),
            fadeInCurve: Curves.easeInOutCubic,
            fadeInDuration: Duration(milliseconds: 200),
            height: height,
          );
  }

  @override
  BookCard getCard({
    bool preview = false,
    bool tappable = true,
    bool wished = false,
    bool showOwner = false,
    Exchange parent,
  }) =>
      BookCard(
        book: this,
        preview: preview,
        tappable: tappable,
        wished: wished,
        showOwner: showOwner,
        exchange: parent,
      );

  bool userProperty(String username) {
    return hasProperty && property.ownerUsername == username;
  }

  bool userWish(String username) {
    return hasWish && wish.ownerUsername == username;
  }

  Book setProperty(Property newProperty) {
    return Book(
      id: id,
      info: info,
      property: newProperty ?? property,
      wish: newProperty != null ? null : wish,
    );
  }

  Book removeProperty() {
    return Book(
      id: id,
      info: info,
      property: null,
      wish: wish,
    );
  }

  Book setWish(Wish newWish) {
    return Book(
      id: id,
      info: info,
      property: newWish != null ? null : property,
      wish: newWish ?? wish,
    );
  }

  Book removeWish() {
    return Book(
      id: id,
      info: info,
      property: property,
      wish: null,
    );
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json["id"],
      info: _VolumeInfo.fromJson(json["volumeInfo"]),
    );
  }
}

@immutable
class _VolumeInfo {
  final String title;
  final String subtitle;
  final List<String> authors;
  final String publisher;
  final String publishedDate;
  final String description;
  final _ImageLinks imageLinks;

  _VolumeInfo({
    this.title,
    this.subtitle,
    this.authors,
    this.publisher,
    this.publishedDate,
    this.description,
    this.imageLinks,
  });

  bool get hasDetails =>
      authors != null || publisher != null || publishedDate != null;

  String get small => imageLinks?.small ?? "";
  String get large => imageLinks?.large ?? "";

  static String _parseHtml(String html) {
    dynamic document = parse(html ?? "");
    return parse(document.body.text).documentElement.text;
  }

  factory _VolumeInfo.fromJson(Map<String, dynamic> json) {
    var authorsList = json["authors"] ?? [];
    List<String> authors = new List<String>.from(authorsList);
    authors.map((a) => _parseHtml(a));

    return _VolumeInfo(
      title: _parseHtml(json["title"]),
      subtitle: _parseHtml(json["subtitle"]),
      authors: authors,
      publisher: _parseHtml(json["publisher"]),
      publishedDate: _parseHtml(json["publishedDate"]),
      description: _parseHtml(json["description"]),
      imageLinks: json.containsKey("imageLinks")
          ? _ImageLinks.fromJson(json["imageLinks"])
          : null,
    );
  }
}

@immutable
class _ImageLinks {
  final String small;
  final String large;

  _ImageLinks({this.small, this.large});

  static String _secureUrl(String url) {
    RegExp regExp = RegExp(r'^http:');
    return url.replaceFirst(regExp, 'https:');
  }

  factory _ImageLinks.fromJson(Map<String, dynamic> json) {
    return _ImageLinks(
      small: _secureUrl(json["thumbnail"] ??
          json["small"] ??
          json["smallThumbnail"] ??
          json["medium"] ??
          json["large"] ??
          json["extraLarge"]),
      large: _secureUrl(json["extraLarge"] ??
          json["large"] ??
          json["medium"] ??
          json["small"] ??
          json["thumbnail"] ??
          json["smallThumbnail"]),
    );
  }
}
