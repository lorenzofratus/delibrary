import 'package:delibrary/src/components/button.dart';
import 'package:delibrary/src/components/editable-field.dart';
import 'package:delibrary/src/components/page-title.dart';
import 'package:delibrary/src/model/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final bool editable;

  ProfilePage({this.user, this.editable = false});

  @override
  State<StatefulWidget> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<ProfilePage> {
  final _profileKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  bool _editingProfile = false;
  bool _editingPassword = false;

  void _toggleProfileEdit() {
    if (_editingProfile) {
      if (!_profileKey.currentState.validate()) return;
      _updateProfile();
    }
    setState(() {
      _editingProfile = !_editingProfile;
    });
  }

  void _togglePasswordEdit() {
    if (_editingPassword) {
      if (!_passwordKey.currentState.validate()) return;
      _updatePassword();
    }
    setState(() {
      _editingPassword = !_editingPassword;
    });
  }

  void _cancelPasswordEdit() {
    _passwordKey.currentState.reset();
    widget.user.resetPassword();
    setState(() {
      _editingPassword = false;
    });
  }

  void _updateProfile() {
    //TODO: send update to the server
    print("Profile updated");
    print(widget.user.toString());
  }

  void _updatePassword() {
    //TODO: send update to the server
    print("Password updated");
    print(widget.user.toString());
    widget.user.resetPassword();
  }

  void _logout() async {
    //TODO: send logout to the server to invalidate the session
    //Should be done by the service
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove("delibrary-cookie");
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(50.0),
      children: [
        PageTitle(
          "Il tuo profilo",
          action: this._logout,
          actionIcon: Icons.exit_to_app,
        ),
        _ProfileForm(
          formKey: _profileKey,
          title: "Informazioni Personali",
          children: [
            EditableFormField(
              text: widget.user.username,
              label: "Username",
              editing: false,
              validator: null,
            ),
            EditableFormField(
              text: widget.user.name,
              label: "Name",
              editing: this._editingProfile,
              validator: widget.user.setName,
            ),
            EditableFormField(
              text: widget.user.surname,
              label: "Surname",
              editing: this._editingProfile,
              validator: widget.user.setSurname,
            ),
            EditableFormField(
              text: widget.user.email,
              label: "Email",
              editing: this._editingProfile,
              validator: widget.user.setEmail,
            ),
          ],
        ),
        DelibraryButton(
          text: this._editingProfile ? "Salva Profilo" : "Modifica Profilo",
          onPressed: _toggleProfileEdit,
          primary: this._editingProfile,
        ),
        _ProfileForm(
          formKey: _passwordKey,
          title: "Password",
          children: [
            EditableFormField(
              label: "Inserisci Password",
              editing: this._editingPassword,
              validator: widget.user.setPassword,
            ),
            EditableFormField(
              label: "Ripeti Password",
              editing: this._editingPassword,
              validator: widget.user.confirmPassword,
            ),
          ],
        ),
        DelibraryButton(
          text: this._editingPassword ? "Salva Password" : "Modifica Password",
          onPressed: _togglePasswordEdit,
          primary: this._editingPassword,
        ),
        if (this._editingPassword)
          DelibraryButton(
            text: "Annulla Modifica",
            onPressed: _cancelPasswordEdit,
            primary: false,
          ),
      ],
    );
  }
}

class _ProfileForm extends StatelessWidget {
  final Key formKey;
  final String title;
  final List<Widget> children;

  _ProfileForm({this.formKey, this.title, this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      padding: EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Form(
        key: this.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              this.title,
              style: Theme.of(context).textTheme.headline5.copyWith(
                    color: Theme.of(context).accentColor,
                  ),
            ),
            for (Widget child in this.children) child,
          ],
        ),
      ),
    );
  }
}
