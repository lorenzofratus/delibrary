import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/components/navigation-bar.dart';
import 'package:delibrary/src/model/user.dart';
import 'package:delibrary/src/routes/profile.dart';
import 'package:delibrary/src/routes/search.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      SearchPage(globalSearch: true),
      Text(
        'Index 1: Library',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      Text(
        'Index 2: Exchanges',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      ProfilePage(user: this.user, editable: true),
    ];

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
