import 'dart:convert';
import 'dart:io';

import 'package:delibrary/src/model/primary/user.dart';
import 'package:test/test.dart';

void main() {
  group('User', () {
    test('should correctly match another User with the same username', () {
      final User userA = User(username: 'Tester', email: 'emailA@email.com');
      final User userB = User(username: 'Tester', email: 'emailB@email.com');
      final User userC = User(username: 'TesterC', email: 'emailC@email.com');
      expect(userA.match(userB), true);
      expect(userB.match(userA), true);
      expect(userC.match(userA), false);
      expect(userB.match(userC), false);
    });
    test('should correctly generate a UserBuilder', () {
      final User user = User(
        username: 'Tester',
        name: 'Name',
        surname: 'Surname',
        email: 'email@email.com',
        password: 'Password00!',
      );
      expect(user.builder.toJson(), user.toJson());
    });
    test('should correctly be printed as a string', () {
      final User user = User(
        username: 'Tester',
        name: 'Name',
        surname: 'Surname',
        email: 'email@email.com',
        password: 'Password00!',
      );
      final String string =
          'Tester, Name, Surname, email@email.com, Password00!';
      expect(user.toString(), string);
    });
    test('should correctly be generated from JSON', () async {
      final File file = File('test_assets/user.json');
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());
      final User user = User.fromJson(json);

      expect(user.username, json["username"]);
      expect(user.name, json["name"]);
      expect(user.surname, json["surname"]);
      expect(user.email, json["email"]);
      expect(user.password, json["password"]);
    });
    test('should correctly be exported as JSON', () async {
      final File file = File('test_assets/user.json');
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());
      final Map<String, dynamic> user = User.fromJson(json).toJson();

      expect(user["username"], json["username"]);
      expect(user["name"], json["name"]);
      expect(user["surname"], json["surname"]);
      expect(user["email"], json["email"]);
      expect(user["password"], json["password"]);
    });
  });

  group('UserBuilder', () {
    test('should correctly be generated from a User', () {
      final User user = User(
        username: 'Tester',
        name: 'Name',
        surname: 'Surname',
        email: 'email@email.com',
        password: 'Password00!',
      );
      final UserBuilder builder = UserBuilder(user);

      expect(builder.toJson(), user.toJson());
    });
    test('should correctly generate a User', () {
      final User user = User(
        username: 'Tester',
        name: 'Name',
        surname: 'Surname',
        email: 'email@email.com',
        password: 'Password00!',
      );
      final UserBuilder builder = UserBuilder(user);
      final User newUser = builder.user;

      expect(newUser.toJson(), user.toJson());
    });
    test('should correctly get FieldData for all fields', () {
      final User user = User(
        username: 'Tester',
        name: 'Name',
        surname: 'Surname',
        email: 'email@email.com',
        password: 'Password00!',
      );
      final UserBuilder builder = UserBuilder(user);

      void check(field, text, [validator = true]) {
        expect(field.text, text);
        expect(field.label, isNot(null));
        expect(field.validator, validator ? isNot(null) : null);
        expect(field.obscurable, isNot(null));
      }

      check(builder.usernameField, user.username, false);
      check(builder.nameField, user.name);
      check(builder.surnameField, user.surname);
      check(builder.emailField, user.email);
      check(builder.passwordField, "");
      check(builder.confirmPasswordField, "");
    });
    test('should correctly set username', () {
      final UserBuilder builder = UserBuilder();
      String response;

      final String longer = 'X' * 256;
      response = builder.setUsername(longer);
      expect(response, isNot(null));

      final String empty = '';
      response = builder.setUsername(empty);
      expect(response, isNot(null));

      final String nulled = null;
      response = builder.setUsername(nulled);
      expect(response, isNot(null));

      final String valid = 'Value';
      response = builder.setUsername(valid);
      expect(response, null);

      final String overwrite = 'Value2';
      response = builder.setUsername(overwrite);
      expect(response, isNot(null));
    });
    test('should correctly set name', () {
      final UserBuilder builder = UserBuilder();
      String response;

      final String longer = 'X' * 256;
      response = builder.setName(longer);
      expect(response, isNot(null));

      final String valid = 'Value';
      response = builder.setName(valid);
      expect(response, null);

      final String overwrite = 'Value2';
      response = builder.setName(overwrite);
      expect(response, null);
    });
    test('should correctly set surname', () {
      final UserBuilder builder = UserBuilder();
      String response;

      final String longer = 'X' * 256;
      response = builder.setSurname(longer);
      expect(response, isNot(null));

      final String valid = 'Value';
      response = builder.setSurname(valid);
      expect(response, null);

      final String overwrite = 'Value2';
      response = builder.setSurname(overwrite);
      expect(response, null);
    });
    test('should correctly set email', () {
      final UserBuilder builder = UserBuilder();
      String response;

      final String longer = 'X' * 256;
      response = builder.setEmail(longer);
      expect(response, isNot(null));

      final String invalid = 'Invalid';
      response = builder.setEmail(invalid);
      expect(response, isNot(null));

      final String valid = 'abc@def.it';
      response = builder.setEmail(valid);
      expect(response, null);

      final String overwrite = 'def@abc.it';
      response = builder.setEmail(overwrite);
      expect(response, null);
    });
    test('should correctly set password', () {
      final UserBuilder builder = UserBuilder();
      String response;

      final String nulled = null;
      response = builder.setPassword(nulled);
      expect(response, isNot(null));

      final String shorter = 'X' * 7;
      response = builder.setPassword(shorter);
      expect(response, isNot(null));

      final String longer = 'X' * 256;
      response = builder.setPassword(longer);
      expect(response, isNot(null));

      final String noUpper = 'invalid00!';
      response = builder.setPassword(noUpper);
      expect(response, isNot(null));

      final String noLower = 'INVALID00!';
      response = builder.setPassword(noLower);
      expect(response, isNot(null));

      final String noNumber = 'INVALID!';
      response = builder.setPassword(noNumber);
      expect(response, isNot(null));

      final String noSymbol = 'Invalid00';
      response = builder.setPassword(noSymbol);
      expect(response, isNot(null));

      final String spaced = 'Invalid 00!';
      response = builder.setPassword(spaced);
      expect(response, isNot(null));

      final String valid = 'Valid00!';
      response = builder.setPassword(valid);
      expect(response, null);

      final String overwrite = 'Valid01!';
      response = builder.setPassword(overwrite);
      expect(response, null);
    });
    test('should correctly set confirm password', () {
      final UserBuilder builder = UserBuilder();
      String response;

      final String nulled = null;
      response = builder.confirmPassword(nulled);
      expect(response, isNot(null));

      final String valid = 'Valid00!';
      response = builder.confirmPassword(valid);
      expect(response, isNot(null));

      final String password = 'Password00!';
      builder.setPassword(password);

      final String invalid = 'Invalid00!';
      response = builder.confirmPassword(invalid);
      expect(response, isNot(null));

      response = builder.confirmPassword(password);
      expect(response, null);
    });
    test('should correctly be exported as JSON', () {
      final User user = User(
        username: 'Tester',
        name: 'Name',
        surname: 'Surname',
        email: 'email@email.com',
        password: 'Password00!',
      );
      final UserBuilder builder = UserBuilder(user);
      final Map<String, dynamic> json = builder.toJson();

      expect(json["username"], user.username);
      expect(json["name"], user.name);
      expect(json["surname"], user.surname);
      expect(json["email"], user.email);
      expect(json["password"], user.password);
    });
  });
}
