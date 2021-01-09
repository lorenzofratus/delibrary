import 'package:delibrary/src/components/loading.dart';
import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/components/navigation-bar.dart';
import 'package:delibrary/src/controller/position_services.dart';
import 'package:delibrary/src/model/user.dart';
import 'package:delibrary/src/routes/exchanges.dart';
import 'package:delibrary/src/routes/global-search.dart';
import 'package:delibrary/src/routes/profile.dart';
import 'package:delibrary/src/routes/position-search.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'library.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;

  void initState() {
    super.initState();
    _checkAuthentication().then((authenticated) {
      if (!authenticated)
        Navigator.pushReplacementNamed(context, "/login");
      else
        setState(() {
          _loading = false;
        });
    });
  }

  Future<bool> _checkAuthentication() async {
    //Delay to show the loader, to remove
    // await Future.delayed(Duration(seconds: 5));

    await PositionServices.initProvinces();

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey("delibrary-cookie")) return false;
    String _cookie = _prefs.getString("delibrary-cookie");

    //TODO: send cookie to the server to check if it is valid
    //Maybe ask for the user?
    print(_cookie);
    return true;
  }

  final User user = User(
    username: "fratuslorenzo",
    name: "Lorenzo",
    surname: "Fratus",
    email: "fratus98@hotmail.it",
  );

  int _selectedIndex = 0;
  List<Widget> _mainRoutes;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _mainRoutes = [
      PositionSearchPage(),
      LibraryPage(),
      ExchangesPage(),
      ProfilePage(user: this.user),
    ];

    if (this._loading) return DelibraryLoading();

    return Scaffold(
      appBar: AppBar(
        title: DelibraryLogo(),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _mainRoutes,
      ),
      bottomNavigationBar: DelibraryNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
