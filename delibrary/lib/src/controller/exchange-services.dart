import 'package:delibrary/src/controller/property-services.dart';
import 'package:delibrary/src/controller/services.dart';
import 'package:delibrary/src/model/utils/action.dart';
import 'package:delibrary/src/model/primary/book.dart';
import 'package:delibrary/src/model/primary/exchange-list.dart';
import 'package:delibrary/src/model/primary/exchange.dart';
import 'package:delibrary/src/model/secondary/property.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExchangeServices extends Services {
  ExchangeServices()
      : super(BaseOptions(
            baseUrl: "https://delibrary.herokuapp.com/v1/",
            connectTimeout: 20000,
            receiveTimeout: 20000));

  Future<Exchange> _getExchangeFromJson(
      Map<String, dynamic> json, bool isBuyer) async {
    PropertyServices propertyServices = PropertyServices();

    Book property = await propertyServices
        .getBookFromProperty(Property.fromJson(json['property']));
    Book payment = await propertyServices
        .getBookFromProperty(Property.fromJson(json['payment']));

    json['property'] = property;
    json['payment'] = payment;
    json['isBuyer'] = isBuyer;

    return Exchange.fromJson(json);
  }

  // TODO: could be moved to exchangelist if the server sends an object and not an array
  Future<ExchangeList> _getExchangeListFromJsonList(
      List<dynamic> jsonList, bool isBuyer) async {
    List<Exchange> items = [];
    for (Map json in jsonList)
      items.add(await _getExchangeFromJson(json, isBuyer));

    return ExchangeList(items: items);
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

        Exchange exchange = await _getExchangeFromJson(response.data, true);
        session.addExchange(exchange);
        showSnackBar(context, ConfirmMessage.exchangeAdded);
      },
    );
  }

  DelibraryAction refuse(Exchange exchange) {
    //TODO: ask for confirmation
    return DelibraryAction(
      text: "Rifiuta lo scambio",
      execute: (BuildContext context) async {
        Session session = context.read<Session>();

        try {
          await dio.put("exchanges/${exchange.id}/refuse");
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
        session.refuseExchange(exchange);
        showSnackBar(context, ConfirmMessage.exchangeRefused);
      },
    );
  }

  DelibraryAction remove(Exchange exchange) {
    //TODO: ask for confirmation
    return DelibraryAction(
      text: "Annulla lo scambio",
      execute: (BuildContext context) async {
        Session session = context.read<Session>();

        try {
          await dio.delete("exchanges/${exchange.id}");
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

  DelibraryAction agree(Exchange exchange, Book payment) {
    return DelibraryAction(
        text: "Accetta lo scambio",
        execute: (BuildContext context) async {
          Session session = context.read<Session>();

          try {
            await dio.put("exchanges/${exchange.id}/agree",
                data: payment.property.toJson());
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

          session.agreeExchange(exchange, payment);
          showSnackBar(context, ConfirmMessage.exchangeAgreed);
        });
  }

  DelibraryAction happen(Exchange exchange) {
    return DelibraryAction(
      text: "Scambio completato",
      execute: (BuildContext context) async {
        Session session = context.read<Session>();

        try {
          await dio.put("exchanges/${exchange.id}/happen");
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

        session.happenExchange(exchange);
        showSnackBar(context, ConfirmMessage.exchangeHappened);
      },
    );
  }

  Future<void> updateSession(BuildContext context) async {
    print("[Exchange services] Getting exchanges from Delibrary...");

    Response responseB, responseS;
    Session session = context.read<Session>();
    String username = session.user.username;

    try {
      responseB = await dio.get("users/$username/exchanges/buyer");
      responseS = await dio.get("users/$username/exchanges/seller");
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
    ExchangeList buyerList =
        await _getExchangeListFromJsonList(responseB.data, true);
    ExchangeList sellerList =
        await _getExchangeListFromJsonList(responseS.data, false);
    session.exchanges = ExchangeList(items: [
      ...buyerList.toList(),
      ...sellerList.toList(),
    ]);
  }
}
