import 'package:delibrary/src/routes/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(DelibraryApp());

ThemeData _delibraryTheme = ThemeData(
  brightness: Brightness.dark,
  cardColor: Colors.white12,
  accentColor: Colors.amber[700],
  fontFamily: "Lato",
  textTheme: TextTheme(
    headline4: TextStyle(fontSize: 28.0),
    headline5: TextStyle(fontSize: 22.0),
    headline6: TextStyle(fontSize: 16.0),
    button: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w800,
    ),
  ),
);

class DelibraryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Delibrary",
      theme: _delibraryTheme,
      themeMode: ThemeMode.dark,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('it'),
      ],
      locale: const Locale('it'),
      home: HomePage(),
    );
  }
}
