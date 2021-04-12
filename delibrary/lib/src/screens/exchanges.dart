import 'package:delibrary/src/components/page-title.dart';
import 'package:delibrary/src/components/section-container.dart';
import 'package:delibrary/src/controller/property-services.dart';
import 'package:delibrary/src/controller/wish-services.dart';
import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/routes/book-details.dart';
import 'package:delibrary/src/shortcuts/padded-list-view.dart';
import 'package:delibrary/src/shortcuts/refreshable.dart';
import 'package:flutter/material.dart';

class ExchangesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExchangesScreenState();
}

class _ExchangesScreenState extends State<ExchangesScreen> {
  final PropertyServices _propertyServices = PropertyServices();
  final WishServices _wishServices = WishServices();
  BookList _waitingList;
  BookList _sentList;
  BookList _refusedList;
  BookList _completedList;

  @override
  void initState() {
    super.initState();
    _downloadLists();
  }

  Future<void> _downloadWaitingList() async {
    _waitingList = BookList();
  }

  Future<void> _downloadSentList() async {
    _sentList = BookList();
  }

  Future<void> _downloadRefusedList() async {
    _refusedList = BookList();
  }

  Future<void> _downloadCompletedList() async {
    _completedList = BookList();
  }

  Future<void> _downloadLists() async {
    //TODO: fetch the book lists
    _downloadWaitingList();
    _downloadSentList();
    _downloadRefusedList();
    _downloadCompletedList();
    print("We should fetch the exchanges...");
  }

  //TODO: change selected functions to go to the profile page of the other user

  Future<void> _selectedWaiting(Book book) async {
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
    print(selectedAction);
  }

  Future<void> _selectedSent(Book book) async {
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

  Future<void> _selectedRefused(Book book) async {
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

  Future<void> _selectedCompleted(Book book) async {
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
    return Refreshable(
      onRefresh: _downloadLists,
      child: PaddedListView(
        children: [
          PageTitle("I tuoi scambi"),
          BooksSectionContainer(
            title: "In attesa",
            bookList: _waitingList,
            onTap: _selectedWaiting,
            onRefresh: _downloadWaitingList,
          ),
          BooksSectionContainer(
            title: "Inviati",
            bookList: _sentList,
            onTap: _selectedSent,
            onRefresh: _downloadSentList,
          ),
          BooksSectionContainer(
            title: "Rifiutati",
            bookList: _refusedList,
            onTap: _selectedRefused,
            onRefresh: _downloadRefusedList,
          ),
          BooksSectionContainer(
            title: "Completati",
            bookList: _completedList,
            onTap: _selectedCompleted,
            onRefresh: _downloadCompletedList,
          ),
        ],
      ),
    );
  }
}
