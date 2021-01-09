import 'package:delibrary/src/components/loading.dart';
import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/components/navigation-bar.dart';
import 'package:delibrary/src/controller/position-services.dart';
import 'package:delibrary/src/model/user.dart';
import 'package:delibrary/src/screens/exchanges.dart';
import 'package:delibrary/src/screens/library.dart';
import 'package:delibrary/src/screens/position-search.dart';
import 'package:delibrary/src/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  int _selectedIndex = 0;
  List<Widget> _mainRoutes;
  Map<String, List<String>> _provinces;

  final User _user = User(
    username: "fratuslorenzo",
    name: "Lorenzo",
    surname: "Fratus",
    email: "fratus98@hotmail.it",
  );

  void initState() {
    super.initState();
    _fetchData().then((authenticated) {
      if (!authenticated)
        Navigator.pushReplacementNamed(context, "/login");
      else
        setState(() {
          _loading = false;
        });
    });
  }

  Future<bool> _fetchData() async {
    //TODO: send cookie to the server to check if it is valid
    //Maybe ask for the user? Ask also user properties and exchanges?

    await _fetchProvinces();

    return await _checkAuthentication();
  }

  Future<void> _fetchProvinces() async {
    PositionServices _positionServices = PositionServices();
    _provinces = await _positionServices.loadProvinces();
  }

  Future<bool> _checkAuthentication() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey("delibrary-cookie")) return false;
    String _cookie = _prefs.getString("delibrary-cookie");

    print(_cookie);
    return true;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _mainRoutes = [
      PositionSearchScreen(provinces: _provinces),
      LibraryScreen(),
      ExchangesScreen(),
      ProfileScreen(user: _user),
    ];

    if (_loading) return DelibraryLoading();

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
