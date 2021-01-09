import 'package:delibrary/src/components/page-title.dart';
import 'package:delibrary/src/components/section-container.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/routes/book-details.dart';
import 'package:delibrary/src/shortcuts/padded-list-view.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  BookList _bookList;

  @override
  void initState() {
    //TODO: fetch the bookList
    super.initState();
    _bookList = BookList();
  }

  void _addBook() {
    Navigator.pushNamed(context, "/search");
  }

  Future<void> _selectedLibrary(Book book) async {
    //TODO: manage actions
    int selectedAction = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsPage(
          book: book,
          primaryActionText: "Rimuovi dalla libreria",
          secondaryActionText: "Sposta nella wishlist",
        ),
      ),
    );
    print(selectedAction);
  }

  Future<void> _selectedWishlist(Book book) async {
    //TODO: manage actions
    int selectedAction = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsPage(
          book: book,
          primaryActionText: "Rimuovi dalla wishlist",
          secondaryActionText: "Sposta nella libreria",
        ),
      ),
    );
    print(selectedAction);
  }

  @override
  Widget build(BuildContext context) {
    return PaddedListView(
      children: [
        PageTitle(
          "I tuoi libri",
          action: _addBook,
          actionIcon: Icons.add,
        ),
        BooksSectionContainer(
          title: "Biblioteca",
          bookList: _bookList,
          onTap: _selectedLibrary,
        ),
        BooksSectionContainer(
          title: "Wishlist",
          bookList: _bookList,
          onTap: _selectedWishlist,
        ),
      ],
    );
  }
}
