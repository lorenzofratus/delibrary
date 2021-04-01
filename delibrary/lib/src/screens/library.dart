import 'package:delibrary/src/components/page-title.dart';
import 'package:delibrary/src/components/section-container.dart';
import 'package:delibrary/src/controller/property-services.dart';
import 'package:delibrary/src/controller/wish-services.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/user.dart';
import 'package:delibrary/src/routes/book-details.dart';
import 'package:delibrary/src/shortcuts/padded-list-view.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  final User user;

  LibraryScreen({this.user});

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

  Future<void> _downloadLists() async {
    _propertyServices.init(widget.user.username);
  }

  Future<void> _selectedLibrary(Book book) async {
    //TODO: manage actions
    int selectedAction = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsPage(
          book: book,
          primaryAction: _propertyServices.removeProperty(book),
          secondaryAction: _propertyServices.movePropertyToWishList(book),
        ),
      ),
    );
    if (selectedAction != null) setState(() {});
  }

  Future<void> _selectedWishlist(Book book) async {
    //TODO: manage actions
    int selectedAction = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsPage(
          book: book,
          primaryAction: _wishServices.removeWish(book),
          secondaryAction: _wishServices.moveWishToLibrary(book),
        ),
      ),
    );
    print(selectedAction);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _downloadLists,
      backgroundColor: Theme.of(context).primaryColor,
      child: PaddedListView(
        children: [
          PageTitle(
            "I tuoi libri",
            action: _addBook,
            actionIcon: Icons.add,
          ),
          BooksSectionContainer(
            title: "Biblioteca",
            bookList: _propertyServices.bookList,
            onTap: _selectedLibrary,
          ),
          BooksSectionContainer(
            title: "Wishlist",
            bookList: BookList(), // TODO
            onTap: _selectedWishlist,
          ),
        ],
      ),
    );
  }
}
