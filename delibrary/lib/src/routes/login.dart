import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/logo.dart';
import 'package:delibrary/src/components/search-field.dart';
import 'package:delibrary/src/controller/envelope.dart';
import 'package:delibrary/src/controller/user-services.dart';
import 'package:delibrary/src/model/user.dart';
import 'package:delibrary/src/shortcuts/padded-container.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  User _tempUser;
  bool _loading;

  void initState() {
    super.initState();
    _resetTempUser();
    _loading = false;
  }

  void _resetTempUser() {
    _tempUser = User();
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
      UserServices userServices = UserServices();
      Envelope<User> response = await userServices.loginUser(_tempUser);
      if (response.error != null)
        ScaffoldMessenger.of(context).showSnackBar(response.message);
      else
        Navigator.pushReplacementNamed(context, "/");
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
      ),
    );
  }
}
