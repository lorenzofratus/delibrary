import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Services {
  final Dio dio = new Dio();
  final String customCookie = "delibrary-cookie";

  Services(BaseOptions dioOptions, [bool externalServices = false]) {
    dio.options = dioOptions;
    if (!externalServices)
      dio.interceptors.add(InterceptorsWrapper(
        // Add the delibrary-cookie to all the requests
        onRequest: (Options options) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String cookie = prefs.getString(customCookie);
          dio.interceptors.requestLock.lock();
          options.headers["cookie"] = cookie;
          dio.interceptors.requestLock.unlock();
          return options;
        },
        //Manage redirect on 401 statusCode
        onResponse: (Response response) async {
          //TODO
          if (response.statusCode == 401) print("Redirect");
          return response;
        },
      ));
  }

  String cleanParameter(String parameter, {bool caseSensitive = false}) {
    parameter = parameter.trim();
    if (!caseSensitive) parameter = parameter.toLowerCase();
    parameter = Uri.encodeComponent(parameter);
    return parameter;
  }

  void errorOnResponse(DioError e, [bool raise = true]) {
    print(e.response.data);
    print(e.response.headers);
    print(e.response.request);
    if (raise)
      throw Exception("Server responsed with ${e.response.statusCode}");
  }

  void errorOnRequest(DioError e, [bool raise = true]) {
    print(e.request);
    print(e.message);
    if (raise)
      throw Exception(
          "Error while setting up or sending the request to the server");
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void navigateTo(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}

class ErrorMessage {
  static const String checkConnection =
      "Non è stato possibile contattare il server, controlla la connessione.";
  static const String emptyFields = "Compila tutti i campi obbligatori.";
  static const String emptyUsername = "L'username da cercare è vuoto o nullo.";
  static const String externalServiceError =
      "Un servizio esterno non è attualmente disponibile, riprova più tardi.";
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

class ConfirmMessage {
  static const String passwordUpdated = "Password aggiornata!";
  static const String userUpdated = "Profilo aggiornato!";
}
