import 'package:delibrary/src/components/utils/padded-grid.dart';
import 'package:delibrary/src/components/utils/page-title.dart';
import 'package:delibrary/src/components/sections/items.dart';
import 'package:delibrary/src/controller/internal/property-services.dart';
import 'package:delibrary/src/controller/internal/wish-services.dart';
import 'package:delibrary/src/model/primary/book-list.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:delibrary/src/components/utils/refreshable.dart';
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
    await _propertyServices.updateSession(context);
    await _wishServices.updateSession(context);
  }

  @override
  Widget build(BuildContext context) {
    return Refreshable(
      onRefresh: _downloadLists,
      child: PaddedGrid(
        leading: [
          PageTitle(
            "I tuoi libri",
            action: _addBook,
            actionIcon: Icons.add,
          ),
        ],
        children: [
          ItemsSectionContainer(
            title: "Libreria",
            provider: (context) =>
                context.select<Session, BookList>((s) => s.properties),
          ),
          ItemsSectionContainer(
            title: "Wishlist",
            provider: (context) =>
                context.select<Session, BookList>((s) => s.wishes),
          ),
        ],
      ),
    );
  }
}
