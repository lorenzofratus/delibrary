import 'package:delibrary/src/components/cards-list.dart';
import 'package:delibrary/src/components/draggable-modal-page.dart';
import 'package:delibrary/src/components/page-title.dart';
import 'package:delibrary/src/components/section-container.dart';
import 'package:delibrary/src/controller/property-services.dart';
import 'package:delibrary/src/controller/wish-services.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/session.dart';
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

  Future<void> _downloadLists() async {
    // This is done asynchronously, when it has finished the provider will notify and rebuild
    _propertyServices.updateSession(context);
    _wishServices.updateSession(context);
  }

  void _expandLibrary() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableModalPage(
        title: "Libreria",
        child: CardsList(
          bookList: context.select<Session, BookList>((s) => s.properties),
          reverse: true,
        ),
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _expandWishlist() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableModalPage(
        title: "Wishlist",
        child: CardsList(
          bookList: context.select<Session, BookList>((s) => s.wishes),
          reverse: true,
        ),
        onClose: () => Navigator.pop(context),
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
            title: "Libreria",
            bookList: context.select<Session, BookList>((s) => s.properties),
            onExpand: _expandLibrary,
          ),
          BooksSectionContainer(
            title: "Wishlist",
            bookList: context.select<Session, BookList>((s) => s.wishes),
            onExpand: _expandWishlist,
          ),
        ],
      ),
    );
  }
}
