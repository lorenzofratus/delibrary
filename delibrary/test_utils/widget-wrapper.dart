part of test_utils;

class WidgetWrapper {
  Widget scaffold(Widget body) {
    return ChangeNotifierProvider(
      create: (context) => Session(),
      child: Layout(
        child: MaterialApp(
          home: Scaffold(
            body: body,
          ),
        ),
      ),
    );
  }

  Widget app(Widget home, [Session session]) {
    return ChangeNotifierProvider(
      create: (context) => session ?? Session(),
      child: Layout(
        child: MaterialApp(home: home),
      ),
    );
  }
}
