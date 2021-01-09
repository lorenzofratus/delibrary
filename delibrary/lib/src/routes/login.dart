import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/components/search-field.dart';
import 'package:delibrary/src/model/user.dart';
import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  SharedPreferences _prefs;
  User _tempUser;

  void initState() {
    super.initState();
    _tempUser = User();
    SharedPreferences.getInstance().then((prefs) => _prefs = prefs);
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

  void _goToRegister() {
    Navigator.pushReplacementNamed(context, "/register");
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
                child: Text("Bentornato!",
                    style: Theme.of(context).textTheme.headline4),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SearchFormField(
                        validator: _tempUser.setUsername, hint: "Username"),
                    SearchFormField(
                        validator: _tempUser.setPassword, hint: "Password"),
                  ],
                ),
              ),
              DelibraryButton(text: "Login", onPressed: _validateUser),
              Container(
                margin: EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: _goToRegister,
                  child: Text(
                    "Non hai un account? Registrati",
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
