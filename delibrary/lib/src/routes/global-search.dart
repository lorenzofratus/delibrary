import 'package:delibrary/src/components/cards/item-cards-list.dart';
import 'package:delibrary/src/components/ui-elements/custom-app-bar.dart';
import 'package:delibrary/src/components/search-bars/global-search-bar.dart';
import 'package:delibrary/src/controller/external/book-services.dart';
import 'package:delibrary/src/model/primary/book-list.dart';
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

  void _setResultsList(BookList bookList) {
    setState(() {
      _resultsList = bookList;
    });
  }

  Future<void> _globalSearch(String query) async {
    if (_lastQuery != query) {
      _lastQuery = query;
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
    final GlobalSearchBar _searchBar = GlobalSearchBar(
      onSearch: _globalSearch,
    );

    return Scaffold(
      appBar: CustomAppBar(),
      body: _resultsList != null
          ? ItemCardsList<BookList>(
              itemList: _resultsList,
              nextPage: _globalNext,
              appBar: _searchBar,
              appBarHeight: _searchBar.height,
            )
          : Column(
              children: [
                _searchBar,
                if (_lastQuery.isNotEmpty)
                  Center(
                    heightFactor: 3.0,
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
    );
  }
}
