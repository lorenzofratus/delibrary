import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/components/navigation-bar.dart';
import 'package:delibrary/src/controller/position-services.dart';
import 'package:delibrary/src/controller/user-services.dart';
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
  Map<String, List<String>> _provinces;

  void initState() {
    super.initState();
    //TODO: move "then" in the service itself (leave only setState)
    UserServices().validateUser(context).then((authenticated) {
      if (!authenticated)
        Navigator.pushReplacementNamed(context, "/login");
      else
        _fetchData().then((_) {
          setState(() {
            _loading = false;
          });
        });
    });
  }

  Future<void> _fetchData() async {
    await _fetchProvinces();
  }

  Future<void> _fetchProvinces() async {
    PositionServices positionServices = PositionServices();
    _provinces = await positionServices.loadProvinces();
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
