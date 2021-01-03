import 'package:flutter/material.dart';

class DelibraryNavigationBar extends BottomNavigationBar {
  static const String _label = "•";

  DelibraryNavigationBar({currentIndex, onTap})
      : super(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: _label,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.collections_bookmark),
              label: _label,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.comment_bank),
              label: _label,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: _label,
            ),
          ],
          currentIndex: currentIndex,
          onTap: onTap,
          selectedItemColor: Colors.amber[700],
          unselectedItemColor: Colors.white70,
          selectedFontSize: 20.0,
          showUnselectedLabels: false,
        );
}
