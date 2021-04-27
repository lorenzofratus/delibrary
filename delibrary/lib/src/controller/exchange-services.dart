import 'package:delibrary/src/controller/services.dart';
import 'package:delibrary/src/model/exchange-list.dart';
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

  Future<void> updateSession(BuildContext context) async {
    print("[Exchange services] Getting properties from Delibrary...");

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
    ExchangeList exchangeList = ExchangeList.fromJson(response.data);

    // TODO **IMPORTANT** You have not retrieved the information about the books
    // insiede the properties of the exchange.
    print(exchangeList);
  }
}
