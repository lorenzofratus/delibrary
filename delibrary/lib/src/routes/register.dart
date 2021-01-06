import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/components/search-field.dart';
import 'package:delibrary/src/model/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  SharedPreferences _prefs;
  User user;

  void initState() async {
    super.initState();
    user = User();
    _prefs = await SharedPreferences.getInstance();
  }

  void _validateUser() async {
    if (this._formKey.currentState.validate()) {
      // TODO send credentials to the server and wait the response
      print(user);
      // Should be set by the service
      _prefs.setString("delibrary-cookie", "Cookie inviato dal server");
      Navigator.pushReplacementNamed(context, "/");
    }
    setState(() {
      user = User();
    });
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(50.0),
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
                key: this._formKey,
                child: Column(
                  children: [
                    SearchFormField(validator: this.user.setName, hint: "Nome"),
                    SearchFormField(
                        validator: this.user.setSurname, hint: "Cognome"),
                    SearchFormField(
                        validator: this.user.setEmail, hint: "Email"),
                    SearchFormField(
                        validator: this.user.setUsername, hint: "Username"),
                    SearchFormField(
                        validator: this.user.setPassword, hint: "Password"),
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
