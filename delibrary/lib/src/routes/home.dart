import 'package:delibrary/src/components/custom-app-bar.dart';
import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/components/navigation-bar.dart';
import 'package:delibrary/src/controller/internal/user-services.dart';
import 'package:delibrary/src/screens/exchanges.dart';
import 'package:delibrary/src/screens/library.dart';
import 'package:delibrary/src/screens/position-search.dart';
import 'package:delibrary/src/screens/profile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  int _selectedIndex = 0;
  List<Widget> _mainRoutes;

  void initState() {
    super.initState();
    UserServices().validateUser(context).then((auth) {
      if (auth)
        setState(() {
          _loading = false;
        });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _mainRoutes = [
      PositionSearchScreen(),
      LibraryScreen(),
      ExchangesScreen(),
      ProfileScreen(),
    ];

    if (_loading)
      return Center(
        child: DelibraryLogo(
          large: true,
          animated: true,
        ),
      );

    return Scaffold(
      appBar: CustomAppBar(),
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
