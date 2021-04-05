import 'package:delibrary/src/model/book-list.dart';
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

  // ** Session management **

  bool get isValid => _user != null;

  void destroy() {
    // User attributes must be set to default
    _user = null;
    _properties = null;
  }

  // ** User management **

  User get user => _user;

  set user(User user) {
    if (user != null) {
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

  // ** Wishes management **

  BookList get wishes => _wishes ?? BookList();

  set wishes(BookList wishes) {
    if (wishes != null) {
      _wishes = properties;
      notifyListeners();
    }
  }
}
