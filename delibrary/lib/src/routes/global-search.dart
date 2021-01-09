import 'package:delibrary/src/components/cards-list.dart';
import 'package:delibrary/src/components/global-search-bar.dart';
import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/controller/books-services.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/routes/book-details.dart';
import 'package:flutter/material.dart';

class GlobalSearchPage extends StatefulWidget {
  @override
  _GlobalSearchPageState createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends State<GlobalSearchPage> {
  String lastQuery = "";
  int startIndex = 0;
  int maxResults = 10;
  BookList _resultsList;
  final BooksServices _bookServices = BooksServices();

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
      _globalNext();
    }
  }

  void _setLastParameters(String query) {
    setState(() {
      lastQuery = query;
    });
  }

  void _scrollListToTop() {
    if (_listController.hasClients)
      _listController.animateTo(0.0,
          duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  Future<void> _globalSearch(String query) async {
    _setLastParameters(query);
    _scrollListToTop();
    BookList firstPage;
    if (query.isNotEmpty) firstPage = await _bookServices.getByQuery(query);
    setState(() {
      _resultsList = firstPage;
    });
  }

  Future<void> _globalNext() async {
    if (_resultsList.isComplete) return;
    startIndex += maxResults;
    BookList nextPage = await _bookServices.getByQuery(lastQuery,
        startIndex: startIndex, maxResults: maxResults);
    setState(() {
      _resultsList.addAll(nextPage);
    });
  }

  Future<void> _selectedBook(Book book) async {
    //TODO: manage actions
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
    return Scaffold(
      appBar: AppBar(
        title: DelibraryLogo(),
      ),
      body: Column(
        children: [
          GlobalSearchBar(
            onSearch: _globalSearch,
          ),
          if (lastQuery.isNotEmpty)
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
      ),
    );
  }
}
