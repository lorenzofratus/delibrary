import 'package:delibrary/src/controller/book-services.dart';
import 'package:delibrary/src/controller/services.dart';
import 'package:delibrary/src/model/book.dart';
import 'package:delibrary/src/model/exchange-list.dart';
import 'package:delibrary/src/model/exchange.dart';
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

  Future<ExchangeList> _getExchangesFromTempExchanges(
      List<TempExchange> tempExchangeList) async {
    print(
        "[Exchange services] Getting info for each book from Google Books...");
    List<Exchange> exchangeList = [];
    BookServices bookServices = BookServices();

    await Future.forEach(tempExchangeList, (tempExchange) async {
      Book property = await bookServices.getById(tempExchange.property.bookId);
      Book payment = tempExchange.payment != null
          ? await bookServices.getById(tempExchange.payment.bookId)
          : null;
      exchangeList.add(Exchange.fromTemp(tempExchange, property, payment));
    });

    return ExchangeList(items: exchangeList);
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
