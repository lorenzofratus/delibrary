import 'package:delibrary/src/model/user.dart';
import 'package:flutter/material.dart';

class Session extends ChangeNotifier {
  User _user;

  bool get isValid => _user != null;

  void destroy() {
    // All the attributes must be set to default
    _user = null;
  }

  User get user => _user;
  set user(User user) {
    if (user != null) {
      _user = user;
      notifyListeners();
    }
  }
}
