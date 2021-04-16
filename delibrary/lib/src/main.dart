import 'package:delibrary/src/routes/global-search.dart';
import 'package:delibrary/src/routes/home.dart';
import 'package:delibrary/src/routes/login.dart';
import 'package:delibrary/src/routes/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'model/session.dart';

final ThemeData _delibraryTheme = ThemeData(
  brightness: Brightness.dark,
  cardColor: Colors.white12,
  accentColor: Colors.amber[700],
  fontFamily: "Lato",
  textTheme: TextTheme(
    headline4: TextStyle(fontSize: 28.0),
    headline5: TextStyle(fontSize: 22.0),
    headline6: TextStyle(fontSize: 18.0, color: Colors.white70),
    button: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w800,
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0),
    ),
  ),
);

class ScrollBehaviorModified extends ScrollBehavior {
  const ScrollBehaviorModified();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
        return const BouncingScrollPhysics();
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
    return null;
  }
}

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => Session(),
        child: DelibraryApp(),
      ),
    );

class DelibraryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Force portrait mode of the App
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
      builder: (context, child) =>
          ScrollConfiguration(behavior: ScrollBehaviorModified(), child: child),
      supportedLocales: [
        const Locale('it'),
      ],
      locale: const Locale('it'),
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/search": (context) => GlobalSearchPage(),
      },
    );
  }
}
