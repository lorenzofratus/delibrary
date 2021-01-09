import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/components/search-field.dart';
import 'package:delibrary/src/model/user.dart';
import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  SharedPreferences _prefs;
  User _tempUser;

  void initState() async {
    super.initState();
    _tempUser = User();
    _prefs = await SharedPreferences.getInstance();
  }

  void _validateUser() async {
    if (_formKey.currentState.validate()) {
      // TODO send credentials to the server and wait the response
      print(_tempUser);
      // Should be set by the service
      _prefs.setString("delibrary-cookie", "Cookie inviato dal server");
      Navigator.pushReplacementNamed(context, "/");
    }
    setState(() {
      _tempUser = User();
    });
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PaddedContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DelibraryLogo(large: true),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30.0),
                child: Text("Benvenuto!",
                    style: Theme.of(context).textTheme.headline4),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SearchFormField(validator: _tempUser.setName, hint: "Nome"),
                    SearchFormField(
                        validator: _tempUser.setSurname, hint: "Cognome"),
                    SearchFormField(
                        validator: _tempUser.setEmail, hint: "Email"),
                    SearchFormField(
                        validator: _tempUser.setUsername, hint: "Username"),
                    SearchFormField(
                        validator: _tempUser.setPassword, hint: "Password"),
                  ],
                ),
              ),
              DelibraryButton(text: "Registrati", onPressed: _validateUser),
              Container(
                margin: EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: _goToLogin,
                  child: Text(
                    "Già registrato? Login",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
