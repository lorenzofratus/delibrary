import 'package:delibrary/src/model/primary/book-list.dart';
import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange-list.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/model/primary/user.dart';
import 'package:flutter/material.dart';

class Session extends ChangeNotifier {
  // ** Session attributes **
  User _user;

  Map<String, List<String>> _provinces;
  final int _daysBeforeProvUpdate = 30;
  DateTime _lastProvUpdate;

  BookList _properties;
  BookList _wishes;
  ExchangeList _exchanges;
  ExchangeList _archived;

  // ** Session management **

  bool get isValid => _user != null;

  void destroy() {
    // User attributes must be set to default
    _user = null;
    _properties = null;
    _wishes = null;
    _exchanges = null;
    _archived = null;
  }

  // ** User management **

  User get user => _user;

  set user(User user) {
    // Updates only if _user is null or they have the same username
    if (_user?.match(user) ?? true) {
      _user = user;
      notifyListeners();
    }
  }

  // ** Provinces management **

  Map<String, List<String>> get provinces => hasProvinces ? _provinces : null;

  set provinces(Map provinces) {
    if (provinces != null) {
      _provinces = provinces;
      _lastProvUpdate = DateTime.now();
      notifyListeners();
    }
  }

  bool get hasProvinces {
    return _provinces != null &&
        DateTime.now().difference(_lastProvUpdate).inDays <
            _daysBeforeProvUpdate;
  }

  // ** Properties management **

  BookList get properties => _properties ?? BookList();

  set properties(BookList properties) {
    if (properties != null) {
      _properties = properties;
      notifyListeners();
    }
  }

  void addProperty(Book book) {
    BookList oldList = properties;
    _properties = oldList.add(book);
    if (_properties != oldList) notifyListeners();
  }

  void removeProperty(Book book) {
    BookList oldList = properties;
    _properties = oldList.remove(book);
    if (_properties != oldList) notifyListeners();
  }

  // ** Wishes management **

  BookList get wishes => _wishes ?? BookList();

  set wishes(BookList wishes) {
    if (wishes != null) {
      _wishes = wishes;
      notifyListeners();
    }
  }

  void addWish(Book book) {
    BookList oldList = wishes;
    _wishes = oldList.add(book);
    if (_wishes != oldList) notifyListeners();
  }

  void removeWish(Book book) {
    BookList oldList = wishes;
    _wishes = oldList.remove(book);
    if (_wishes != oldList) notifyListeners();
  }

  // ** Exchanges management **

  ExchangeList get exchanges => _exchanges ?? ExchangeList();
  // Both waiting and sent are in the proposed state
  ExchangeList get waiting => _exchanges?.waiting ?? ExchangeList();
  ExchangeList get sent => _exchanges?.sent ?? ExchangeList();
  ExchangeList get agreed => _exchanges?.agreed ?? ExchangeList();

  set exchanges(ExchangeList exchanges) {
    if (exchanges != null) {
      _exchanges = exchanges;
      notifyListeners();
    }
  }

  bool hasActiveExchange(Book book) {
    return waiting.containsBook(book) ||
        sent.containsBook(book) ||
        agreed.containsBook(book);
  }

  void addExchange(Exchange exchange) {
    ExchangeList oldList = exchanges;
    _exchanges = oldList.add(exchange);
    if (_exchanges != oldList) notifyListeners();
  }

  void removeExchange(Exchange exchange) {
    ExchangeList oldList = exchanges;
    _exchanges = oldList.remove(exchange);
    if (_exchanges != oldList) notifyListeners();
  }

  void updateExchange(Exchange exchange) {
    ExchangeList oldList = exchanges;
    _exchanges = oldList.update(exchange);
    if (_exchanges != oldList) notifyListeners();
  }

  // ** Archived exchanges management **

  ExchangeList get archived => _archived ?? ExchangeList();
  ExchangeList get refused => _archived?.refused ?? ExchangeList();
  ExchangeList get happened => _archived?.happened ?? ExchangeList();

  set archived(ExchangeList archived) {
    if (archived != null) {
      _archived = archived;
      notifyListeners();
    }
  }

  void addArchived(Exchange exchange) {
    ExchangeList oldList = archived;
    _archived = oldList.add(exchange);
    if (_archived != oldList) notifyListeners();
  }
}
