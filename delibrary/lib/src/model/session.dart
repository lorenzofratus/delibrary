import 'package:delibrary/src/model/user.dart';
import 'package:flutter/material.dart';

class Session extends ChangeNotifier {
  User _user;

  Map<String, List<String>> _provinces;
  final int _daysBeforeProvUpdate = 30;
  DateTime _lastProvUpdate;

  bool get isValid => _user != null;

  void destroy() {
    // User attributes must be set to default
    _user = null;
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
}
