import 'package:delibrary/src/controller/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PositionServices extends Services {
  PositionServices()
      : super(
          BaseOptions(
            baseUrl: "https://comuni-ita.herokuapp.com/api/",
            connectTimeout: 10000,
            receiveTimeout: 10000,
          ),
          true,
        );

  Map<String, List<String>> _provinces = Map();

  void _insertTown(String province, String town) {
    province = cleanParameter(province, uriEncode: false);
    town = cleanParameter(town, uriEncode: false);
    if (!_provinces.containsKey(province)) _provinces[province] = [];
    _provinces[province].add(town);
  }

  // Returns null in case of error
  Future<Map> loadProvinces(BuildContext context) async {
    Response response;

    print(
        "[Position services] Downloading provinces and towns from comuni ita API...");

    try {
      response = await dio.get("comuni");
    } on DioError catch (e) {
      if (e.response != null) {
        errorOnResponse(e, false);
        showSnackBar(context, ErrorMessage.externalServiceError);
      } else {
        errorOnRequest(e, false);
        showSnackBar(context, ErrorMessage.checkConnection);
      }
      // Return null, to be handled by the receiver
      return null;
    }

    // List fetched correctly, parse and return
    (response.data as List).forEach((element) {
      _insertTown(element["provincia"], element["nome"]);
    });
    return _provinces;
  }
}
