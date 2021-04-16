import 'package:delibrary/src/components/cards-list.dart';
import 'package:delibrary/src/components/position-search-bar.dart';
import 'package:delibrary/src/controller/property-services.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PositionSearchScreen extends StatefulWidget {
  @override
  _PositionSearchScreenState createState() => _PositionSearchScreenState();
}

class _PositionSearchScreenState extends State<PositionSearchScreen> {
  final PropertyServices _propertyServices = PropertyServices();
  String _lastProvince = "";
  String _lastTown = "";
  BookList _resultsList;

  @override
  void initState() {
    super.initState();
  }

  void _setResultsList(BookList bookList) {
    setState(() {
      _resultsList = bookList;
    });
  }

  Future<void> _positionSearch(String province, String town) async {
    if (_lastProvince != province || _lastTown != town) {
      _lastProvince = province;
      _lastTown = town;

      _setResultsList(null);

      BookList bookList = await _propertyServices.getPropertiesByPosition(
          context, province, town);
      _setResultsList(bookList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PositionSearchBar(
          provinces: context.read<Session>().provinces,
          onSearch: _positionSearch,
        ),
        if (_lastProvince.isNotEmpty)
          _resultsList != null
              ? Expanded(
                  child: CardsList(
                    bookList: _resultsList,
                  ),
                )
              : Center(
                  heightFactor: 3.0,
                  child: CircularProgressIndicator(),
                ),
      ],
    );
  }
}
