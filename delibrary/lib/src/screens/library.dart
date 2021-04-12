import 'package:delibrary/src/components/page-title.dart';
import 'package:delibrary/src/components/section-container.dart';
import 'package:delibrary/src/controller/property-services.dart';
import 'package:delibrary/src/controller/wish-services.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:delibrary/src/routes/book-details.dart';
import 'package:delibrary/src/routes/list.dart';
import 'package:delibrary/src/shortcuts/padded-list-view.dart';
import 'package:delibrary/src/shortcuts/refreshable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final PropertyServices _propertyServices = PropertyServices();
  final WishServices _wishServices = WishServices();

  @override
  void initState() {
    super.initState();
    _downloadLists();
  }

  void _addBook() {
    Navigator.pushNamed(context, "/search");
  }

  Future<void> _downloadPropertyList() async {
    _propertyServices.updateSession(context);
  }

  Future<void> _downloadWishList() async {
    _wishServices.updateSession(context);
  }

  Future<void> _downloadLists() async {
    // This is done asynchronously, when it has finished the provider will notify and rebuild
    _downloadPropertyList();
    _downloadWishList();
  }

  void _expandLibrary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListPage(
          title: "Biblioteca",
          bookList: context.select<Session, BookList>((s) => s.properties),
          onTap: _selectedLibrary,
          onRefresh: _downloadPropertyList,
        ),
      ),
    );
  }

  void _selectedLibrary(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsPage(
          book: book,
          primaryAction: _propertyServices.removeProperty(book),
          secondaryAction: _propertyServices.movePropertyToWishList(book),
        ),
      ),
    );
  }

  void _expandWishlist() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListPage(
          title: "Wishlist",
          bookList: context.select<Session, BookList>((s) => s.wishes),
          onTap: _selectedWishlist,
          onRefresh: _downloadWishList,
        ),
      ),
    );
  }

  void _selectedWishlist(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsPage(
          book: book,
          primaryAction: _wishServices.removeWish(book),
          secondaryAction: _wishServices.moveWishToLibrary(book),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Refreshable(
      onRefresh: _downloadLists,
      child: PaddedListView(
        children: [
          PageTitle(
            "I tuoi libri",
            action: _addBook,
            actionIcon: Icons.add,
          ),
          BooksSectionContainer(
            title: "Biblioteca",
            bookList: context.select<Session, BookList>((s) => s.properties),
            onTap: _selectedLibrary,
            onExpand: _expandLibrary,
          ),
          BooksSectionContainer(
            title: "Wishlist",
            bookList: context.select<Session, BookList>((s) => s.wishes),
            onTap: _selectedWishlist,
            onExpand: _expandWishlist,
          ),
        ],
      ),
    );
  }
}
