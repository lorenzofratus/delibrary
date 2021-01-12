import 'package:delibrary/src/controller/services.dart';
import 'package:dio/dio.dart';

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

  void insertTown(String province, String town) {
    province = province.toLowerCase();
    town = town.toLowerCase();
    if (!_provinces.containsKey(province)) _provinces[province] = List();
    _provinces[province].add(town);
  }

  Future<Map> loadProvinces() async {
    Response response;

    print(
        "[Position services] Downloading provinces and towns from comuni ita API...");

    try {
      response = await dio.get("comuni");
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        throw Exception(
            "Comuni ITA API server responded with ${e.response.statusCode}");
      } else {
        print(e.request);
        print(e.message);
        throw Exception(
            "Error while setting up or sending the request to Comuni ITA API");
      }
    }

    (response.data as List).forEach((element) {
      insertTown(element["provincia"], element["nome"]);
    });
    return _provinces;
  }
}
