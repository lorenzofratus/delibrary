import 'package:delibrary/src/components/cards-list.dart';
import 'package:delibrary/src/components/global-search-bar.dart';
import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/controller/book-services.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:flutter/material.dart';

class GlobalSearchPage extends StatefulWidget {
  @override
  _GlobalSearchPageState createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends State<GlobalSearchPage> {
  final BookServices _bookServices = BookServices();
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

  Future<void> _scrollListToTop() async {
    if (_listController.hasClients)
      await _listController.animateTo(0.0,
          duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  void _setResultsList(BookList bookList) {
    setState(() {
      _resultsList = bookList;
    });
  }

  Future<void> _globalSearch(String query) async {
    if (_lastQuery != query) {
      _lastQuery = query;

      await _scrollListToTop();
      _setResultsList(null);

      BookList firstPage;
      if (query.isNotEmpty) firstPage = await _bookServices.getByQuery(query);
      _setResultsList(firstPage);
    }
  }

  Future<void> _globalNext() async {
    if (!_resultsList.isComplete) {
      _startIndex += _maxResults;

      BookList nextPage = await _bookServices.getByQuery(_lastQuery,
          startIndex: _startIndex, maxResults: _maxResults);
      _setResultsList(_resultsList.addPage(nextPage));
    }
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
                      bookList: _resultsList,
                      controller: _listController,
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
