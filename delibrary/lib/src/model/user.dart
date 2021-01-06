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
    this._username = username;
    this._name = name;
    this._surname = surname;
    this._email = email;
    this._password = password;
  }

  String get username => this._username;
  String get name => this._name;
  String get surname => this._surname;
  String get email => this._email;

  String setUsername(newValue) {
    if (this._username != null) return "Non è possibile modificare l'username.";
    newValue = newValue.trim();
    if (newValue.length > 255)
      return "L'username non può eccedere i 255 caratteri.";
    if (newValue.isEmpty) return "L'username non può essere vuoto.";
    this._username = newValue;
    return null;
  }

  String setName(newValue) {
    newValue = newValue.trim();
    if (newValue.length > 255)
      return "Il nome non può eccedere i 255 caratteri.";
    this._name = newValue;
    return null;
  }

  String setSurname(newValue) {
    newValue = newValue.trim();
    if (newValue.length > 255)
      return "Il cognome non può eccedere i 255 caratteri.";
    this._surname = newValue;
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
    this._email = newValue;
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
    this._password = newValue;
    return null;
  }

  String confirmPassword(confirmValue) {
    confirmValue = confirmValue.trim();
    if (this._password == null) return "";
    if (confirmValue != this._password)
      return "Le due password non coincidono.";
    return null;
  }

  void resetPassword() {
    this._password = null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = Map<String, dynamic>();
    user["username"] = this._username;
    user["name"] = this._name;
    user["surname"] = this._surname;
    user["email"] = this._email;
    user["password"] = this._password;
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

  String toString() {
    return [
      this._username,
      this._name,
      this._surname,
      this._email,
      this._password
    ].join(", ");
  }
}
