import 'package:delibrary/src/components/utils/button.dart';
import 'package:delibrary/src/components/utils/logo.dart';
import 'package:delibrary/src/components/form-fields/search-field.dart';
import 'package:delibrary/src/controller/internal/user-services.dart';
import 'package:delibrary/src/model/primary/user.dart';
import 'package:delibrary/src/components/utils/padded-container.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  UserBuilder _tempUser;
  bool _loading;

  void initState() {
    super.initState();
    _resetTempUser();
    _loading = false;
  }

  void _resetTempUser() {
    _tempUser = UserBuilder();
  }

  void _disableRequests() {
    setState(() {
      _loading = true;
    });
  }

  void _enableRequests() {
    setState(() {
      _loading = false;
    });
  }

  void _validateUser() async {
    if (_formKey.currentState.validate()) {
      _disableRequests();
      await UserServices().loginUser(_tempUser.user, context);
    }
    _resetTempUser();
    _enableRequests();
  }

  void _goToRegister() {
    if (!_loading) Navigator.pushReplacementNamed(context, "/register");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
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
                        validator: _tempUser.setPassword,
                        hint: "Password",
                        obscurable: true,
                      ),
                    ],
                  ),
                ),
                if (_loading)
                  LoadingButton()
                else
                  DelibraryButton(text: "Login", onPressed: _validateUser),
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: InkWell(
                    onTap: _goToRegister,
                    child: Text(
                      "Non hai un account? Registrati",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
