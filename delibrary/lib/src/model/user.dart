class User {
  String _username;
  String _name;
  String _surname;
  String _email;
  String _password;

  static const String _pattern =
      r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|" +
          r'"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final RegExp _emailExp = RegExp(_pattern);

  User({username, name, surname, email, password}) {
    _username = username;
    _name = name;
    _surname = surname;
    _email = email;
    _password = password;
  }

  String get username => _username;
  String get name => _name;
  String get surname => _surname;
  String get email => _email;
  String get password => _password;

  FieldData get usernameField =>
      FieldData(text: _username, label: "Username", validator: null);
  FieldData get nameField =>
      FieldData(text: _name, label: "Name", validator: setName);
  FieldData get surnameField =>
      FieldData(text: _surname, label: "Surname", validator: setSurname);
  FieldData get emailField =>
      FieldData(text: _email, label: "Email", validator: setEmail);
  FieldData get passwordField => FieldData(
      label: "Inserisci Password", validator: setPassword, obscurable: true);
  FieldData get confirmPasswordField => FieldData(
      label: "Conferma Password", validator: confirmPassword, obscurable: true);

  String setUsername(newValue) {
    if (_username != null) return "Non è possibile modificare l'username.";
    newValue = newValue.trim();
    if (newValue.length > 255)
      return "L'username non può eccedere i 255 caratteri.";
    if (newValue.isEmpty) return "L'username non può essere vuoto.";
    _username = newValue;
    return null;
  }

  String setName(newValue) {
    newValue = newValue.trim();
    if (newValue.length > 255)
      return "Il nome non può eccedere i 255 caratteri.";
    _name = newValue;
    return null;
  }

  String setSurname(newValue) {
    newValue = newValue.trim();
    if (newValue.length > 255)
      return "Il cognome non può eccedere i 255 caratteri.";
    _surname = newValue;
    return null;
  }

  String setEmail(newValue) {
    newValue = newValue.trim();
    if (newValue == null || newValue.isEmpty)
      return "L'email non può essere vuota.";
    if (newValue.length > 255)
      return "L'email non può eccedere i 255 caratteri.";
    if (!_emailExp.hasMatch(newValue))
      return "Inserisci un indirizzo email valido.";
    _email = newValue;
    return null;
  }

  String setPassword(newValue) {
    newValue = newValue.trim();
    if (newValue == null || newValue.length < 8)
      return "La password deve essere lunga almeno 8 caratteri.";
    if (newValue.length > 255)
      return "La password non può eccedere i 255 caratteri.";
    if (!newValue.contains(new RegExp(r'[A-Z]')))
      return "La password deve contenere almeno un carattere maiuscolo.";
    if (!newValue.contains(new RegExp(r'[a-z]')))
      return "La password deve contenere almeno un carattere minuscolo.";
    if (!newValue.contains(new RegExp(r'[0-9]')))
      return "La password deve contenere almeno un numero.";
    if (!newValue.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]')))
      return "La password deve contenere almeno un carattere speciale.";
    if (newValue.contains(new RegExp(r'\s')))
      return "La password non deve contenere spazi.";
    _password = newValue;
    return null;
  }

  String confirmPassword(confirmValue) {
    confirmValue = confirmValue.trim();
    if (_password == null) return "";
    if (confirmValue != _password) return "Le due password non coincidono.";
    return null;
  }

  void resetPassword() {
    _password = null;
  }

  void become(User user) {
    if (user == null || user.username != _username) return;
    _name = user.name;
    _surname = user.surname;
    _email = user.email;
    _password = user.password;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = Map<String, dynamic>();
    user["username"] = _username;
    user["name"] = _name;
    user["surname"] = _surname;
    user["email"] = _email;
    if (_password != null) user["password"] = _password;
    return user;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json["username"],
      name: json["name"],
      surname: json["surname"],
      email: json["email"],
      password: json["password"],
    );
  }

  factory User.copy(User user) {
    if (user == null) return User();
    return User(
      username: user.username,
      name: user.name,
      surname: user.surname,
      email: user.email,
      password: user.password,
    );
  }

  String toString() {
    return [_username, _name, _surname, _email, _password].join(", ");
  }
}

class FieldData {
  final String text;
  final String label;
  final Function validator;
  final bool obscurable;

  FieldData({
    this.text = "",
    this.label = "",
    this.validator,
    this.obscurable = false,
  });
}
