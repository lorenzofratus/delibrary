import 'package:delibrary/src/components/cards-list.dart';
import 'package:delibrary/src/components/position-search-bar.dart';
import 'package:delibrary/src/controller/property-services.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/routes/book-details.dart';
import 'package:flutter/material.dart';

class PositionSearchScreen extends StatefulWidget {
  final Map<String, List<String>> provinces;

  PositionSearchScreen({@required this.provinces});

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
    PropertyServices propertiesServices = PropertyServices();

    _setLastParameters(province, town);
    _scrollListToTop();

    print("Location search. Province: " + province + " Town: " + town);

    BookList bookList =
        await propertiesServices.getBooksByPosition(province, town);
    setState(() {
      _resultsList = bookList;
    });
  }

  Future<void> _selectedBook(Book book) async {
    int selectedAction = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsPage(
          book: book,
          primaryActionText: "Aggiungi alla libreria",
          secondaryActionText: "Aggiungi alla wishlist",
        ),
      ),
    );
    print(selectedAction);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PositionSearchBar(
          provinces: widget.provinces,
          onSearch: _positionSearch,
        ),
        if (_lastProvince.isNotEmpty)
          _resultsList != null
              ? Expanded(
                  child: CardsList(
                    booksList: _resultsList,
                    controller: _listController,
                    onTap: _selectedBook,
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
