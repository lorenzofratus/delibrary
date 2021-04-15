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
  String _lastProvince = "";
  BookList _resultsList;

  ScrollController _listController = ScrollController();

  @override
  void initState() {
    super.initState();
    _listController = _listController ?? ScrollController();
  }

  void _setLastParameters(String province, String town) {
    setState(() {
      _lastProvince = province;
    });
  }

  void _scrollListToTop() {
    if (_listController.hasClients)
      _listController.animateTo(0.0,
          duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  Future<void> _positionSearch(String province, String town) async {
    PropertyServices _propertyServices = PropertyServices();

    _setLastParameters(province, town);
    _scrollListToTop();

    print("Location search. Province: " + province + " Town: " + town);

    BookList bookList = await _propertyServices.getPropertiesByPosition(
        context, province, town);
    setState(() {
      _resultsList = bookList;
    });
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
                    controller: _listController,
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
