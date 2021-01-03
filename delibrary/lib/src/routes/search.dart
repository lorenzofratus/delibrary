import 'package:delibrary/src/components/cards-list.dart';
import 'package:delibrary/src/components/search-bar.dart';
import 'package:delibrary/src/controller/books-services.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/routes/book-details.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final bool globalSearch;

  SearchPage({this.globalSearch = false});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String lastQuery = "";
  String lastFilter = "";
  int startIndex = 0;
  int maxResults = 10;
  BookList _resultsList;

  ScrollController _listController = ScrollController();

  @override
  void initState() {
    super.initState();
    _listController = _listController ?? ScrollController();
    _listController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _listController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_listController.position.pixels ==
        _listController.position.maxScrollExtent) {
      if (widget.globalSearch) _globalNext();
    }
  }

  void _setLastParameters(String query, String filter) {
    lastQuery = query;
    lastFilter = filter;
  }

  void _scrollListToTop() {
    if (_listController.hasClients)
      _listController.animateTo(0.0,
          duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  void _appSearch(String query, String filter) {
    //TODO perform search
    _setLastParameters(query, filter);
    _scrollListToTop();
    if (query.isEmpty) return;
    print("App search: " + query + " filtering in " + filter);
  }

  Future<void> _globalSearch(String query, String filter) async {
    _setLastParameters(query, filter);
    _scrollListToTop();
    BookList firstPage;
    if (query.isNotEmpty) firstPage = await BooksServices.getByQuery(query);
    setState(() {
      _resultsList = firstPage;
    });
  }

  Future<void> _globalNext() async {
    if (_resultsList.isComplete) return;
    startIndex += maxResults;
    BookList nextPage = await BooksServices.getByQuery(lastQuery,
        startIndex: startIndex, maxResults: maxResults);
    setState(() {
      _resultsList.addAll(nextPage);
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
        SearchBar(
          onSearch: widget.globalSearch ? _globalSearch : _appSearch,
          globalSearch: widget.globalSearch,
        ),
        if (lastQuery.isNotEmpty)
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
