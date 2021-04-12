import 'package:delibrary/src/components/cards-list.dart';
import 'package:delibrary/src/components/global-search-bar.dart';
import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/controller/book-services.dart';
import 'package:delibrary/src/controller/property-services.dart';
import 'package:delibrary/src/controller/wish-services.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/routes/book-details.dart';
import 'package:flutter/material.dart';

class GlobalSearchPage extends StatefulWidget {
  @override
  _GlobalSearchPageState createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends State<GlobalSearchPage> {
  final BookServices _bookServices = BookServices();
  final PropertyServices _propertyServices = PropertyServices();
  final WishServices _wishServices = WishServices();
  String _lastQuery = "";
  int _startIndex = 0;
  int _maxResults = 10;
  BookList _resultsList;
  ScrollController _listController;

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
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
      _lastQuery = query;
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
    _startIndex += _maxResults;
    BookList nextPage = await _bookServices.getByQuery(_lastQuery,
        startIndex: _startIndex, maxResults: _maxResults);
    setState(() {
      _resultsList = _resultsList.addPage(nextPage);
    });
  }

  Future<void> _selectedBook(Book book) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsPage(
          book: book,
          primaryAction: _propertyServices.addProperty(book),
          secondaryAction: _wishServices.addWish(book),
        ),
      ),
    );
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
          if (_lastQuery.isNotEmpty)
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
