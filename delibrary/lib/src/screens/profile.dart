import 'package:delibrary/src/components/page-title.dart';
import 'package:delibrary/src/components/section-container.dart';
import 'package:delibrary/src/controller/envelope.dart';
import 'package:delibrary/src/controller/user-services.dart';
import 'package:delibrary/src/model/user.dart';
import 'package:delibrary/src/shortcuts/padded-list-view.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({@required this.user});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileScreen> {
  final _profileKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  bool _editingProfile = false;
  bool _editingPassword = false;
  User _tempUser;

  void initState() {
    super.initState();
    _resetTempUser();
  }

  void _resetTempUser() {
    _tempUser = User.copy(widget.user);
  }

  void _startEditingProfile() {
    setState(() {
      _editingProfile = true;
    });
  }

  void _saveEditingProfile() {
    if (!_profileKey.currentState.validate()) return;
    _sendUpdate("Profilo aggiornato!").then((_) => _cancelEditingProfile());
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
    _sendUpdate("Password aggiornata!").then((_) => _cancelEditingPassword());
  }

  void _cancelEditingPassword() {
    _passwordKey.currentState.reset();
    _resetTempUser();
    setState(() {
      _editingPassword = false;
    });
  }

  Future<void> _sendUpdate(String successMsg) async {
    UserServices userServices = UserServices();
    Envelope<User> response = await userServices.updateUser(_tempUser);
    if (response.error != null)
      Scaffold.of(context).showSnackBar(response.message);
    else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(successMsg)));
      widget.user.become(response.payload);
    }
  }

  Future<void> _logoutUser() async {
    UserServices userServices = UserServices();
    Envelope response = await userServices.logoutUser();
    if (response.error != null)
      Scaffold.of(context).showSnackBar(response.message);
    else
      Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return PaddedListView(
      children: [
        PageTitle(
          "Il tuo profilo",
          action: _logoutUser,
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
