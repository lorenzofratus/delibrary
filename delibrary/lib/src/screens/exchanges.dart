import 'package:delibrary/src/components/page-title.dart';
import 'package:delibrary/src/components/section-container.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/shortcuts/padded-list-view.dart';
import 'package:delibrary/src/shortcuts/refreshable.dart';
import 'package:flutter/material.dart';

class ExchangesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExchangesScreenState();
}

class _ExchangesScreenState extends State<ExchangesScreen> {
  BookList _waitingList;
  BookList _sentList;
  BookList _refusedList;
  BookList _completedList;

  @override
  void initState() {
    super.initState();
    _downloadLists();
  }

  Future<void> _downloadLists() async {
    //TODO: fetch the book lists
    _waitingList = BookList();
    _sentList = BookList();
    _refusedList = BookList();
    _completedList = BookList();
    print("We should fetch the exchanges...");
  }

  //TODO: manage navigation (onExpand) see library.dart

  @override
  Widget build(BuildContext context) {
    return Refreshable(
      onRefresh: _downloadLists,
      child: PaddedListView(
        children: [
          PageTitle("I tuoi scambi"),
          BooksSectionContainer(
            title: "In attesa",
            bookList: _waitingList,
          ),
          BooksSectionContainer(
            title: "Inviati",
            bookList: _sentList,
          ),
          BooksSectionContainer(
            title: "Rifiutati",
            bookList: _refusedList,
          ),
          BooksSectionContainer(
            title: "Completati",
            bookList: _completedList,
          ),
        ],
      ),
    );
  }
}
