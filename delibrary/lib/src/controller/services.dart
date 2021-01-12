import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Services {
  final Dio dio = new Dio();

  Services(BaseOptions dioOptions, [bool externalServices = false]) {
    dio.options = dioOptions;
    if (!externalServices)
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (Options options) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String cookie = prefs.getString("delibrary-cookie");
          dio.interceptors.requestLock.lock();
          options.headers["cookie"] = cookie;
          dio.interceptors.requestLock.unlock();
          return options;
        },
      ));
  }

  String cleanParameter(String parameter, {bool caseSensitive = false}) {
    parameter = parameter.trim();
    if (!caseSensitive) parameter = parameter.toLowerCase();
    parameter = Uri.encodeComponent(parameter);
    return parameter;
  }
}
