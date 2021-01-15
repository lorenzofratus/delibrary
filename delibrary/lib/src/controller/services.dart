import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Services {
  final Dio dio = new Dio();

  Services(BaseOptions dioOptions, [bool externalServices = false]) {
    dio.options = dioOptions;
    if (!externalServices)
      dio.interceptors.add(InterceptorsWrapper(
        // Add the delibrary-cookie to all the requests
        onRequest: (Options options) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String cookie = prefs.getString("delibrary-cookie");
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
}
