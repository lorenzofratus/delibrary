import 'package:delibrary/src/components/utils/padded-grid.dart';
import 'package:delibrary/src/components/utils/page-title.dart';
import 'package:delibrary/src/components/sections/form.dart';
import 'package:delibrary/src/controller/internal/user-services.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:delibrary/src/model/primary/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileScreen> {
  final _profileKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  bool _editingProfile = false;
  bool _editingPassword = false;
  UserBuilder _tempUser;

  void initState() {
    super.initState();
    _resetTempUser();
  }

  void _resetTempUser() {
    _tempUser = context.read<Session>().user.builder;
  }

  void _startEditingProfile() {
    setState(() {
      _editingProfile = true;
    });
  }

  void _saveEditingProfile() {
    if (!_profileKey.currentState.validate()) return;
    _sendUpdate(_cancelEditingProfile);
  }

  void _cancelEditingProfile() {
    _resetTempUser();
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
    _sendUpdate(_cancelEditingPassword);
  }

  void _cancelEditingPassword() {
    _passwordKey.currentState.reset();
    _resetTempUser();
    setState(() {
      _editingPassword = false;
    });
  }

  Future<void> _sendUpdate(Function callback) async {
    await UserServices().updateUser(_tempUser.user, context);
    callback();
  }

  Future<void> _logoutUser() async {
    await UserServices().logoutUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return PaddedGrid(
      grid: false,
      maxWidth: 410.0,
      leading: [
        PageTitle(
          "Il tuo profilo",
          action: _logoutUser,
          actionIcon: Icons.exit_to_app,
        ),
      ],
      children: [
        FormSectionContainer(
          title: "Dati",
          formKey: _profileKey,
          editing: _editingProfile,
          startEditing: _startEditingProfile,
          saveEditing: _saveEditingProfile,
          cancelEditing: _cancelEditingProfile,
          fields: [
            _tempUser.usernameField,
            _tempUser.nameField,
            _tempUser.surnameField,
            _tempUser.emailField,
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
            _tempUser.passwordField,
            _tempUser.confirmPasswordField,
          ],
        ),
      ],
    );
  }
}
