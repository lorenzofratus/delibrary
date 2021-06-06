import 'package:delibrary/src/components/cards/item-cards-list.dart';
import 'package:delibrary/src/components/search-bars/position-search-bar.dart';
import 'package:delibrary/src/controller/internal/property-services.dart';
import 'package:delibrary/src/model/primary/book-list.dart';
import 'package:delibrary/src/model/utils/position.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PositionSearchScreen extends StatefulWidget {
  @override
  _PositionSearchScreenState createState() => _PositionSearchScreenState();
}

class _PositionSearchScreenState extends State<PositionSearchScreen> {
  final PropertyServices _propertyServices = PropertyServices();
  Position _lastPosition;
  BookList _resultsList;

  void _setResultsList(BookList bookList) {
    setState(() {
      _resultsList = bookList;
    });
  }

  Future<void> _positionSearch(Position position) async {
    if (!position.match(_lastPosition)) {
      _setResultsList(null);

      BookList bookList = await _propertyServices.getPropertiesByPosition(
          context, position.province, position.town);
      _setResultsList(bookList);
    }
    _lastPosition = position;
  }

  @override
  Widget build(BuildContext context) {
    final PositionSearchBar _searchBar = PositionSearchBar(
      provinces: context.read<Session>().provinces,
      onSearch: _positionSearch,
    );

    if (_resultsList != null)
      return ItemCardsList<BookList>(
        itemList: _resultsList,
        appBar: _searchBar,
        appBarHeight: _searchBar.height,
      );
    return ListView(
      shrinkWrap: true,
      children: [
        _searchBar,
        if (_lastPosition?.isNotEmpty ?? false)
          Center(
            heightFactor: 3.0,
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
