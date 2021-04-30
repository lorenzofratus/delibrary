import 'package:delibrary/src/controller/book-services.dart';
import 'package:delibrary/src/controller/services.dart';
import 'package:delibrary/src/model/action.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/exchange-list.dart';
import 'package:delibrary/src/model/exchange.dart';
import 'package:delibrary/src/model/property.dart';
import 'package:delibrary/src/model/temp-exchange-list.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:delibrary/src/model/temp-exchange.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExchangeServices extends Services {
  ExchangeServices()
      : super(BaseOptions(
            baseUrl: "https://delibrary.herokuapp.com/v1/",
            connectTimeout: 20000,
            receiveTimeout: 20000));

  Future<Exchange> _getExchangeFromTempExchange(
      TempExchange tempExchange) async {
    BookServices bookServices = BookServices();
    Book property = await bookServices.getById(tempExchange.property.bookId);
    Book payment = tempExchange.payment != null
        ? await bookServices.getById(tempExchange.payment.bookId)
        : null;
    return Exchange.fromTemp(tempExchange, property, payment);
  }

  Future<ExchangeList> _getExchangesFromTempExchanges(
      List<TempExchange> tempExchangeList) async {
    print(
        "[Exchange services] Getting info for each book from Google Books...");
    List<Exchange> exchangeList = [];

    await Future.forEach(tempExchangeList, (tempExchange) async {
      Exchange exchange = await _getExchangeFromTempExchange(tempExchange);
      exchangeList.add(exchange);
    });

    return ExchangeList(items: exchangeList);
  }

  DelibraryAction propose(Property property) {
    return DelibraryAction(
      text: "Proponi uno scambio",
      execute: (BuildContext context) async {
        Session session = context.read<Session>();
        String username = session.user.username;

        Response response;

        try {
          response = await dio.post("users/$username/exchanges/new", data: {
            "sellerUsername": property.ownerUsername,
            "propertyId": property.id,
          });
        } on DioError catch (e) {
          if (e.response != null) {
            if (e.response.statusCode == 404)
              return showSnackBar(context, ErrorMessage.userNotFound);
            if (e.response.statusCode == 409)
              return showSnackBar(context, ErrorMessage.alreadyInExchange);
            if (e.response.statusCode == 500)
              return showSnackBar(context, ErrorMessage.serverError);
            // Otherwise, unexpected error, print and raise exception
            errorOnResponse(e);
          } else {
            // Generic error before the request is sent, print
            errorOnRequest(e, false);
            return showSnackBar(context, ErrorMessage.checkConnection);
          }
        }

        TempExchange tempExchange = TempExchange.fromJson(response.data);
        Exchange exchange = await _getExchangeFromTempExchange(tempExchange);
        session.addExchange(exchange);
        showSnackBar(context, ConfirmMessage.exchangeAdded);
      },
    );
  }

  DelibraryAction refuse(Exchange exchange) {
    return DelibraryAction(
      text: "Rifiuta lo scambio",
      execute: (BuildContext context) async {
        Session session = context.read<Session>();
        String username = session.user.username;

        try {
          await dio.put("users/$username/exchanges/${exchange.id}");
        } on DioError catch (e) {
          if (e.response != null) {
            if (e.response.statusCode == 404)
              return showSnackBar(context, ErrorMessage.userNotFound);
            if (e.response.statusCode == 500)
              return showSnackBar(context, ErrorMessage.serverError);
            // Otherwise, unexpected error, print and raise exception
            errorOnResponse(e);
          } else {
            // Generic error before the request is sent, print
            errorOnRequest(e, false);
            return showSnackBar(context, ErrorMessage.checkConnection);
          }
        }

        // Property removed successfully, update session
        session.refuse(exchange);
        showSnackBar(context, ConfirmMessage.exchangeRefused);
      },
    );
  }

  DelibraryAction remove(Exchange exchange) {
    return DelibraryAction(
      text: "Annulla lo scambio",
      execute: (BuildContext context) async {
        Session session = context.read<Session>();
        String username = session.user.username;

        try {
          await dio.delete("users/$username/exchanges/${exchange.id}/refuse");
        } on DioError catch (e) {
          if (e.response != null) {
            if (e.response.statusCode == 404)
              return showSnackBar(context, ErrorMessage.userNotFound);
            if (e.response.statusCode == 500)
              return showSnackBar(context, ErrorMessage.serverError);
            // Otherwise, unexpected error, print and raise exception
            errorOnResponse(e);
          } else {
            // Generic error before the request is sent, print
            errorOnRequest(e, false);
            return showSnackBar(context, ErrorMessage.checkConnection);
          }
        }

        // Property removed successfully, update session
        session.removeExchange(exchange);
        showSnackBar(context, ConfirmMessage.exchangeRemoved);
      },
    );
  }

  DelibraryAction agree(Exchange exchange) {
    return DelibraryAction(
        text: "Accetta lo scambio",
        execute: (BuildContext context) async {/* TODO */});
  }

  DelibraryAction happen(Exchange exchange) {
    return DelibraryAction(
      text: "Scambio completato",
      execute: (BuildContext context) async {
        Session session = context.read<Session>();
        String username = session.user.username;

        try {
          await dio.put("users/$username/exchanges/${exchange.id}/happen");
        } on DioError catch (e) {
          if (e.response != null) {
            if (e.response.statusCode == 404)
              return showSnackBar(context, ErrorMessage.userNotFound);
            if (e.response.statusCode == 500)
              return showSnackBar(context, ErrorMessage.serverError);
            // Otherwise, unexpected error, print and raise exception
            errorOnResponse(e);
          } else {
            // Generic error before the request is sent, print
            errorOnRequest(e, false);
            return showSnackBar(context, ErrorMessage.checkConnection);
          }
        }

        // Property removed successfully, update session
        session.happen(exchange);
        showSnackBar(context, ConfirmMessage.exchangeHappened);
      },
    );
  }

  Future<void> updateSession(BuildContext context) async {
    print("[Exchange services] Getting exchanges from Delibrary...");

    Response response;
    Session session = context.read<Session>();
    String username = session.user.username;

    try {
      response = await dio.get("users/$username/exchanges");
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 404)
          return showSnackBar(context, ErrorMessage.userNotFound);
        if (e.response.statusCode == 500)
          return showSnackBar(context, ErrorMessage.serverError);
        errorOnResponse(e);
      } else {
        errorOnRequest(e, false);
        return showSnackBar(context, ErrorMessage.checkConnection);
      }
    }

    // Exchanges list fetched, parse and update session
    TempExchangeList tempExchangeList =
        TempExchangeList.fromJson(response.data);
    session.exchanges =
        await _getExchangesFromTempExchanges(tempExchangeList.exchanges);
  }
}
