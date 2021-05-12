import 'package:delibrary/src/components/modals/confirm-modal.dart';
import 'package:delibrary/src/components/modals/position-modal.dart';
import 'package:delibrary/src/model/utils/position.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

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
          if (response.statusCode == 401)
            throw Exception("Delibrary server responded with 401, run away!");
          return response;
        },
      ));
  }

  String cleanParameter(String parameter,
      {bool caseSensitive = false, bool uriEncode = true}) {
    parameter = parameter.trim();
    if (!caseSensitive) parameter = parameter.toLowerCase();
    if (uriEncode) parameter = Uri.encodeComponent(parameter);
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

  // Returns true if the modal has been discarded by the user
  Future<Position> showPositionModal(BuildContext context) async {
    Position position;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PositionModal(
        onSubmit: (pos) {
          pop(context);
          position = pos;
        },
        onDiscard: () {
          pop(context);
        },
        provinces: context.read<Session>().provinces,
      ),
    );

    return position;
  }

  // Returns true if the user confirms the action
  Future<bool> showConfirmModal(
      BuildContext context, String description) async {
    bool confirm = false;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ConfirmModal(
        description: description,
        onSubmit: () {
          pop(context);
          confirm = true;
        },
        onDiscard: () {
          pop(context);
        },
      ),
    );

    return confirm;
  }

  void replace(BuildContext context, Widget route) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => route,
      ),
    );
  }

  void navigateTo(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  void pop(BuildContext context) {
    Navigator.pop(context);
  }
}

class ErrorMessage {
  static const String alreadyInProperties =
      "Questo libro è già nella tua libreria";
  static const String alreadyInWishes = "Questo libro è già nella tua wishlist";
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

  static String alreadyInExchange =
      "Questa proprietà è già coinvolta in uno scambio";
}

class ConfirmMessage {
  static const String passwordUpdated = "Password aggiornata!";
  static const String propertyAdded = "Libro aggiunto alla libreria!";
  static const String propertyMoved = "Libro spostato nella wishlist!";
  static const String propertyRemoved = "Libro rimosso dalla libreria!";
  static const String userUpdated = "Profilo aggiornato!";
  static const String wishAdded = "Libro aggiunto alla wishlist!";
  static const String wishMoved = "Libro spostato nella libreria!";
  static const String wishRemoved = "Libro rimosso dalla wishlist!";

  static const String exchangeRemoved = "Scambio annullato con successo!";
  static const String exchangeAdded = "Scambio proposto con successo!";
  static const String exchangeRefused = "Scambio rifiutato con successo!";
  static const String exchangeHappened = "Scambio completato con successo!";
  static const String exchangeAgreed = "Scambio accettato con successo!";
}
