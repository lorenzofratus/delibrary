import 'package:delibrary/src/components/custom-app-bar.dart';
import 'package:delibrary/src/components/page-title.dart';
import 'package:delibrary/src/components/section-container.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/shortcuts/padded-list-view.dart';
import 'package:delibrary/src/shortcuts/refreshable.dart';
import 'package:flutter/material.dart';

class ArchivePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  //TODO: remove lists, use the Session instead
  BookList _refusedList;
  BookList _completedList;

  @override
  void initState() {
    super.initState();
    _downloadLists();
  }

  Future<void> _downloadLists() async {
    //TODO: fetch the book lists
    _refusedList = BookList();
    _completedList = BookList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Refreshable(
        onRefresh: _downloadLists,
        child: PaddedListView(
          children: [
            PageTitle("I tuoi scambi archiviati"),
            BooksSectionContainer(
              title: "Rifiutati",
              provider: (context) => _refusedList,
            ),
            BooksSectionContainer(
              title: "Completati",
              provider: (context) => _completedList,
            ),
          ],
        ),
      ),
    );
  }
}
