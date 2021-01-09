import 'package:delibrary/src/components/page-title.dart';
import 'package:delibrary/src/components/section-container.dart';
import 'package:delibrary/src/model/user.dart';
import 'package:delibrary/src/shortcuts/padded-list-view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  ProfilePage({this.user});

  @override
  State<StatefulWidget> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<ProfilePage> {
  final _profileKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  bool _editingProfile = false;
  bool _editingPassword = false;

  void _startEditingProfile() {
    setState(() {
      _editingProfile = true;
    });
  }

  void _saveEditingProfile() {
    if (!_profileKey.currentState.validate()) return;
    _updateProfile();
    setState(() {
      _editingProfile = false;
    });
  }

  void _startEditingPassword() {
    setState(() {
      _editingProfile = true;
    });
  }

  void _saveEditingPassword() {
    if (!_profileKey.currentState.validate()) return;
    _updatePassword();
    setState(() {
      _editingProfile = false;
    });
  }

  void _cancelEditingPassword() {
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
    return PaddedListView(
      children: [
        PageTitle(
          "Il tuo profilo",
          action: this._logout,
          actionIcon: Icons.exit_to_app,
        ),
        FormSectionContainer(
          title: "Dati",
          formKey: _profileKey,
          editing: _editingProfile,
          startEditing: _startEditingProfile,
          saveEditing: _saveEditingProfile,
          fields: [
            widget.user.usernameField,
            widget.user.nameField,
            widget.user.surnameField,
            widget.user.emailField,
          ],
        ),
        FormSectionContainer(
          title: "Password",
          formKey: _passwordKey,
          editing: _editingPassword,
          startEditing: _startEditingPassword,
          saveEditing: _saveEditingPassword,
          cancelEditing: _cancelEditingPassword,
          fields: [
            widget.user.passwordField,
            widget.user.confirmPasswordField,
          ],
        ),
      ],
    );
  }
}
