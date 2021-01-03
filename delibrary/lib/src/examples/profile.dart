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
  bool _editing = false;

  final _formKey = GlobalKey<FormState>();

  String name = "Lorenzo";
  String _nameValidator(newValue) {
    if (newValue.isEmpty) return "Il nome non può essere vuoto.";
    name = newValue;
    return null;
  }

  String surname = "Fratus";
  String _surnameValidator(newValue) {
    if (newValue.isEmpty) return "Il cognome non può essere vuoto.";
    surname = newValue;
    return null;
  }

  void _toggleEditing() {
    if (_editing) {
      if (_formKey.currentState.validate())
        _printData();
      else
        return;
    }
    setState(() {
      _editing = !_editing;
    });
  }

  void _printData() {
    print(name);
    print(surname);
  }

  Widget _editableTextField(textValue, validator) {
    TextEditingController _controller = TextEditingController(text: textValue);
    if (_editing)
      return TextFormField(
        validator: (newValue) => validator(newValue),
        controller: _controller,
      );
    return Text(textValue);
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
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _editableTextField(name, _nameValidator),
                  _editableTextField(surname, _surnameValidator),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleEditing,
        tooltip: 'Edit',
        child: Icon(_editing ? Icons.done : Icons.edit),
      ),
    );
  }
}
