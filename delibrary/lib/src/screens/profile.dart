import 'package:delibrary/src/components/page-title.dart';
import 'package:delibrary/src/components/section-container.dart';
import 'package:delibrary/src/controller/user-services.dart';
import 'package:delibrary/src/model/user.dart';
import 'package:delibrary/src/shortcuts/padded-list-view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({this.user});

  @override
  State<StatefulWidget> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<ProfileScreen> {
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
    _sendUpdate().then((result) {
      //TODO: show confirmation message to the user
    });
    setState(() {
      _editingProfile = false;
    });
  }

  void _cancelEditingProfile() {
    setState(() {
      _editingProfile = false;
    });
  }

  void _startEditingPassword() {
    setState(() {
      _editingPassword = true;
    });
  }

  void _saveEditingPassword() {
    if (!_passwordKey.currentState.validate()) return;
    _sendUpdate().then((result) {
      //TODO: show confirmation message to the user
      widget.user.resetPassword();
    });
    setState(() {
      _editingPassword = false;
    });
  }

  void _cancelEditingPassword() {
    _passwordKey.currentState.reset();
    widget.user.resetPassword();
    setState(() {
      _editingPassword = false;
    });
  }

  Future<bool> _sendUpdate() async {
    UserServices userServices = UserServices();
    User response = await userServices.updateUser(widget.user);
    return response != null;
  }

  Future<void> _logout() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove("delibrary-user");
    UserServices userServices = UserServices();
    await userServices.logoutUser();
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return PaddedListView(
      children: [
        PageTitle(
          "Il tuo profilo",
          action: _logout,
          actionIcon: Icons.exit_to_app,
        ),
        FormSectionContainer(
          title: "Dati",
          formKey: _profileKey,
          editing: _editingProfile,
          startEditing: _startEditingProfile,
          saveEditing: _saveEditingProfile,
          cancelEditing: _cancelEditingProfile,
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
