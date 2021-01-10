import 'package:flutter/material.dart';

class Book {
  final String ownerUsername;
  final String id;
  final _VolumeInfo info;

  static final AssetImage placeholder =
      AssetImage("lib/assets/placeholder.png");

  Book({this.id, this.info, this.ownerUsername});

  String get title => info.title ?? "No title";
  String get authors => info.authors.join(", ") ?? "";
  String get publisher => info.publisher ?? "";
  String get publishedYear =>
      info.publishedDate?.split("-")?.first.toString() ?? "";
  String get publishedDate => info.publishedDate ?? "";
  String get description => info.description ?? "";

  Widget get smallImage => _getImage(info.small, 120.0);
  Widget get largeImage => _getImage(info.large, 120.0);
  Widget get previewImage => _getImage(info.small, 160.0);

  static Widget get placeholderImage => _getImage("", 120.0);
  static Widget get placeholderPreviewImage => _getImage("", 160.0);

  static Widget _getImage(String url, [double height]) {
    return url.isEmpty
        ? Image(
            image: placeholder,
            fit: BoxFit.cover,
            height: height,
          )
        : FadeInImage(
            placeholder: placeholder,
            image: NetworkImage(url),
            fit: BoxFit.cover,
            height: height,
          );
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json["id"],
      info: _VolumeInfo.fromJson(json["volumeInfo"]),
    );
  }
}

class _VolumeInfo {
  final String title;
  final List<String> authors;
  final String publisher;
  final String publishedDate;
  final String description;
  final _ImageLinks imageLinks;

  _VolumeInfo({
    this.title,
    this.authors,
    this.publisher,
    this.publishedDate,
    this.description,
    this.imageLinks,
  });

  String get small => imageLinks?.small ?? "";
  String get large => imageLinks?.large ?? "";

  factory _VolumeInfo.fromJson(Map<String, dynamic> json) {
    var authorsList = json["authors"] ?? List();
    List<String> authors = new List<String>.from(authorsList);

    return _VolumeInfo(
      title: json["title"],
      authors: authors,
      publisher: json["publisher"],
      publishedDate: json["publishedDate"],
      description: json["description"],
      imageLinks: json.containsKey("imageLinks")
          ? _ImageLinks.fromJson(json["imageLinks"])
          : null,
    );
  }
}

class _ImageLinks {
  final String small;
  final String large;

  _ImageLinks({this.small, this.large});

  factory _ImageLinks.fromJson(Map<String, dynamic> json) {
    return _ImageLinks(
      small: json["thumbnail"] ??
          json["small"] ??
          json["smallThumbnail"] ??
          json["medium"] ??
          json["large"] ??
          json["extraLarge"],
      large: json["extraLarge"] ??
          json["large"] ??
          json["medium"] ??
          json["small"] ??
          json["thumbnail"] ??
          json["smallThumbnail"],
    );
  }
}
