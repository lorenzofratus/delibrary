import 'package:delibrary/src/components/cards-list.dart';
import 'package:delibrary/src/components/position-search-bar.dart';
import 'package:delibrary/src/controller/position_services.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/routes/book-details.dart';
import 'package:flutter/material.dart';

class PositionSearchPage extends StatefulWidget {
  @override
  _PositionSearchPageState createState() => _PositionSearchPageState();
}

class _PositionSearchPageState extends State<PositionSearchPage> {
  String lastProvince = "";
  String lastTown = "";
  int startIndex = 0;
  int maxResults = 10;
  BookList _resultsList;

  ScrollController _listController = ScrollController();

  @override
  void initState() {
    super.initState();
    _listController = _listController ?? ScrollController();
  }

  void _setLastParameters(String province, String town) {
    lastProvince = province;
    lastTown = town;
  }

  void _scrollListToTop() {
    if (_listController.hasClients)
      _listController.animateTo(0.0,
          duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  Future<void> _positionSearch(String province, String town) async {
    _setLastParameters(province, town);
    _scrollListToTop();
    if (province.isEmpty || town.isEmpty)
      return; // TODO error message: "Non è possibile lasciare campi vuoti"
    print("Location search. Province: " + lastProvince + " Town: " + lastTown);
    BookList bookList = await PositionServices.getByQuery(province, town);
    setState(() {
      _resultsList = bookList;
    });
  }

  Future<void> _selectedBook(Book book) async {
    int selectedAction = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookPage(
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
          onSearch: _positionSearch,
        ),
        if (lastProvince.isNotEmpty && lastTown.isNotEmpty)
          Expanded(
            child: CardsList(
              booksList: _resultsList,
              controller: _listController,
              onTap: _selectedBook,
            ),
          ),
      ],
    );
  }
}
