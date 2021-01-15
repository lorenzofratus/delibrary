import 'package:flutter/material.dart';

class Envelope<T> {
  final T payload;
  final String error;

  Envelope({this.payload, this.error})
      : assert((payload != null) ^ (error != null));

  Widget get message => SnackBar(content: Text(error));
}

class ErrorMessage {
  static const String checkConnection =
      "Non è stato possibile contattare il server, controlla la connessione.";
  static const String emptyFields = "Compila tutti i campi obbligatori.";
  static const String forbidden =
      "Stai tentando di modificare una risorsa a cui non hai accesso.";
  static const String serverError =
      "Il servizio non è momentaneamente disponibile, riprova più tardi";
  static const String usernameInUse = "L'username inserito è già in uso.";
  static const String userNotFound =
      "Il server non ha trovato l'utente cercato.";
  static const String wrongCredentials =
      "L'username o la password inseriti non sono validi.";
}
