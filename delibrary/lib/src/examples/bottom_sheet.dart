import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _isbnController = TextEditingController();
  String _isbn = "";
  void _setIsbn(newValue) {
    setState(() {
      _isbn = newValue;
    });
  }

  Future _askUser() async {
    _setIsbn(await showDialog(
        context: context,
        child: new SimpleDialog(
          title: null,
          children: [
            new TextField(controller: _isbnController),
            new TextButton(
                onPressed: () {
                  Navigator.pop(context, _isbnController.value);
                },
                child: Text("Add Book")),
          ],
        )));
    print(_isbn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _askUser();
        },
        child: new Icon(Icons.add),
      ),
    );
  }
}
