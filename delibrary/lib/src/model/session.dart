import 'package:delibrary/src/model/book-list.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/exchange-list.dart';
import 'package:delibrary/src/model/exchange.dart';
import 'package:delibrary/src/model/user.dart';
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

  // ** Session management **

  bool get isValid => _user != null;

  void destroy() {
    // User attributes must be set to default
    _user = null;
    _properties = null;
    _wishes = null;
    _exchanges = null;
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
  ExchangeList get proposed => _exchanges?.proposed ?? ExchangeList();
  ExchangeList get refused => _exchanges?.refused ?? ExchangeList();
  ExchangeList get agreed => _exchanges?.agreed ?? ExchangeList();
  ExchangeList get happened => _exchanges?.happened ?? ExchangeList();

  set exchanges(ExchangeList exchanges) {
    if (exchanges != null) {
      _exchanges = exchanges;
      notifyListeners();
    }
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

  void refuse(Exchange exchange) {
    _exchanges = exchanges.refuse(exchange);
    notifyListeners();
  }

  void happen(Exchange exchange) {
    _exchanges = exchanges.happen(exchange);
    notifyListeners();
  }
}
