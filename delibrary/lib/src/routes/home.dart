import 'package:delibrary/src/components/loading.dart';
import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/components/navigation-bar.dart';
import 'package:delibrary/src/controller/position-services.dart';
import 'package:delibrary/src/controller/user-services.dart';
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
  User _user;

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
    await _fetchProvinces();
    return await _checkAuthentication();
  }

  Future<void> _fetchProvinces() async {
    PositionServices _positionServices = PositionServices();
    _provinces = await _positionServices.loadProvinces();
  }

  Future<bool> _checkAuthentication() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey("delibrary-user")) return false;
    String username = _prefs.getString("delibrary-user");
    UserServices userServices = UserServices();
    User response = await userServices.getUser(username);
    if (response == null) return false;
    _user = response;
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
