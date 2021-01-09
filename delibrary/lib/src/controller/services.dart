import 'package:dio/dio.dart';

abstract class Services {
  final Dio dio = new Dio();

  Services(BaseOptions dioOptions) {
    dio.options = dioOptions;
  }

  String cleanParameter(String parameter, {bool caseSensitive = false}) {
    parameter = parameter.trim();
    if (!caseSensitive) parameter = parameter.toLowerCase();
    parameter = Uri.encodeComponent(parameter);
    return parameter;
  }
}
